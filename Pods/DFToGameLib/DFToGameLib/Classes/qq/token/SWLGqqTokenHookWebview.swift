//
//  SWLGqqTokenWebview.swift
//  DoFunNew
//
//  Created by mac on 2021/10/26.
//

import Foundation
import WebKit
import DFBaseLib
import SnapKit
import DFOCBaseLib

class SWLGQQTokenWebController:UIViewController {
    
    //游戏id
    var game_id:String = ""
    
    var aid:String = ""
    var cookie:String = ""
    
    var _urlString = ""
    
    
    
    var quickModel:SWQuickInfoQuickTypeModel!
    
    var param:SWQuickLoginGameModel!
    
    var eventBlock:((Int,String?)->())?
    
    var isTry:Bool = false
    var isTs:Bool = false
    var reTry_num:Int = 0
    var errorCount = 0
    
    
    var webView:WKWebView!
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "QQLogin"
        
        configure()
    }
    
  
    func configure()  {
        
        var qqStr = param.qq
        
        guard let hid  = param.quick_info?.hid else {
            
            eventBlock?(2,"hid 为空")
            return
        }
        
        
        guard let orderId = param.order_info?.orderid else {
            
            
            eventBlock?(2,"orderid 为空")
            return
        }
        
        guard let game_package_ios = param.quick_info?.game_info?.package_ios_qq else {
            
            
            eventBlock?(2,"game package 为空")
            return
        }
        
        guard let aidStr = game_package_ios.components(separatedBy: ":").first else {
            
            return
        }
       
        
       reTry_num = quickModel.retry_times
        
       aid =  aidStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        
        
        let config = WKWebViewConfiguration.init()
        let js =
            """
            javascript:(function(){
            var objs = document.getElementById(\"u\");
            objs.setAttribute('readonly', 'readonly');
            var objs1 = document.getElementById(\"p\");
            objs1.setAttribute('readonly', 'readonly');
            var objs2 = document.getElementById(\"go\");
            function _openlogin_data(){
             setTimeout(function(){
              if(pt && pt.submit_o && pt.submit_o.openlogin_data){objs.value = "\(qqStr)";objs1.value=\"13213212\";window.pt.submitEvent();}else{_openlogin_data();}},500);
           
            }
            _openlogin_data();})()
           """
        let wkScript = WKUserScript.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        config.userContentController.addUserScript(wkScript)
        
        
        let handler = SWLgWKWebviewSchemeHandler.init()
        handler.hid = hid
        handler.qq  = qqStr
        handler.orderId = orderId
        
        config.setURLSchemeHandler(handler, forURLScheme: "https")
        config.setURLSchemeHandler(handler, forURLScheme: "http")
        
        
        webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: NAV_HEIGHT, left: 0, bottom: 0, right: 0))
        }
        
        let phoneVersion:String = UIDevice.current.systemVersion
        
        var utname = utsname.init()

        uname(&utname)
        
        let platform =  Mirror(reflecting: utname.machine).children.reduce("") { identifier, element in
            
            guard let value = element.value as? Int8, value != 0 else { return identifier }

            return identifier + String(UnicodeScalar(UInt8(value)))

        }
        
        let URLStr:String = "https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=all&status_version=15&sdkv=3.5.1_full&status_machine=\(platform)&switch=1&redirect_uri=auth://www.qq.com&status_os=\(phoneVersion)&client_id=\(aid)"
        
        _urlString = URLStr
        
        let request = URLRequest.init(url: URL(string: URLStr)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        
        webView.load(request as URLRequest)
        
        handler.compleBlock = { [unowned self](access_token,openid,paytoken,cookie,mag) in
            
            self.cookie = cookie
            
            if access_token.count > 0, openid.count > 0, paytoken.count > 0  {
                
                DispatchQueue.main.async {
                    
                    self.uploadToken(withAtoken: access_token, openId: openid, ptoken: paytoken)
                }
                
                self.eventBlock?(1,"\(access_token)_\(openid)_\(paytoken)")
            }
            else{
                
                
                self.retry(withMsg: mag)
            }
            
            
        }
        
        handler.errorBlock = { [unowned self] msg in
            
           eventBlock?(2,msg)
        }
    }
    
    
    func retry(withMsg:String)  {
        
        
        //错误信息包含在关键词 标识需要投诉
        isTs = self.quickModel.off_rent.contains {
            
            return withMsg.contains($0)
        }
        
        if isTs == true {
            
            var param:[String:Any] = [:]
            
            param["hid"] = self.param.order_info?.hid
            param["order_id"] = self.param.order_info?.orderid
            param["remark"] = withMsg
            param["source"] = quickModel.source
            param["quick_ts"] = 1
            param["err_times"] = errorCount
            param["quick_version"] = "5"
            param["order_login"] = self.param.quick_info?.order_login
            
            SWNetworkingTool.requestFun(url:  SW_API_SETTOKENERROR, method: .post, parameters: param) { (json) in
            
            
                    } failBlock: { (error) in
            
            
            }
            
            
            
        }
        
        
        
        if isTs == false {
            
            isTry = quickModel.retry.contains {
                
                return withMsg.contains($0)
            }
            
            if isTry == true {
                
                if reTry_num > 0 {
                    
                    reTry_num -= 1
                    
                    let request = URLRequest.init(url: URL(string: _urlString)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
                    
                    webView.load(request as URLRequest)
                    
                    
                    
                }else{
                    
                    var param:[String:Any] = [:]
                    
                    param["hid"] = self.param.order_info?.hid
                    
                    param["order_id"] = self.param.order_info?.orderid
                    
                    param["remark"] = withMsg
                    param["source"] = quickModel.source
                    
                    param["err_times"] = errorCount
                    param["quick_version"] = "5"
                    param["order_login"] = self.param.quick_info?.order_login
                    
                    SWNetworkingTool.requestFun(url:  SW_API_SETTOKENERROR, method: .post, parameters: param) { (_) in
                    
                            } failBlock: { (error) in

                    }
                    
                    
                    self.eventBlock?(2,"web 上号失败，错误次数(\(errorCount)")
                    
                    
                }
                
               
            }
            
            errorCount += 1
        }
        
        
    }
    
    func uploadToken(withAtoken:String,openId:String,ptoken:String)  {
        
        let json_dic = ["ptoken":ptoken,"openid":openId,"atoken":withAtoken,"current_uin":openId,"platform":"qq_m","cookie":self.cookie].toJsonString()!
        let rc4Str = ZSRc4.swRc4Encrypt(withSource: json_dic, rc4Key: game_auth_key)
        
        var param:[String:Any] = [:]
        param["hid"] = self.param.quick_info?.hid
        param["order_id"] = self.param.order_info?.orderid
        param["login_token"] = rc4Str
        param["source"] = quickModel.source
        param["order_login"] = self.param.quick_info?.order_login
        param["quick_version"] = "5"
        
        SWNetworkingTool.requestFun(url:  SW_API_SETTOKENSOFT, method: .post, parameters: param) { (json) in
            
        } failBlock: { (error) in
           
            
            
        }
    }
}


