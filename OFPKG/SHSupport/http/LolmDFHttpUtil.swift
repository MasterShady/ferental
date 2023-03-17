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








class LolmDFHttpUtil: NSObject {
    static private var isFirst:Bool = true
    private static func httpHeaders() -> HTTPHeaders {
       
        let versionStr = Global.df_version
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
    public static func lolm_dohttpTask(url:String, method:HTTPMethod, parameters:Parameters?, showLoading:Bool = true, view:UIView = LolmDF_APPDELEGATE().window!,ignoreCode_1:Bool = false, successBlock:@escaping SuccessBlock, failBlock:@escaping  FailureBlock) -> DataRequest? {
        
        guard LolmDFNetStatusMonitor.default.netUseable  else {
            
            return nil
        }
        
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
        publicParams["app_id"] = Lolmdf_APPid()
        publicParams["app_channel"] = "appstore"
        
        let versionName:String = Global.df_version
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
        
        
        let signedParam  = DFHttpSign_Alamofire(withKey: DFHttpSignKey, withparam: publicParams)
        
    
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
                        
                        loginTokenTimeOut()
                        
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
    
    
    
    
    
    /// 上传资源文件数组
    /// - Parameters:
    ///   - url: 接口地址
    ///   - datas: (资源数组，资源名，文件名，mimeType)
    ///   - showLoading:
    ///   - view:
    ///   - progressBlock: 进度回调
    ///   - success: 网络成功回调
    ///   - error: 失败回调
    /// - Returns: 
//  static  func uploadRequestTask(url:String,datas:([Data],String,String,String?),showLoading:Bool = true,view:UIView,progressBlock: ((Progress)->())?, success:@escaping (String?)->(),error:@escaping (String?)->() )  {
//
//
//    let urlStr:String = LolmDFHttpConfig.shared.getHost() + url
//
//
//        if showLoading {
//
//            LolmDFHttpUtil.referenceCountChangeFun(isAdd: true, view: view)
//
//        }
//
//      //添加共用参数
//      var publicParams = [String:Any]()
//
//      publicParams["auth_version"] = "101"
//      publicParams["secure_version"] = "101"
//      publicParams["app_id"] = Lolmdf_APPid()
//      publicParams["app_channel"] = "appstore"
//
//      let versionName:String = LolmDF_VERSION()
//      let versionCode = versionName.replacingOccurrences(of: ".", with: "")
//      publicParams["app_version_code"] = versionCode
//      publicParams["app_version_name"] = versionName
//      publicParams["device-ident"] = LolmDF_uuid()
//      //添加token
//
//      if let token:String = LolmDFHttpSession.shareManager().paramProvider?.getToken(), token.count > 0 {
//          publicParams["token"] = token
//          publicParams["auth_token"] = token
//      } else {
//          publicParams["token"] = ""
//          publicParams["auth_token"] = ""
//      }
//
//
//
//      let signedParam  = DFHttpSign_Alamofire(withKey: DFHttpSignKey, withparam: publicParams);
//
//      let urlModify:(inout URLRequest) throws -> Void =  { (request) in
//
////          request.httpBody = try JSONSerialization.data(withJSONObject: signedParam)
//
//          var paramsList:Array = [String]()
//          signedParam.forEach { (arg0) in
//                      let (key, value) = arg0
//                      let str:String = "\(key)=\(value)"
//                      paramsList.append(str)
//          }
//
//          let urlStr_new = urlStr + "?" + paramsList.joined(separator: "&")
//
//          request.url = URL(string: urlStr_new)
//      }
//
//        AF.upload(multipartFormData: { (data) in
//
//
//            datas.0.enumerated().forEach { (index,tmp) in
//
//                data.append(tmp, withName: "\(datas.1)_\(index)", fileName: "complaint_\(index)_\(datas.2)", mimeType: datas.3)
//            }
//
//        }, to: urlStr,requestModifier:urlModify).uploadProgress { (progress) in
//
//            progressBlock?(progress)
//
//        }.responseString { (response) in
//
//            if showLoading {
//                LolmDFHttpUtil.referenceCountChangeFun(isAdd: false,view: view)
//            }
//
//            switch response.result {
//            case let .success(jsonstr):
//
//                if let _ = JSONDeserializer<LolmDFApiNoDATAModel>.deserializeFrom(json: jsonstr) {
//
//                    success(jsonstr)
//
//                }else{
//
//                      let statusCode:Int = response.response?.statusCode ?? 0
//                      error(String(statusCode))
//                }
//
//
//            case .failure:
//                let statusCode:Int = response.response?.statusCode ?? 0
//                error(String(statusCode))
//            }
//        }
//    }

    /// 文件上传
    ///
    /// - Parameters:
    ///   - url: 链接
    ///   - parameters: 参数
    ///   - name: 文件对应key
    ///   - fileName: fileName
    ///   - mimeType: mimeType
    ///   - imgData: 文件流
    ///   - showLoading: 是否显示loading true显示 false不显示
    ///   - succ: succ description
    ///   - fail: fail description
    
    /** 上传图片*/
      
//    public static func userHeaderImageUpload(url:String, params:Parameters?, fileConfig:LolmDFFileConfig, showLoading:Bool = true, view:UIView, progressBlock:@escaping FSProgressBlock, success:@escaping FSResponseSuccess, error:@escaping FSResponseFail) {
//
//        let urlStr:String = LolmDFHttpConfig.shared.getHost() + url
//
//        if showLoading {
//            LolmDFHttpUtil.referenceCountChangeFun(isAdd: true, view: view)
//        }
//
//      //添加共用参数
//      var publicParams = [String:Any]()
//
//      publicParams["auth_version"] = "101"
//      publicParams["secure_version"] = "101"
//      publicParams["app_id"] = Lolmdf_APPid()
//      publicParams["app_channel"] = "appstore"
//
//      let versionName:String = LolmDF_VERSION()
//      let versionCode = versionName.replacingOccurrences(of: ".", with: "")
//      publicParams["app_version_code"] = versionCode
//      publicParams["app_version_name"] = versionName
//      publicParams["device-ident"] = LolmDF_uuid()
//      //添加token
//
//      if let token:String = LolmDFHttpSession.shareManager().paramProvider?.getToken(), token.count > 0 {
//          publicParams["token"] = token
//          publicParams["auth_token"] = token
//      } else {
//          publicParams["token"] = ""
//          publicParams["auth_token"] = ""
//      }
//
//
//
//      let signedParam  = DFHttpSign_Alamofire(withKey: DFHttpSignKey, withparam: publicParams);
//
//        let urlModify:(inout URLRequest) throws -> Void =  { (request) in
//  //          request.httpBody = try JSONSerialization.data(withJSONObject: signedParam)
//            var paramsList:Array = [String]()
//            signedParam.forEach { (arg0) in
//                        let (key, value) = arg0
//                        let str:String = "\(key)=\(value)"
//                        paramsList.append(str)
//            }
//            let urlStr_new = urlStr + "?" + paramsList.joined(separator: "&")
//            request.url = URL(string: urlStr_new)
//        }
//
//
//
//
//           // 默认60s超时
//           AF.upload(multipartFormData: { multipartFormData in
//
//               multipartFormData.append(fileConfig.fileData, withName: fileConfig.name, fileName: fileConfig.fileName, mimeType: fileConfig.mimeType)
//
//           }, to: urlStr, usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post, headers: [], interceptor: nil, fileManager:.default,requestModifier: urlModify).responseJSON { (response) in
//            if showLoading {
//                LolmDFHttpUtil.referenceCountChangeFun(isAdd: false,view: view)
//            }
//               switch response.result {
//               case .success:
//                   let json = String(data: response.data!, encoding: String.Encoding.utf8)
//                   success(json ?? "")
//               case .failure:
//                   let statusCode = response.response?.statusCode
//                   error("\(statusCode ?? 0)请求失败")
//                   debugPrint(response.response as Any)
//            }
//        }
//    }
//
//
//    // loading 管理
//    ///
//    /// - Parameter isAdd: 是否显示loading true引用计数加一 false引用计数减一
    private static func referenceCountChangeFun(isAdd:Bool,view:UIView = LolmDF_APPDELEGATE().window!) {

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
    
    
    static var lolm_tkTimeOutNotification:Notification.Name {
        
        return Notification.LolmDF_TokenTimeout_notification.name
    }
    
    
    /**
     登录已失效
     */
    static private func loginTokenTimeOut() {

       
        
        NotificationCenter.default.post(.init(name: lolm_tkTimeOutNotification))
    }
    
    
    
}

////大数据统计
//extension LolmDFHttpUtil {
//
//    public enum EA_TYPE:String {
//        case EA_TYPE_CLICK = "点击"
//        case EA_TYPE_BROWSE = "浏览"
//        case EA_TYPE_EXPOSURE = "曝光"
//    }
//}
//
