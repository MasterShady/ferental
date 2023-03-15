//
//  SWLGToast.swift
//  DFToGameLib
//
//  Created by mac on 2021/12/8.
//



import MBProgressHUD
import DFBaseLib
import Alamofire
import DFOCBaseLib
import HandyJSON

typealias SuccessBlock = (_ response: String) -> Void
typealias FailureBlock = (_ error: String) -> Void

func showTextHudTips(message:String)  {
    
    MBProgressHUD.show(text: message)
}


func SWAPPVersion() ->String  {
    
    if let version = SWOtherInfoWrap.shared.appversion {
        
        return version
    }else{
        
        let info = Bundle.main.infoDictionary
        
        return info?.getValue(key: "CFBundleShortVersionString", t: String.self) ?? "1.0.0"
    }
    
    
}


func SWAPP_OPENSetPage()  {
     
    let url = URL(string: UIApplication.openSettingsURLString)!
    
    if UIApplication.shared.canOpenURL(url) {
        
        UIApplication.shared.open(url)
    }
}

func APPDELEGATE() -> UIApplicationDelegate {
   
    return  UIApplication.shared.delegate!
     
}


func AppgetToken(withApi:String) ->(String,String) {
     
    if SWOtherInfoWrap.shared.channel == .dfapp {
        
        
        return ("token",SWOtherInfoWrap.shared.token)
        
    }else{
        
        let code = SWOtherInfoWrap.shared.token
        
        let time = Int(NSDate().timeIntervalSince1970)
        
        let key = SW_API_TOKEN_MAP[withApi]!
        
        let str = "\(key)\(time)\(code!)"
        
        SWLGLog(withMsg: "apitoken--\(str)")
        return ("api_token",str.swMD5Encrypt(.lowercase32))
        
    }
}





func APPUUID() ->String {

    return SWOtherInfoWrap.shared.uuid
}

func websocket_Url() -> URL  {
    
   let versionName = SWAPPVersion()
   let versionCode = versionName.replacingOccurrences(of: ".", with: "")
   let appid = SWOtherInfoWrap.shared.appId
    
    
    switch SimpleHttp.default.api_env {
    case .release:
        
        return .init(string: "wss://heartbeat.zuhaowan.com?app_version_name=\(versionName)&app_id=\(appid)&app_version_code=\(versionCode)")!
    default:
        
        return .init(string: "ws://39.98.193.35:9505?app_id=\(appid)&app_version_code=\(versionCode)&app_version_name=\(versionName)")!
    }
    
   
    
    
}

func zhongtai_aesKey() -> String  {
    
    if SimpleHttp.default.api_env == .release {
        
       return "gMmb8PXBCYyc9CPRx0BMvyPUqVD4ayqH"
    }else{
        
        return "WYdvTDlB/OOXQM5v9V6LwU/rUVQARIF1"
    }
}

func SW_mainthread_call(with:@escaping ()->())  {
    
    DispatchQueue.main.async {
        
        with()
    }
}


func zhongTai_data<T:HandyJSON>(data:String,tp:T.Type) ->T? {
    
     let json = DFAES.aes256DecryptECB(data, key: zhongtai_aesKey())
     SWLGLog(withMsg: "数据解密\(json)")
     return SWjd<T>.deserializeFrom(json: json)
     
    
}

class SWNetworkingTool {
    

    public static func requestFun(url:String, method:HTTPMethod, parameters:Parameters?, showLoading:Bool = true, successBlock:@escaping SuccessBlock, failBlock:@escaping  FailureBlock) {
        
       
        
        let service  = MJHttpService.init()
        service.api = url
        service.httpMethod = method
        service.param = parameters ?? [:]
        
        
        
        var hud:MBProgressHUD?
        
        if showLoading == true, let currentWindow = APPDELEGATE().window! {
  
            hud = MBProgressHUD.showAdded(to: currentWindow , animated: true)
           
        }
        
        SimpleHttp.default.httpTask(service) { (result) in
            
            hud?.hide(animated: true)
 
            switch result {
            
            case .netError:
                 
                failBlock("")
            
          
            case .succese( let data ):
                
                
                successBlock(data)
                
            }
        }
        
    }
}


func df_base64DecodeString(with:String) -> String? {
    
    guard let data =  Data(base64Encoded: with) else {
        
        return nil
    }
    
    return String(data: data, encoding: .utf8)
}


func df_base64Encode(with:String) -> Data? {
    
    return with.data(using: .utf8)?.base64EncodedData()
}

func df_getImage( withName:String,adjsut:Bool = true) -> UIImage? {
    
   
    let bundlePath = getCurrentBundle().bundlePath
    
    
    var adjust_des = ""
    
    if adjsut {
        
        adjust_des = "@" + Int(UIScreen.main.scale).description + "x"
        
    }
    
    let path_iamge = "\(bundlePath)/\(withName)\(adjust_des).png"
    
    return UIImage(contentsOfFile: path_iamge)
    
    
}
