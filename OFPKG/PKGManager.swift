//
//  PkgManager.swift
//  gerental
//
//  Created by 刘思源 on 2023/2/22.
//

import Foundation
import Alamofire
import HandyJSON
import ZipArchive


typealias ResultBlock = (PKGInfo?,Error?)->()


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




@objcMembers class PKGManager : NSObject {
    static let unzipPath = kDocumentPath + "/unzip"
    static let zipPath = kDocumentPath + "/zip"
    //static var updateCompletedHandler : ((PKGInfo) ->())?
    
//    static var newestPkg: PKGInfo{
//        pkgInfos.sorted(by: \PKGInfo.version).last!
//    }
    
//    static var pkgInfos = [PKGInfo]()
//    #if DEBUG
    static let versionRequestURL =  "https://static.zuhaowan.com/client/download/fe-hot-update-elec/h5app-500180009/debug/last.json"
//    #else
//    static let versionRequestURL =  "https://static.zuhaowan.com/client/download/fe-hot-update-elec/h5app-500180009/release/last.json"
//    #endif
    
    //B面是后台控制
    
    //资源包是前端
    
    
    static func getNewVersion(_ result:@escaping ResultBlock){
        let request = AF.request(versionRequestURL, method: .get)
        var urlRequest = try! request.convertible.asURLRequest()
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        AF.request(urlRequest).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dic = value as? NSDictionary{
                    var baseURL = dic["baseUrl"] as! String
                    let data = dic["data"] as! Dictionary<String, Dictionary<String,Any>>
                    guard let pkgDic = data[kAppVersion] else {
                        result(nil,BaseError(message: "没有对应的版本"))
                        return
                    }
                    
                    guard let pkg = JSONDeserializer<PKGInfo>.deserializeFrom(dict: pkgDic) else {return}
                    pkg.appVersion = kAppVersion
                    if !baseURL.hasSuffix("/") {
                        baseURL = baseURL + "/"
                    }
                    pkg.baseUrl = baseURL
                    print(">>>\(pkg.appVersion) \(pkg.downloadedPath), \(pkg.unzippedPath), \(pkg.downloaded), \(pkg.unzipped)")
                    if pkg.unzipped{
                        //下载并解压完成
                        result(pkg,nil)
                       return
                    }
                    if pkg.downloaded{
                        guard let za = ZipArchive(fileManager: .default) else {return}
                        if (za.unzipOpenFile(pkg.downloadedPath)){
                            if !FileManager.default.fileExists(atPath: pkg.unzippedPath){
                                try? FileManager.default.createDirectory(atPath: pkg.unzippedPath, withIntermediateDirectories: true)
                            }
                            za.unzipFile(to: pkg.unzippedPath, overWrite: true)
                            result(pkg,nil)
                        }
                        return
                    }
                    //下载并解压
                    downloadPKG(pkg, result)

                }
            case .failure(let error):
                result(nil,error)
            }
        }
        
    }
    //
    
    
    
    static func downloadPKG(_ pkg: PKGInfo, retryCount: Int = 3, _ result:@escaping ResultBlock){
        
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
                        result(pkg,nil)
                    }
                }else{
                    //校验不通过 重新下载
                    if retryCount == 0 {
                        result(pkg,BaseError(message: "下载文件失败"))
                        return
                    }
                    let newCount = retryCount - 1
                    downloadPKG(pkg, retryCount:newCount, result)
                }
            }
        }
    }
    
    
}
