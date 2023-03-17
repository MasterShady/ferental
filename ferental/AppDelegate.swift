//
//  AppDelegate.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import UIKit
import SwiftyJSON
import ZipArchive
@_exported import Alamofire
@_exported import HandyJSON
import DFFaceVerifyLib
import ShareSDK
import Moya
import AEAlertView


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var orientation = UIInterfaceOrientationMask.portrait
    
    var window: UIWindow?
    var networkAvaliable = true
    var getNewestPackgeCompleted = false
    
    var pkgVc: OfflinePackageController!
    
    static var shareDelegate: AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkReachabilityManager.default!.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                self.networkAvaliable = false
            case .unknown:
                self.networkAvaliable = false
            case .reachable:
                if self.networkAvaliable == false{
                    NotificationCenter.default.post(kUserReConnectedNetwork)
                    self.getReviewVersion()
                }
                self.networkAvaliable = true
            }
            
        })
        
        //测试环境 .test("http://39.98.193.35:9587/")
        #if DEBUG
        LolmDFHttpConfig.config(withEnv: .release)
        #else
        LolmDFHttpConfig.config(withEnv: .release)
        #endif
        
        getReviewVersion()
        DFFaceVerifyManager.share().busnissId = LolmDF_FACE_BusnissId
        initJPush(launchOptions:launchOptions)
        
        return true
    }
    
    func getReviewVersion(){
        LolmDFHttpUtil.lolm_dohttpTask(url: kGetAppInfo, method: .get, parameters: [:]) { [self] response in
            if let data = response.data(using: .utf8) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]{
                    if let version = json["data"] as? String{
                        if Global.df_version.compare(version) == .orderedAscending {
                            self.getNewestPackge()
                        }
                    }else{
                        //self.getNewestPackge()
                    }
                }
            }
        } failBlock: { error in

        }
    }
//
    
    func initJPush(launchOptions:[UIApplication.LaunchOptionsKey: Any]?){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (result, error) in
            guard error == nil && result == true else {
                return print("\(String(describing: error?.localizedDescription))")
            }
            Global.notificationAvaliable = true
            DispatchQueue.main.async {
                let entity = JPUSHRegisterEntity()
                entity.types = Int(JPAuthorizationOptions.init([.alert,.badge,.sound]).rawValue)
                JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
                JPUSHService.setup(withOption: launchOptions, appKey: kJushAppKey, channel: "appstore", apsForProduction: false)
                
            }
            
            
        }
    }
    
//    func initShare(){
//        ShareSDK.registPlatforms { register in
//            register?.setupWeChat(withAppId: LolmDF_WX_APPID, appSecret: LolmDF_WX_APPKEY, universalLink: DF_Universal_link)
//            register?.setupQQ(withAppId: LolmDF_QQ_APPID, appkey: LolmDF_QQ_APPKEY, enableUniversalLink: true, universalLink: DF_Universal_link)
//        }
//        
//        WXApi.registerApp(LolmDF_WX_APPID, universalLink: DF_Universal_link)
//        WXApi.startLog(by: .normal) { msg in
//            
//        }
//        
//    }
    
    
    func getNewestPackge(){
        PKGManager.getNewVersion { pkg, error in
            if let error = error{
                if let error = error as? BaseError{
                    AutoProgressHUD.showAutoHud(error.message)
                }
                
            }else if let pkg = pkg{
                self.getNewestPackgeCompleted = true
                #if DEBUG
                //self.debugInstallPkg(pkg)
                self.installPkg(pkg)
                #else
                self.installPkg(pkg)
                #endif
            }
        }
    }
    
    func installPkg(_ pkg: PKGInfo){
        NavVC.performWhiteNavigationBarStyle()
        OfflinePackageURLProtocol.pkgRoot = pkg.unzippedPath
        self.pkgVc = OfflinePackageController()
        let nav = NavVC(rootViewController: self.pkgVc)
        window?.rootViewController = nav
    }
    
    #if DEBUG
    func debugInstallPkg(_ pkg: PKGInfo){

        AEAlertView.show(title: "离线包更新完毕", message: "当前版本:\(pkg.version)", actions: ["取消","加载正式包","加载测试包"]) { [self] action in
            if action.title == "加载测试包"{
                print("~~ baseURL:\(pkg.baseUrl)")
                LolmDFHttpConfig.config(withEnv: .test(pkg.baseUrl))
                NavVC.performWhiteNavigationBarStyle()
                OfflinePackageURLProtocol.pkgRoot = pkg.unzippedPath
                self.pkgVc = OfflinePackageController()
                let nav = NavVC(rootViewController: self.pkgVc)
                window?.rootViewController = nav
            }
            
            if action.title == "加载正式包"{
                //                        Global.isTest = true
                //                        LolmDFHttpConfig.config(withEnv: .test(pkg.baseUrl))
                let path = Bundle.main.path(forResource: "h5.zip", ofType: nil)
                let des = kDocumentPath + "/testPkg"
                try? FileManager.default.removeItem(atPath: des)
                try? FileManager.default.createDirectory(atPath: des, withIntermediateDirectories: true)
                let zip = ZipArchive(fileManager: .default)!
                let open = zip.unzipOpenFile(path)
                if !open{
                    print("打开解压包失败")
                }
                let result = zip.unzipFile(to: des, overWrite: true)
                if !result{
                    print("解压失败")
                }
                NavVC.performWhiteNavigationBarStyle()
                OfflinePackageURLProtocol.pkgRoot = des
                self.pkgVc = OfflinePackageController()
                let nav = NavVC(rootViewController: self.pkgVc)
                window?.rootViewController = nav
            }
            
        }
    }
    #endif
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        updateNotificationStatus()
    }
    
    
    func updateNotificationStatus(){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                Global.notificationAvaliable = true
            case .denied:
                Global.notificationAvaliable = false
            case .notDetermined:
                Global.notificationAvaliable = false
            case .provisional:
                Global.notificationAvaliable = true
            case .ephemeral:
                Global.notificationAvaliable = true
            @unknown default:
                break
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Global.kNotificationStatusChanged)))
        }
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let toGameModule = self.pkgVc.getModuleOfName("ToGameModule") as! ToGameModule
        return WXApi.handleOpen(url, delegate:toGameModule)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientation
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("deviceToken:\(deviceTokenStr)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
}

extension AppDelegate : JPUSHRegisterDelegate {
    
    // MARK: JPush Delegate
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let dic = notification.request.content.userInfo
        
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            
            JPUSHService.handleRemoteNotification(dic)
        }
        
        var options:[UNNotificationPresentationOptions] = []
        
        if UIApplication.shared.applicationState != .active {
            options = [.alert,.sound,.badge]
        }
        
        if UIApplication.shared.applicationState == .active {
            options = [.alert,.sound]
        }
        
        
        completionHandler(Int(UNNotificationPresentationOptions.init(options).rawValue))
        
        
    }
    //app 进程活跃的情况下会走此方法（前台或者后台）
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        
        let dic = response.notification.request.content.userInfo
        
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            
            JPUSHService.handleRemoteNotification(dic)
        }
        //
        //dataProcessing(dic: dic)
        
        
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            print("从通知界面直接进入应用")
        }else{
            print("从通知界面直接进入应用")
        }
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
    
}


