//
//  http.swift
//  gameTools
//
//  Created by mac on 2021/10/28.
//

import Foundation
import Alamofire
import HandyJSON
import CommonCrypto
import DFBaseLib

import DFOCBaseLib



class  MJHttpService {
      
    var param:[String:Any] = [:]
    
    var api:String!
    
    var httpMethod:HTTPMethod = .get
    
    var apiType:Int = 0 // 0 php 1 中台
    
    var retryCount:Int = 0 //接口是否重试
}

class SWHttpResponse <DATA>: HandyJSON {
    
    var status:Int!
    
    var message:String = ""
    
    var data:DATA!
    
    required init() {
        
    }
}

class SWHttpResponseOrNil <DATA>: HandyJSON {
    
    var code:Int!
    
    var msg:String = ""
    
    var data:DATA?
    
    required init() {
        
    }
}
class SWHttpCodeResponse <DATA>: HandyJSON {
    
    var status:Int!
    
    var code:Int = 0
    
    var message:String = ""
    
    var data:DATA!
    
    required init() {
        
    }
}


class SWHTTPResponseBase:HandyJSON {
    
    var status:Int!
    
    var message:String = ""
    
    required init() {
        
        
    }
}



enum MJHttpServerType {
    case developer
    case test
    case pre_release
    case release
   
}

struct  MJHttpConfig {
    
    
     
    
    var serverMap:[MJHttpServerType:String] = [:]
    
    
   
    subscript(tyle:MJHttpServerType) -> String{
        
        return serverMap[tyle] ?? serverMap[.release]!
        
    }
    
}


enum MJHttpResult {
    
     
    case succese(String)
    
    
    case netError
    
}




class SimpleHttp {
    
    static  var `default`:SimpleHttp = .init()
    
    var apiServerMap:[Int:MJHttpConfig] = [:]
    
    //0 1测试 2预发布 3生产
    var api_env:MJHttpServerType = .release
    
    init() {
        
        var php = MJHttpConfig.init()
        php.serverMap = [.release:"https://zhwapp.zuhaowan.com/",.test:"http://39.98.193.35:9504/",.pre_release:"http://10.10.24.178:9502/",.developer:"http://39.98.193.35:9521/"]
        
        apiServerMap[0] = php
        
        var center = MJHttpConfig.init()
        center.serverMap = [.release:"https://bd-quickin.zuhaowan.cn/",.test:"http://10.10.45.170:30173/",.pre_release:"http://10.10.24.178:9502/",.developer:"http://loginbus.bigdata-uat.zuhaowan.com.cn/"]
        apiServerMap[1] = center
    }
    
    func getApiUrl(with:MJHttpService) ->String {
        
        let config = apiServerMap[with.apiType]!
        
        return config[api_env] + with.api
        
    }
    
    lazy var _session:Session = {
        
        let session = Session.default
        
        return session
        
    }()
    
    func httpHeader(_ service:MJHttpService) -> HTTPHeaders{
        
        
        let versionStr = SWAPPVersion()
        var header:HTTPHeaders = HTTPHeaders.init()
        header["os"] = "iOS"
        header["Content-Type"] = "application/json;charset=UTF-8"
        header["version"] = versionStr
        if service.apiType == 1 {
            
            header["channel"] = SWOtherInfoWrap.shared.appId
            header["credential"] = SWOtherInfoWrap.shared.zhongtai_credential
        }
        return header
    }
    
