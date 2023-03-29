//
//  DFNetworkingTool.swift
//  DoFunNew
//
//  Created by mac on 2020/12/23.
//




import UIKit
import Alamofire
import DFBaseLib
import HandyJSON
import MBProgressHUD


typealias SuccessBlock = (_ response: String) -> Void
typealias FailureBlock = (_ error: String) -> Void

typealias FSResponseSuccess = (_ response: String) -> Void
typealias FSResponseFail = (_ error: String) -> Void
typealias FSNetworkStatus = (_ NetworkStatus: Int32) -> Void
typealias FSProgressBlock = (_ progress: Int32) -> Void



class LolmDFApiNoDATAModel:HandyJSON {
    
    var status:Int!
    
    var message:String = ""
    
    required init() {
        
        
    }
}




class LolmDFHttpUtil: NSObject {
    static private var isFirst:Bool = true
    private static func httpHeaders() -> HTTPHeaders {
        let versionStr = PKGManager.config.appVersion
        var header:HTTPHeaders = HTTPHeaders.init()
        header["os"] = "iOS"
        header["Content-Type"] = "application/json;charset=UTF-8"
        header["version"] = versionStr
        return header
    }
    
    
    
    
    //逃逸闭包(@escaping )与非逃逸闭包(@noescaping)
    //Function types cannot have argument labels; use '_' before 'err'  去掉闭包参数的参数名
    /// 网络请求 get/post
    ///
    /// - Parameters:
    ///   - url: 链接
    ///   - method: get/post
    ///   - parameters: 参数列表
    ///   - showLoading: 是否显示loading true显示 false不显示
    ///   - succ: 请求成功 jsonStr:获取结果的json字符串。headerJsonStr:获取的header的json字符串 将返回的所有数据都返回过去，方便以后取responseHeader中的内容
    ///   - fail: 请求失败 errStr:经过处理的错误信息  err:未经整理的错误信息
    @discardableResult
    public static func lolm_dohttpTask(url:String, method:HTTPMethod, parameters:Parameters?, showLoading:Bool = true, view:UIView = UIApplication.shared.delegate!.window!!,ignoreCode_1:Bool = false, successBlock:@escaping SuccessBlock, failBlock:@escaping  FailureBlock) -> DataRequest? {
        
        if showLoading {//展示loading
            LolmDFHttpUtil.referenceCountChangeFun(isAdd: true,view: view)
        }
        
        var urlStr:String = LolmDFHttpConfig.shared.getHost() + url
        
        let header = self.httpHeaders()
        
        let encoding:ParameterEncoding = URLEncoding.queryString
        
        if method == HTTPMethod.get {
            let theStr:NSString = NSString.init(string: urlStr)
            urlStr = theStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        
        //添加共用参数
        var publicParams = [String:Any]()
        
        publicParams["auth_version"] = "101"
        publicParams["secure_version"] = "101"
        publicParams["app_id"] = PKGManager.config.appId
        publicParams["app_channel"] = "appstore"
        
        let versionName:String = PKGManager.config.appVersion
        let versionCode = versionName.replacingOccurrences(of: ".", with: "")
        publicParams["app_version_code"] = versionCode
        publicParams["app_version_name"] = versionName
        publicParams["device-ident"] = LolmDF_uuid()
        //添加token
        
        if let token:String = LolmDFHttpSession.shareManager().paramProvider?.getToken(), token.count > 0 {
            publicParams["token"] = token
            publicParams["auth_token"] = token
        } else {
            publicParams["token"] = ""
            publicParams["auth_token"] = ""
        }
        
        
        //合并参数
        for (key, value) in parameters! {
            publicParams[key] = value
        }
        
        
        let signedParam  = DFHttpSign_Alamofire(withKey: PKGManager.config.httpSignKey, withparam: publicParams)
        
        
        var paramsList:Array = [String]()
        signedParam.forEach { (arg0) in
            let (key, value) = arg0
            if let v_bool = value as? Bool {
                let str:String = "\(key)=\(v_bool ? "1":"0")"
                paramsList.append(str)
            }else{
                let str:String = "\(key)=\(value)"
                paramsList.append(str)
            }
            
        }
        
        LolmDFLog(msg: "当前请求url === " + urlStr + "?" + paramsList.joined(separator: "&"))
        
        
        return  LolmDFHttpSession.shareManager().request(urlStr, method: method, parameters: signedParam, encoding: encoding, headers: header).responseString { (response) in
            if showLoading {
                LolmDFHttpUtil.referenceCountChangeFun(isAdd: false,view: view)
            }
            switch response.result {
            case let .success(jsonstr):
                
                if let model = JSONDeserializer<LolmDFApiNoDATAModel>.deserializeFrom(json: jsonstr) {
                    
                    if model.status == -1 && ignoreCode_1 == false {
                        
                        //loginTokenTimeOut()
                        
                    }else{
                        
                        successBlock(jsonstr)
                    }
                }else{
                    
                    let statusCode:Int = response.response?.statusCode ?? 0
                    failBlock(String(statusCode))
                }
                
                
            case .failure:
                
                failBlock("网络不稳定，请稍后重试")
            }
        }
    }
    
    
    
    
    
    //    // loading 管理
    //    ///
    //    /// - Parameter isAdd: 是否显示loading true引用计数加一 false引用计数减一
    //UIApplication.shared.delegate!.window!
    private static func referenceCountChangeFun(isAdd:Bool,view:UIView = UIView()) {
        
        if isAdd {
            LolmDFConst_NetReferenceCount += 1
            if LolmDFConst_NetReferenceCount == 1 {
                DispatchQueue.main.async {
                    MBProgressHUD.showCustomToast(message: "", view: view, customView: LolmDFLoadingWidget())
                }
            }
        }else {
            LolmDFConst_NetReferenceCount -= 1
            if LolmDFConst_NetReferenceCount <= 0 {
                LolmDFConst_NetReferenceCount = 0
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        LolmDFLoadingWidget().animationStop()
                        //                        多个view同时显示hud，隐藏失败
                        MBProgressHUD.hide(for: view, animated: true)
                        //
                        //                        _swhub?.hide(animated: true)
                        //
                        //                        _swhub = nil
                    }
                }
            }
        }
    }
    
    
    
}