class SWLgWKWebviewSchemeHandler:NSObject,WKURLSchemeHandler {
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        let request = urlSchemeTask.request
        
        guard let urlStr = request.url?.absoluteString else {
            
            return
        }
        
        schemaTaskMap[urlSchemeTask.description] = true
        
        /*
         盐：监听https://xui.ptlogin2.qq.com/ssl/pt_open_login 这个开始的接口
         取 verifycode 这个字段的值
         */
        if urlStr.contains("https://xui.ptlogin2.qq.com/ssl/pt_open_login") {
            
           let randStr = SWLGUtils.getParamByName("verifycode", urlString: urlStr)
            
            let param:[String:Any] = ["hid":hid,"order_id":orderId,"vcode":randStr]
            
            SWNetworkingTool.requestFun(url: SW_API_QUICK_ENCRYPT, method: .post, parameters: param) { (json) in
                
                guard let model = SWjd<SWHttpResponse<[String:String]>>.deserializeFrom(json: json) else {
                    
                    self.errorBlock?("获取密码接口数据解析失败")
                    return
                }
                
                if model.status == 1, let encrypt = model.data["encrypt"] {
                    
                    if let newUrl = self._modifyPad(withUrl: urlStr, withpsd: encrypt) {
                        
                        
                        var currentRequest = URLRequest.init(url:newUrl)
                        
                        request.allHTTPHeaderFields?.forEach({ (key,value) in
                            
                            currentRequest.addValue(value, forHTTPHeaderField: key)
                        })
                        
                        let session = URLSession.shared
                        
                        
                        session.dataTask(with: currentRequest) { (data,response,error) in
                            
                            guard self.schemaTaskMap[urlSchemeTask.description] == true else{
                                
                                return
                            }
                            
                            if let _error = error {
                                
                                urlSchemeTask.didFailWithError(_error)
                                
                            }else{
                                
                                guard  let _jsonData = data, let _res = response else {
                                    
                                    
                                    return
                                }
                                
                                guard let json = String.init(data: _jsonData, encoding: .utf8) else {
                                    
                                    
                                    return
                                }
                                
                                
                                
                                let cookies = HTTPCookieStorage.shared.cookies(for: request.url!)
                                
                                var skey = ""
                                var uin = ""
                                var cookie = ""
                                
                                
                                
                                
                                cookies?.forEach({ tmpCookie in
                                    
                                    if tmpCookie.name == "skey" {
                                        
                                        skey = tmpCookie.value
                                    }
                                    if tmpCookie.name == "uin" {
                                        
                                        uin = tmpCookie.value
                                    }
                                })
                                
                                cookie = "skey=\(skey): uin=\(uin)"
                                
                                
                                let accessToken = SWLGUtils.getParamByName("access_token", urlString: json)
                                
                                let openid = SWLGUtils.getParamByName("openid", urlString: json)
                                
                                let pay_token = SWLGUtils.getParamByName("pay_token", urlString: json)
                                
                                var msg = ""
                                
                                let array = json.components(separatedBy: ",")
                                
                                if array.count >= 5 {
                                    
                                    msg = array[4]
                                }
                                
                                
                                urlSchemeTask.didReceive(_res)
                                urlSchemeTask.didReceive(_jsonData)
                                urlSchemeTask.didFinish()
                                
                                
                              
                                self.compleBlock?(accessToken,openid,pay_token,cookie,msg)
                            }
                            
                            
                            
                        }.resume()
                        
                        
                        
                        
                    }else{
                        
                        self.errorBlock?("替换密码错误")
                    }
                   
                    
                    
                }else{
                    
                    self.errorBlock?("获取密码接口错误")
                }
                
                
            } failBlock: { (error) in
                
                self.errorBlock?("获取密码接口请求失败")
                return
            }

            
            
            
        }else{
            
            
            URLSession.shared.dataTask(with: request) {  (data,response,error) in
                
                guard self.schemaTaskMap[urlSchemeTask.description] == true else{
                    
                    return
                }
                
                if let _error = error {
                    
                    urlSchemeTask.didFailWithError(_error)
                }else{
                    
                   
                    
                    if let _response = response {
                        
                        urlSchemeTask.didReceive(_response)
                    }
                    if let _data = data {
                        
                        urlSchemeTask.didReceive(_data)
                    }
                    urlSchemeTask.didFinish()
                }
                
                
            }.resume()
        }
        
        
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
        
        schemaTaskMap[urlSchemeTask.description] = false
    }
    
    func _modifyPad(withUrl:String,withpsd:String) ->URL?  {
        
    
        guard let urlComponents = URLComponents.init(string: withUrl), let items = urlComponents.queryItems, items.count > 0 else {
            
            return nil
            
        }
        
        var queryItemList = [URLQueryItem]()
        
        
        items.forEach { item in
            
            if item.name == "p"{
                
                queryItemList.append(.init(name: item.name, value: withpsd))
            }else{
                
                queryItemList.append(.init(name: item.name, value: item.value))
            }
        }
        
        var newComponents = urlComponents
        newComponents.queryItems = queryItemList
        
        return newComponents.url
    }
    
    
    
    var compleBlock:((String,String,String,String,String)->())?
    
    var errorBlock:((String?)->())?
    
    
    var schemaTaskMap:[String:Bool] = [:]
    
    
    var hid:String = ""
    var orderId:String = ""
    var qq:String = ""
    
    
    
}
