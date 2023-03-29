//
//  AppDelegate.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import UIKit
@_exported import Alamofire
@_exported import HandyJSON
import Moya
import PKGModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var networkAvaliable = true
        
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
                }
                
            }
            
        })
        //http://39.98.193.35:9587/
        //初始化离线包配置
        let config = PKGConfig(appId: "500180009", appVersion: "1.0.0.0", httpSignKey: "x8ecLyhIl4BT7tCD", webSocketSignKey: "0n6gJtCK3I1Hv2Cs", appURLScheme: "com.dofun.youyizu", faceBusnissId: "eb9a910f5019499786c3cd6011a94dcf", source: .online, apiEnv: .release, checkVersion: true)
        
        PKGManager.preparePkg(config: config, delegate: self)
        //初始化推送
        initJPush(launchOptions: launchOptions)
        
        
        return true
    }
    
    
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
    

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("deviceToken:\(deviceTokenStr)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PKGManager.applicationWillEnterForeground(application)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return PKGManager.application(application, supportedInterfaceOrientationsFor: window)
    }
}

extension AppDelegate : PKGMessagePresenter {
    func pkgShowMessage(_ message: String) {
        AutoProgressHUD.showAutoHud(message)
    }
}
    
    
extension AppDelegate : PKGPrepareResultDelegate{
    func pkgVcPepareSucceeded(_ pkgVc: OfflinePackageController) {
        let nav = PKGModule.NavVC(rootViewController:pkgVc)
        window?.rootViewController = nav
    }
    func pkgVcPepareFailded(_ error: Error) {
        if let error = error as? BaseError{
#if DEBUG
            AutoProgressHUD.showAutoHud(error.message)
#else
            if error.shouldDisplayToUser{
                AutoProgressHUD.showAutoHud(error.message)
            }
#endif
        }else{
            AutoProgressHUD.showAutoHud(error.localizedDescription)
        }
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


