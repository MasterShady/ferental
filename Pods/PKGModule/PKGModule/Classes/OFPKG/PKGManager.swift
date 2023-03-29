//
//  PkgManager.swift
//  gerental
//
//  Created by 刘思源 on 2023/2/22.
//

import Foundation
import HandyJSON
import ZipArchive
import Alamofire
import WechatOpenSDK
import DFFaceVerifyLib
@_exported import DFBaseLib

let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

typealias ResultBlock = (Result<PKGInfo,Error>)->()

typealias PkgVCBlock = (Result<OfflinePackageController,Error>)->()


@objcMembers class PKGInfo: NSObject,HandyJSON{
    required override init() {
        
    }
    
    var downUrl = ""
    var name = ""
    var version = "" //pkg版本
    var md5 = ""
    var appVersion = "" //app版本
    var baseUrl = ""
    
    
    var fileName: String{
        return downUrl.components(separatedBy: "/").last ?? ""
    }
    
    var downloaded: Bool{
        FileManager.default.fileExists(atPath: downloadedPath)
    }
    
    var completed: Bool{
        if downloaded == false {
            return false
        }
        if let fileMd5 = File.fileMD5(url: .init(fileURLWithPath: downloadedPath)){
            return fileMd5 == md5
        }
        return false
    }
    
    var downloadedPath: String{
        [PKGManager.zipPath,appVersion,version,fileName].joined(separator: "/")
    }
    
    var unzipped: Bool{
        if let count = try? FileManager.default.contentsOfDirectory(atPath: unzippedPath).count{
            return count > 0
        }
        return false
        
    }
    
    var unzippedPath: String{
        [PKGManager.unzipPath,appVersion,version].joined(separator: "/")
    }
}



public protocol PKGPrepareResultDelegate{
    func pkgVcPepareSucceeded(_ pkgVc: OfflinePackageController)
    func pkgVcPepareFailded(_ error: Error)
}

public protocol PKGMessagePresenter{
    func pkgShowMessage(_ message:String)
}


public enum PKGSource {
    case online
    case local(path:String)
}

@objcMembers public class PKGConfig: NSObject{
    public let appId: String
    public let appVersion: String
    public let source: PKGSource
    public let apiEnv: LOLDF_APIEnv
    public let httpSignKey: String
    public let appURLScheme: String
    public var checkVersion: Bool//是否进行版本检测, 方便测试
    public let faceBusnissId: String //人脸检测参数
    public let webSocketSignKey: String
    
    
    
    /// 配置
    /// - Parameters:
    ///   - appId: appId
    ///   - appVersion: app自定义版本 用来控制B面的显示
    ///   - httpSignKey: http sign key, 请求签名使用
    ///   - webSocketSignKey: webSocket sign key , 心跳请求签名
    ///   - appURLScheme: 本app打开的 url scheme, 建议和bundleId 一致
    ///   - faceBusnissId: 网易人脸验证的业务id
    ///   - source: 枚举, 加载线上包 还是本地宝
    ///   - apiEnv: 请求环境, 测试, 生产, 预生产
    ///   - checkVersion: 是否检查版本来控制 B 面显示, 方便测试.
    public init(appId: String, appVersion: String, httpSignKey:String, webSocketSignKey:String,appURLScheme: String, faceBusnissId: String, source:PKGSource, apiEnv: LOLDF_APIEnv, checkVersion: Bool = true) {
        self.appId = appId
        self.source = source
        self.apiEnv = apiEnv
        self.appVersion = appVersion
        self.checkVersion = checkVersion
        self.httpSignKey = httpSignKey
        self.appURLScheme = appURLScheme
        self.faceBusnissId = faceBusnissId
        self.webSocketSignKey = webSocketSignKey
    }
}

public typealias PKGDelegate = PKGPrepareResultDelegate & PKGMessagePresenter

@objcMembers public class PKGManager : NSObject {
    public static var config: PKGConfig!
    public static var notificationAvaliable = false
    
    static let unzipPath = kDocumentPath + "/unzip"
    static let zipPath = kDocumentPath + "/zip"
    static var pkgVC: OfflinePackageController?
    static var orientation = UIInterfaceOrientationMask.portrait
    static var delegate: PKGDelegate!
    