    func httpParam(_ service:MJHttpService) -> [String:Any]  {
        
        var base = [String:Any]()
        
        base["auth_version"] = "101"
        base["secure_version"] = "101"
       
        base["app_channel"] = "appstore"
        let versionName:String = SWAPPVersion()
        let versionCode = versionName.replacingOccurrences(of: ".", with: "")
        base["app_version_code"] = versionCode
        base["app_version_name"] = versionName
        
        base["app_id"] = SWOtherInfoWrap.shared.appId
        if SWOtherInfoWrap.shared.channel == .dfapp {
            
            let token  = SWOtherInfoWrap.shared.token
            
            base["token"] = token
            base["auth_token"] = token
            
        }else{
            
            
            let code = SWOtherInfoWrap.shared.token
            
            let time = Int(NSDate().timeIntervalSince1970)
            
            let key = SW_API_TOKEN_MAP[service.api]!
            
            let str = "\(key)\(time)\(code!)"

            let apitoken = str.swMD5Encrypt(.lowercase32)
            base["uncode"] = code
            base["api_token"] = apitoken
            base["time"] = time
            
            
        }
        
       
        base["device-ident"] = APPUUID()
        
        service.param.forEach { (key,value) in
            
            base[key] = value
        }
        
        return base
    }
    
    
    func httpTask(_ service:MJHttpService,result resultBlock :@escaping (_ response: MJHttpResult)->Void) {
         
        if service.apiType == 0 {
           
            php_http(service, result: resultBlock)
        }else{
            
            zhongtai_http(service, result: resultBlock)
        }
         
       
    }
    
    //php 服务
    private func php_http(_ service:MJHttpService,result resultBlock :@escaping (_ response: MJHttpResult)->Void)  {
        
        let url = getApiUrl(with: service)
        
        let header = httpHeader(service)

        let encoding:URLEncoding = URLEncoding.init(destination: .queryString)
        
        let httpbody = self.httpParam(service)
        
        let signedParam  = DFHttpSign_Alamofire(withKey: SWOtherInfoWrap.shared.httpSignStr, withparam: httpbody)
        var paramsList:Array = [String]()
        signedParam.forEach { (arg0) in
                    let (key, value) = arg0
                    let str:String = "\(key)=\(value)"
                    paramsList.append(str)
        }
               
       print( "当前请求url === " + url + "?" + paramsList.joined(separator: "&"))
        
        var retryObj:RetryPolicy?
        
        if service.retryCount > 0 {
            
            retryObj = RetryPolicy.init(retryLimit: UInt(service.retryCount))
        }
        
        _session.request(url, method: .get, parameters: signedParam,  encoding: encoding  , headers: header,interceptor: retryObj).responseString { response in
            
            
            switch response.result {
              
            case .failure( _):
                
                resultBlock(.netError);
            
            case .success(let msg):
                
                resultBlock(.succese(msg))
               
                
               
                
                
            }
            
            
        }
        
    }
    //中台 服务
    private func zhongtai_http(_ service:MJHttpService,result resultBlock :@escaping (_ response: MJHttpResult)->Void){
        
        let url = getApiUrl(with: service)
        
        let header = httpHeader(service)

        let encoding:JSONEncoding = JSONEncoding.prettyPrinted
        
        let jsonParam = service.param.toJsonString() ?? ""
        
        let encryptData = DFAES.aes256EncryptECB(jsonParam, key: zhongtai_aesKey())
        
        let currentDate = Date.init()
        
        let dateformat = DateFormatter.init()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatDate_current = dateformat.string(from: currentDate)
        
        let httpbody = ["request":formatDate_current,"requestBody":encryptData,"requestBizId":SWOtherInfoWrap.shared.zhongtai_bid]
        
        SWLGLog(withMsg: "请求参数\(jsonParam)")
        
        SWLGLog(withMsg: "请求body\(httpbody.toJsonString())")
        SWLGLog(withMsg: "Url-->\(url)")
        //加密 http body
        
        var retryObj:RetryPolicy?
        
        if service.retryCount > 0 {
            
            retryObj = RetryPolicy.init(retryLimit: UInt(service.retryCount))
        }
        
        
        _session.request(url, method: .post, parameters: httpbody,  encoding: encoding  , headers: header,interceptor: retryObj).responseString { response in
            
            
            switch response.result {
              
            case .failure( _):
                
                resultBlock(.netError);
            
            case .success(let msg):
                SWLGLog(withMsg: "返回原始数据\(msg)")
                resultBlock(.succese(msg))
               
                
               
                
                
            }
            
            
        }
    }
}


