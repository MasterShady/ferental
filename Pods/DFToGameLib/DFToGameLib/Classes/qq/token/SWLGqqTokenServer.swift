//
//  SWLGqqTokenServer.swift
//  DFToGameLib
//
//  Created by mac on 2022/1/13.
//

import Foundation
import DFOCBaseLib
//未调用
class SWLGqqTokenServer {
      
    var quickModel:SWQuickInfoQuickTypeModel!
    
    var param:SWQuickLoginGameModel!
    
    //游戏id
    var game_id:String = ""
    
    var eventBlock:((Int,String?)->())?
    
    var check_timer:Timer!
    
    var current_loading:SWLoginGameLoadingViewProtocol!
    
    func cancel()  {
         
        check_timer.invalidate()
        check_timer = nil
    }
     
    func toTask(loadingview:SWLoginGameLoadingViewProtocol!)  {
        
        loadingview.show()
        
        current_loading = loadingview;
        
//        getServerToken();
       
        check_timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getServerToken), userInfo: nil, repeats: true)
        
        check_timer.fire()
        
    }
    
    @objc func getServerToken() {
        
        
        var param:[String:Any] = [:]
        if SWOtherInfoWrap.shared.channel == .dfapp {
            
            param["order_id"] = self.param.order_info?.orderid
            
        }
        else{
            
            let code = SWOtherInfoWrap.shared.token
            param["uncode"] = code
        }
        
        param["source"] = quickModel.source
        param["order_login"] = self.param.quick_info?.order_login
        param["quick_version"] = "5"
        
        SWLGLog(withMsg: "getServerToken")
        SWNetworkingTool.requestFun(url: SW_API_GETSERVERORDER_TOKEN, method: .post, parameters: param, showLoading: false) { (json) in
            
            SWLGLog(withMsg: json)
            guard let model = SWjd<SWHttpResponse<[String:String]>>.deserializeFrom(json: json) else {
                
                return
            }
            
            if (model.status == 1) {
                
            }else {
                self.current_loading.hidden();
                self.freeTimer()
                if (model.status == 0) {
                    //参数错误，直接弹框提示
                    showTextHudTips(message: model.message )
                    
                    self.eventBlock?(0,"参数错误")
                }else if (model.status == 2) { // 撤单直接返回刷新详情页
                    
                    self.eventBlock?(2,"reload_detail")
                    
                }else if (model.status == 3) {
                    //停止轮询获取token上号 不上报
                    
                    self.defaultTokenLoginGame(quick_token: model.data["quick_token"],upload: false)
                    
                }else {
                    // 4 默认token上号
                    self.defaultTokenLoginGame(quick_token: self.param.quick_info?.quick_token,upload: false)
                
                }
            }
            
        } failBlock: { [weak self] (error) in
            self?.current_loading.hidden();
            self?.freeTimer()
            //如果请求错误直接走默认token上号
            self?.defaultTokenLoginGame(quick_token: self?.param.quick_info?.quick_token)
        }
        
    }
    
    
    
    func defaultTokenLoginGame(quick_token:String?,upload:Bool = true) {
        
        guard  let token = quick_token?.uppercased() else{
            
            self.eventBlock?(0,"qq_order token nil")
            return
        }
        
        guard let decryptStr = ZSRc4.swRc4Decrypt(withSource: token, rc4Key: game_auth_key),decryptStr.isEmpty == false else {
            
            self.eventBlock?(0,"qq_order token decrypt error")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: decryptStr.data(using: .utf8)!, options: .mutableLeaves) , let dic = json as? [String:Any] else {
            
            self.eventBlock?(0,"qq_order token json error")

            return
        }
        
        var openUrl:String  = ""
        
        guard let game_package_name_ios = param?.quick_info?.game_info?.package_ios_qq else {
            
            
            self.eventBlock?(0,"game scheme is nil")
            return showTextHudTips(message: "game schema is nil")
        }
        let openid = dic.getValue(key: "openid", t: String.self)!
        let atoken = dic.getValue(key: "atoken", t: String.self)!
        let ptoken = dic.getValue(key: "ptoken", t: String.self)!
        let pplatform = dic.getValue(key: "platform", t: String.self)!
        let current_uin = dic.getValue(key: "current_uin", t: String.self)!
        SWLGLog(withMsg: "decryptStr=>\(json)")
        
        //新增-如果存在以下encry_token  则要进行plist文件相关操作
       
        if  dic.getValue(key: "encry_token", t: String.self) != nil{
            
            let encry_token = dic.getValue(key: "encry_token", t: String.self)!
            let pfkey = dic.getValue(key: "pfkey", t: String.self)!
            let pf = dic.getValue(key: "pf", t: String.self)!
            let expires_in = dic.getValue(key: "expires_in", t: String.self)!
            
            
            let templatePath:String? = SWLGPlistUtil().getTemplate()
            
            let rawdata = try! Data.init(contentsOf: URL(fileURLWithPath: templatePath!))
            
            let json = NSKeyedUnarchiver.unarchiveObject(with: rawdata) as! NSDictionary
            
            print(json)
            json.setValue(Int(expires_in) ?? 0, forKey: "expires_in")
            json.setValue(encry_token, forKey: "encrytoken")
            json.setValue(openid, forKey: "openid")
            json.setValue(pf, forKey: "pf")
            json.setValue(pfkey, forKey: "pfkey")
            json.setValue(ptoken, forKey: "pay_token")
            json.setValue(atoken, forKey: "access_token")
            print(json, type(of: json))

            let data1 =  try! NSKeyedArchiver.archivedData(withRootObject: json, requiringSecureCoding: true)
            
            let base64 =  data1.base64EncodedString()
            
            openUrl = "\(game_package_name_ios)qzapp/mqzone/0?objectlocation=url&pasteboard=\(base64)"
            
            if upload {
                
                uploadToken(with: dic)
            }
            
            
        }else{
            
            if game_id == "698" || game_id ==  "1078" {
                
                openUrl = "\(game_package_name_ios)?platform=\(pplatform)&user_openid=\(openid)&openid=\(openid)&launchfrom=sq_gamecenter&gamedata=&platformdata=&atoken=\(atoken)&ptoken=\(ptoken)&huashan_com_sid=biz_src_zf_games"
                
            }else{
                
                openUrl = "\(game_package_name_ios)startapp?atoken=\(atoken)&openid=\(openid)&ptoken=\(ptoken)&platform=\(pplatform)&current_uin=\(current_uin)&launchfrom=sq_gamecenter"
            }
        }
        
        self.eventBlock?(1,openUrl)
    }
    
    
    
    //1.3服务端上号 上报token with为备用token解密出来的json数据
    func uploadToken(with:[String:Any])  {
        
        SWLGLog(withMsg: "uploadToken")
        let json_dic = with.toJsonString()!
        let rc4Str = ZSRc4.swRc4Encrypt(withSource: json_dic, rc4Key: game_auth_key)
        
        var param:[String:Any] = [:]
        param["hid"] = self.param.quick_info?.hid
        param["order_id"] = self.param.order_info?.orderid
        param["login_token"] = rc4Str
        param["source"] = self.param.default_source
        param["order_login"] = self.param.quick_info?.order_login
        param["quick_version"] = "5"
        param["remark"] = "plist上号成功"
        SWNetworkingTool.requestFun(url:  SW_API_SETTOKENSOFT, method: .post, parameters: param) { (json) in
            
        } failBlock: { (error) in
           
        }
    }
    
    //释放定时器
    func freeTimer() {
        check_timer.invalidate()
        
        check_timer = nil
    }
    
   
}