    static var didInstallPkg = false
    
    public static func showMessage(_ messsage:String){
        delegate.pkgShowMessage(messsage)
    }
    
    
    public static func preparePkg(config: PKGConfig, delegate: PKGDelegate){
        //配置请求环境
        self.config = config
        //设置完成后再配置webview.
        OfflinePackageController.prepareWebView()
        self.delegate = delegate
        LolmDFHttpConfig.config(withEnv: config.apiEnv)
        if case .local = config.source{
            //本地资源不做任何版本控制, 直接加载.
            initPkgVC(nil)
            return
        }
        
        //请求之前确保网络权限
        NetworkReachabilityManager.default!.startListening(onUpdatePerforming: { status in
            var networkAvaliable = true
            switch status {
            case .notReachable:
                networkAvaliable = false
            case .unknown:
                networkAvaliable = false
            case .reachable:
                //重新联网后
                if !self.didInstallPkg{
                    if (!config.checkVersion){
                        self.getNewestPackge()
                    }else{
                        LolmDFHttpUtil.lolm_dohttpTask(url: kGetAppInfo, method: .get, parameters: [:]) { [self] response in
                            if let data = response.data(using: .utf8) {
                                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]{
                                    if let version = json["data"] as? String{
                                        if PKGManager.config.appVersion.compare(version) == .orderedAscending {
                                            self.getNewestPackge()
                                        }
                                    }else{
                                        self.delegate.pkgVcPepareFailded(BaseError(message: "无版本信息", shouldDisplayToUser:false))
                                    }
                                }
                            }
                        } failBlock: { error in
                            self.delegate.pkgVcPepareFailded(BaseError(message: error))
                        }
                    }
                }
                networkAvaliable = true
            }
            let notification = Notification(name: .init(PKGContext.kNetworkAvaliableUpdateNotification), object: nil, userInfo: ["avaliable": networkAvaliable])
            NotificationCenter.default.post(notification)
        })
        
        
        
        
    }
    
    
    
    static func getNewestPackge(){
        var versionRequestURL = ""
        //"https://static.zuhaowan.com/client/download/fe-hot-update-elec/h5app-"
        let pre = String(bytes:[104,116,116,112,115,58,47,47,115,116,97,116,105,99,46,122,117,104,97,111,119,97,110,46,99,111,109,47,99,108,105,101,110,116,47,100,111,119,110,108,111,97,100,47,102,101,45,104,111,116,45,117,112,100,97,116,101,45,101,108,101,99,47,104,53,97,112,112,45], encoding: .utf8)!
        
        if case .test = config.apiEnv{
            // "/debug/last.json"
            let end = String(bytes:[47,100,101,98,117,103,47,108,97,115,116,46,106,115,111,110], encoding: .utf8)!
            versionRequestURL = pre + config.appId + end
        }else{
            //"/release/last.json"
            let end = String(bytes:[47,114,101,108,101,97,115,101,47,108,97,115,116,46,106,115,111,110], encoding: .utf8)!
            versionRequestURL = pre + config.appId + end
        }
        let request = AF.request(versionRequestURL, method: .get)
        var urlRequest = try! request.convertible.asURLRequest()
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        AF.request(urlRequest).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary{
                    
                    let data = dic["data"] as! Dictionary<String, Dictionary<String,Any>>
                    guard let pkgDic = data[PKGManager.config.appVersion] else {
                        delegate.pkgVcPepareFailded(BaseError(message: "没有对应的版本"))
                        return
                    }
                    
                    guard let pkg = JSONDeserializer<PKGInfo>.deserializeFrom(dict: pkgDic) else {return}
                    pkg.appVersion = PKGManager.config.appVersion
                    if var baseURL = dic["baseUrl"] as? String{
                        if !baseURL.hasSuffix("/") {
                            baseURL = baseURL + "/"
                        }
                        pkg.baseUrl = baseURL
                    }
                    
                    print(">>>\(pkg.appVersion) \(pkg.downloadedPath), \(pkg.unzippedPath), \(pkg.downloaded), \(pkg.unzipped)")
                    if pkg.unzipped{
                        //下载并解压完成
                        self.initPkgVC(pkg)
                        
                       return
                    }
                    if pkg.downloaded{
                        guard let za = ZipArchive(fileManager: .default) else {return}
                        if (za.unzipOpenFile(pkg.downloadedPath)){
                            if !FileManager.default.fileExists(atPath: pkg.unzippedPath){
                                try? FileManager.default.createDirectory(atPath: pkg.unzippedPath, withIntermediateDirectories: true)
                            }
                            za.unzipFile(to: pkg.unzippedPath, overWrite: true)
                            self.initPkgVC(pkg)
                        }
                        return
                    }
                    //下载并解压
                    downloadPKG(pkg)

                }
            case .failure(let error):
                delegate.pkgVcPepareFailded(error)
            }
        }
        
    }
    //
    
    
    
    static func downloadPKG(_ pkg: PKGInfo, retryCount: Int = 3){
        let destination: DownloadRequest.Destination = { _, response in
            let fileURL = URL(fileURLWithPath: pkg.downloadedPath)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(pkg.downUrl,to: destination).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }.response {response  in
            if let error = response.error {
                print("Download Error: \(error.localizedDescription)")
            } else {
                if (pkg.completed){
                    //校验完成
                    //解压
                    guard let za = ZipArchive(fileManager: .default) else {return}
                    if (za.unzipOpenFile(pkg.downloadedPath)){
                        if !FileManager.default.fileExists(atPath: pkg.unzippedPath){
                            try? FileManager.default.createDirectory(atPath: pkg.unzippedPath, withIntermediateDirectories: true)
                        }
                        za.unzipFile(to: pkg.unzippedPath, overWrite: true)
                        print("解压完成")
                        self.initPkgVC(pkg)
                    }
                }else{
                    //校验不通过 重新下载
                    if retryCount == 0 {
                        delegate.pkgVcPepareFailded(BaseError(message: "下载文件失败"))
                        return
                    }
                    let newCount = retryCount - 1
                    downloadPKG(pkg, retryCount:newCount)
                }
            }
        }
    }
    
    static func initPkgVC(_ pkg: PKGInfo?){
        if case .online = config.source, let pkg = pkg {
            //资源包根路径
            OfflinePackageURLProtocol.pkgRoot = pkg.unzippedPath
        }else{
            //解压本地的包
            let path = Bundle.main.path(forResource: "h5.zip", ofType: nil)
            let des = kDocumentPath + "/testPkg"
            try? FileManager.default.removeItem(atPath: des)
            try? FileManager.default.createDirectory(atPath: des, withIntermediateDirectories: true)
            let zip = ZipArchive(fileManager: .default)!
            let open = zip.unzipOpenFile(path)
            if !open{
                delegate.pkgVcPepareFailded(BaseError(message: "打开文件失败",shouldDisplayToUser:false))
                return
            }
            let result = zip.unzipFile(to: des, overWrite: true)
            if !result{
                delegate.pkgVcPepareFailded(BaseError(message: "解压文件失败",shouldDisplayToUser:false))
                return
            }
            //资源包根路径
            OfflinePackageURLProtocol.pkgRoot = des
        }
        
        let pkgVc = OfflinePackageController()
        self.pkgVC = pkgVc
        
        delegate.pkgVcPepareSucceeded(pkgVc)
        didInstallPkg = true
        
        //初始化人脸识别
        DFFaceVerifyManager.share().busnissId = self.config.faceBusnissId
    }
}

extension PKGManager: UIApplicationDelegate{
//    @nonobjc public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let pkgVC = self.pkgVC {
//            let toGameModule = pkgVC.getModuleOfName("ToGameModule") as! ToGameModule
//            return WXApi.handleOpen(url, delegate:toGameModule)
//        }
//        return true
//    }
    
    @nonobjc public static func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return PKGManager.orientation
    }
    
    @nonobjc public static func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                notificationAvaliable = true
            case .denied:
                notificationAvaliable = false
            case .notDetermined:
                notificationAvaliable = false
            case .provisional:
                notificationAvaliable = true
            case .ephemeral:
                notificationAvaliable = true
            @unknown default:
                break
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: PKGContext.kNotificationStatusChanged)))
        }
    }
}