typealias   SWjd = JSONDeserializer


protocol DFQueueHttpTaskProtocol {
    
    func taskDo()
    
    func taskEnd()
        
    
}
class DFQueueHttpTask<T>:DFQueueHttpTaskProtocol {
    
    var httpService:MJHttpService!
    
    private var timer:DispatchSourceTimer?
    
    private var queue_resultBlock:((SWHttpResponseOrNil<T>?)->())!
    
    private var running:Bool = false //正在轮询中
    
    init(withResult:@escaping (SWHttpResponseOrNil<T>?)->()) {
        
        queue_resultBlock = withResult
        
    }
    
    
    func taskDo()  {
        
        guard running == false else {
            
            return
        }
        
        running = true
        
        timer = runTimer(withSumTimes: 360, withstep: 1, withHandler: { [unowned self] () in
            
            http()
            
        }, withFinish: { [unowned self] () in
            
            taskEnd()
        })
    }
    
    func taskEnd()  {
        
         running = false
        
         freeTimer(withTimer: &timer)
    }
    
    
    func http()  {
        
        //如果已经停止 直接返回
        guard self.running == true else{
            
            return
        }
        
        SimpleHttp.default.httpTask( httpService) { response in
            
            //如果已经停止 直接返回
            guard self.running == true else{
                
                return
            }
            
            switch response {
                
            case .succese(let string):
                 
                let model =  JSONDeserializer<SWHttpResponseOrNil<T>>.deserializeFrom(json: string)
                
                self.queue_resultBlock(model)
                
            default :
                
                self.queue_resultBlock(nil)
            }
      }
    }
}

struct DFTXRequestModel:HandyJSON {
    
    init() {
        
    }

    var reqAddr:String = ""
    var reqData:String = ""
    var reqHeader:String = ""
    var reqCookie:String = ""
    
}
extension URLRequest {
    
    static func urlRequest(fromBase64Str:String)  throws -> URLRequest {
        
        
        guard let str =  df_base64DecodeString(with: fromBase64Str) else {
            
            throw SWLoginGameError.init(channel: 2, code: .LGECode_TxRequest_Error, message: "Tx报文数据解析异常1")
            
           
        }
        

        guard let req = SWjd<DFTXRequestModel>.deserializeFrom(json: str) else {
            
            throw SWLoginGameError.init(channel: 2, code: .LGECode_TxRequest_Error, message: "Tx报文数据解析异常2")
        }
        
        guard let urlStr = df_base64DecodeString(with: req.reqAddr), let req_url = URL(string: urlStr  ) else {
            
            throw SWLoginGameError.init(channel: 2, code: .LGECode_TxRequest_Error, message: "Tx报文数据缺少url参数")
        }
        
        var request = URLRequest.init(url: req_url)
         
         
        request.url = req_url
        request.httpMethod = "POST"
        request.httpBody = Data(base64Encoded: req.reqData)
        //Accept: */*\r\nContent-Type: application/octet-stream\r\nUser-Agent: MicroMessenger Client\r\nHost: short.weixin.qq.com\r\nCache-Control: no-cache
        //请求头
        if let headers = df_base64DecodeString(with: req.reqHeader), headers.isEmpty == false {
            
              headers.components(separatedBy: "\r\n").forEach { line in
                 
                 let components = line.components(separatedBy: ": ")
                 
                 if components.count == 2 {
                     
                     request.addValue(components[1], forHTTPHeaderField: components[0])
                 }
                 
             }
             
         }
        //Cookies
         if let cookie = df_base64DecodeString(with: req.reqCookie), cookie.isEmpty == false {
             
             request.addValue(cookie, forHTTPHeaderField: "Cookie")
         }
         
        return request
        
    }
    
    
}
