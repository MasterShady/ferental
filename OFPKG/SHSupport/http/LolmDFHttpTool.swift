//
//  DFNetManager.swift
//  DoFunNew
//
//  Created by mac on 2020/12/23.
//

import UIKit

import Alamofire

let LolmDF_HttpErrorDescription = "网络不稳定，请稍后重试"
let LolmDF_JSONErrorDescription = "数据解析失败"
protocol LolmDF_HttpParam_ProviderDelegate {
    
    func getToken() -> String?
    
    
}


//网络配置单例类
class LolmDFHttpSession: Session {
    
    
    static var shared:LolmDFHttpSession?
    
    
    class func shareManager(timeOutFlo:TimeInterval = 60) -> LolmDFHttpSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeOutFlo
        
        
        if shared == nil {
            shared = LolmDFHttpSession.init(configuration: config)
        }
        
        return shared!;
    }
    
    
    var paramProvider:LolmDF_HttpParam_ProviderDelegate?
    
}

typealias HttpEnvType =  Int

extension Int {
     static var DFHttpTest = 1
     static var DFHttpPre = 2
     static var DFHttpPro = 3
}

enum LOLDF_APIEnv {

    typealias BaseURL = String
    
    case test(BaseURL)
    case pre_release
    case release
    
    func rawValue() -> HttpEnvType  {
         
        switch self {
        
        case .test:
            
            return .DFHttpTest
        case .pre_release:
            
            return .DFHttpPre
        case .release:
            
            return .DFHttpPro
        }
    }
    
}

struct LolmDFHttpConfig {
      
    static var shared:LolmDFHttpConfig = .init()
    var env:LOLDF_APIEnv = .release
    
    static func config(withEnv:LOLDF_APIEnv)  {
        shared.env = withEnv
    }
    
    
    func getHost() -> String {
        switch env {
       
        case .test(let baseUrl):
            return baseUrl
            //return "http://39.98.193.35:\(int)/"
        case .pre_release:
            
            return kPreviewReleaseServer
        case .release:
            
            return kReleaseServer
        }
        
        
    }
}


class LolmDFNetStatusMonitor {
       
    static var `default`:LolmDFNetStatusMonitor = .init()
    
    private var  _netUseable:Bool = true
    
    var netStatusNotification:Notification.Name {
        
        
        return Notification.LolmDF_Netstatus_notification.name
    }
    
    var changeBlock:((Bool)->())?
    
    var netUseable:Bool {
        
        get{
            
            if isWorking {
                
                return _netUseable
            }else{
                
                return true
            }
        }
    }
    
    var isWorking:Bool = false
    
    func start()  {
        
        guard isWorking == false else {
            
            return
        }
        
        let block:(Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus) -> Void = {(status) in
            
            
            switch status {
            case .notReachable,.unknown:
                
                print("断网")
                self._netUseable = false
                self.changeBlock?(false)
                NotificationCenter.default.post(name: self.netStatusNotification, object: nil, userInfo: ["status":false])
            
            default:
               
                print("正常状态")
               
                self._netUseable = true
                
                self.changeBlock?(true)
                
                NotificationCenter.default.post(name: self.netStatusNotification, object: nil, userInfo: ["status":true])
            }
        }
        
        Alamofire.NetworkReachabilityManager.default?.startListening(onUpdatePerforming: block)
        
        isWorking = true
    }
    
    func stop()  {
        
        guard isWorking == true else {
            
            return
        }
        
        Alamofire.NetworkReachabilityManager.default?.stopListening()
        
        isWorking = false
        
        self._netUseable = true
        
        self.changeBlock?(true)
    }
    
    
    
}



