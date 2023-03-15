//
//  SWLGFaceCheck.swift
//  DoFunNew
//
//  Created by mac on 2021/6/3.
//

import Foundation

import Alamofire


class SWLoginGameFaceCheck {
    
    var session_id:String?
    var channel_id:String?
    
    struct _Info {
       var qq:String,hopeToken:String,url:String,Switch:Int,chk_id:Int,access_token:String?,openid:String?,ptoken:String?,cookie:String?
    }
    
    var myInfo:_Info!
    
    enum SWLGFaceCheckEvent {
        case success(Int) //成功事件 启动游戏 0旧流程 1新流程
        case error(String?) //失败
        case reloadTip(String)
    }
    
    var evenBlock:((SWLGFaceCheckEvent)->())?
    
    
    func callBack(block:@escaping(SWLGFaceCheckEvent)->()) {
         
        
         
         evenBlock = block
    }
    
    var task:URLSessionDataTask?
       
    func skeyGetSessionId() {
        
         let str = "https://open.mp.qq.com/connect/oauth2/authorize?appid=201023853&redirect_uri=https://jz.game.qq.com/php/tgclub/v2/jzwechat_v10_login/h5qqLogin?redirectUrl=aHR0cHM6Ly9qaWF6aGFuZy5xcS5jb20vd2FwL3NlbGZNYW5hZ2UvZGlzdC9zdHVkZW50L2luZGV4Lmh0bWw/dWZsYWc9MTYxMDAxMTM1Nzc3MSMvSW5kZXg=&response_type=code&scope=snsapi_base&state=STATE"
       
        guard let url = URL(string: str) else {
            
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue(myInfo.cookie, forHTTPHeaderField: "Cookie")
        
        let session = URLSession.shared
        
        let  tk =  session.dataTask(with: request) { data, response, error in
            
            guard let result = data else {
                
               showTextHudTips(message: "skeyGetSessionId data nil")
                return
            }

        
            
            guard let _ = String.init(data: result, encoding: .utf8) else {
 
                showTextHudTips(message: "skeyGetSessionId data error")
                return
            }
            
            let cookieStorage = HTTPCookieStorage.shared
            if let cookieList = cookieStorage.cookies(for: url) {
                
                cookieList.forEach { tmpCookie in
                  
                    if tmpCookie.name == "session_id" {
                        
                        self.session_id = tmpCookie.value
                    }
                    if tmpCookie.name == "channel_id" {
                        
                        self.channel_id = tmpCookie.value
                    }
                }
            
    
            }
            
            if self.session_id?.isEmpty == false {
                
                self.channel_id = self.channel_id ?? "4"
                
                self.oldInterfaceCheckFace()
            }else{
                
               showTextHudTips(message: "skeyGetSessionId session id nil")
            }
            
        }
        
        tk.resume()
        
        
    }
    
    
    /// 老登录流程只进行老接口人脸检测
    func oldLogDoOldInterfaceCheck()  {
        
        var param:[String:Any] = [:]
        param["accountId"] = myInfo.qq
        param["hopeToken"] = myInfo.hopeToken
        
        guard let jsonParam = param.toJsonString() else {
            
            return
        }
        
        guard let url = URL(string: myInfo.url) else {
            
            return
        }
        
        var request = URLRequest(url: url)
        
        request.method = .post
        request.setValue("https://jiazhang.qq.com", forHTTPHeaderField: "origin")
        request.setValue("application/x-www-from-urlencoded;charset=UTF-8", forHTTPHeaderField: "content-type")
        request.httpBody = jsonParam.data(using: .utf8)
        let task =  URLSession.shared.dataTask(with: request) { (data,response,error) in
            
            guard let result = data else {

                return
            }
            
            guard let json =  try? JSONSerialization.jsonObject(with: result, options: .mutableContainers),let dic = json as? [String:Any] else {
                
                return
            }
            
            let msg = dic["msg"] as? String ?? ""
            let faceResult = dic["faceResult"] as? Int ?? 0
            
            DispatchQueue.main.async {
                
                sw_logingame_qq_faceverify_report(withChk_id: self.myInfo.chk_id, chk_memo: msg, isface: faceResult) { (code, msg) in
                    
                    guard let status = code else {
                        
                        self.evenBlock?(.error("数据异常"))
                        return
                    }
                    
                    if status == 1 {
                        
                        self.evenBlock?(.success(0))
                    }
                    else{
                        
                        self.evenBlock?(.error(msg))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
  private func oldInterfaceCheckFace() {
         
        var param:[String:Any] = [:]
        param["accountId"] = myInfo.qq
        param["hopeToken"] = myInfo.hopeToken
        
        guard let jsonParam = param.toJsonString() else {
            
            return
        }
        
        guard let url = URL(string: myInfo.url) else {
            
            return
        }
        
        var request = URLRequest(url: url)
        
        request.method = .post
        request.setValue("https://jiazhang.qq.com", forHTTPHeaderField: "origin")
        request.setValue("application/x-www-from-urlencoded;charset=UTF-8", forHTTPHeaderField: "content-type")
        request.httpBody = jsonParam.data(using: .utf8)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { [self] data, response, error in
            
            guard let result = data else {
                
                showTextHudTips(message: "oldInterfaceCheckFace data nil")
                return
            }
            
            guard let json =  try? JSONSerialization.jsonObject(with: result, options: .mutableContainers),let dic = json as? [String:Any] else {
                
                return
            }
            
           let ret = dic["ret"] as? Int ?? 0
            
           let faceResult = dic["faceResult"] as? Int ?? 0
           
            /*
             ret == 0 && faceResult == 1  有人脸
             ret == 0 && faceResult == 0 无人脸 -- 上报结果，启动游戏
             其他 查询失败 -- 上报结果按照无人脸启动游戏
             */
            //有人脸 且 新接口检测开关开启 -- 用新接口进行检测
            if ret == 0 && faceResult == 1 &&  self.myInfo.Switch == 1 {
                
                self.newInterfaceCheckFace()
                
            }else{
                
                
                //上报人脸
                let msg = (dic["ret"] as? String) ?? ""
                DispatchQueue.main.async {
                    
                    sw_logingame_qq_faceverify_report(withChk_id: self.myInfo.chk_id, chk_memo: msg, isface: faceResult) { (code,msg) in
                        
                        
                        guard let status = code else {
                            
                            self.evenBlock?(.error("数据异常"))
                            return
                        }
                        
                        if status == 1 {
                            
                            self.evenBlock?(.success(1))
                        }
                        else{
                            
                            self.evenBlock?(.reloadTip(msg))
                        }
                    }
                }
                
            }
            
            
           
            
            
            
        }.resume()
    }
    
    
  private  func newInterfaceCheckFace()  {
        
        let currentTime = String.timeIntervalHourAndMinTimeStr(timeInterval: NSDate().timeIntervalSince1970)
        
        let urlStr = "https://jz.game.qq.com/php/tgclub/v2/jzwechat_v10_facediscern/getRemainTimes?channel_id=4&source=h5&_0=\(currentTime)&callback="
        
        guard let url = URL(string: urlStr) else {
            
            return
        }
        
        var request = URLRequest(url: url)
        
        request.method = .post
        
        request.setValue("session_id=\(session_id ?? ""); channel_id=\(channel_id ?? "")", forHTTPHeaderField: "cookie")
        request.setValue("https://jiazhang.qq.com/wap/com/v1/dist/face_discern_qq.html?", forHTTPHeaderField: "referer")
        request.setValue("com.tencent.mobileqq", forHTTPHeaderField: "x-requested-with")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let result = data else {

                return
            }
            
            guard let json =  try? JSONSerialization.jsonObject(with: result, options: .mutableContainers),let dic = json as? [String:Any] else {
                
                return
            }
            
            var err_code = dic["err_code"] as? Int ?? 0
            var err_msg  = dic["err_msg"] as? String ?? ""
            
            if err_code == 0 {
                
                if let _data = dic["data"] as? [String:Any] {
                    
                   let ret = _data["ret"] as? Int ?? 0
                    
                    if ret == 0 {
                        
                        err_code = 1
                    }
                    if ret == 1 {
                        
                        err_code = 0
                    }
                    
                    err_msg = _data["msg"] as? String ?? ""
                }
                
               
            }else{
                
                err_code = 1
            }
            
            DispatchQueue.main.async {
                
                sw_logingame_qq_faceverify_report(withChk_id: self.myInfo.chk_id, chk_memo: "newapi\(err_msg)", isface: err_code,type: 1) { code, msg in
                    
                    guard let status = code else {
                        
                        self.evenBlock?(.error("数据异常"))
                        return
                    }
                    
                    if status == 1 {
                        
                        self.evenBlock?(.success(1))
                    }
                    else{
                        
                        self.evenBlock?(.reloadTip(msg))
                    }
                }
            }
 
        }.resume()
    }
    
    
   
}



