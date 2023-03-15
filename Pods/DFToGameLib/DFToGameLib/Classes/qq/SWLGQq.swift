//
//  SWLGQq.swift
//  DoFunNew
//
//  Created by mac on 2021/6/3.
//

import Foundation
import DFBaseLib
import DFOCBaseLib

class SWQQLogin: SWLoginGamePlatformProtocol {
    
    var loadingView: SWLoginGameLoadingViewProtocol?
    
    var face_verify_switch:SWQuickLoginFaceSwitchModel? //人脸检测信息
    
    var info:SWActInfo? //账号信息
    
    var qq_orderInfo:SWQuickLoginGameModel?
    
    var token8x:SWLGqqToken8xx!
    
    var tokenServer:SWLGqqTokenServer!
    
    var loginStack:SWLGStack<SWQuickInfoQuickTypeModel> = .init(withDatas:[])
    
    var serverQuickType:SWQuickInfoQuickTypeModel? // 服务端上号quick type
    
    
    var reloadBlock:(()->())?
    
    var loginErrorBlock:((LGECode,String?)->())?
    
    func taskCancel() {
        
        guard let quickTypeModel = self.loginStack.current()  else{
            
            return
        }
            
            
            
        if quickTypeModel.name.contains("84") || quickTypeModel.name.contains("88") {
            
            token8x.cancel()
            
            
        }
            
        if quickTypeModel.name.contains("server") {
               
            tokenServer.cancel()
            
        }
        
        
         
    }
    
    func login(withInfo: SWActInfo) {
        
         info = withInfo
        
         loadingView?.show()
        
        sw_logingame_qq_getOrderInfo(withUnlockCode: withInfo.unlock_code) { (code,dic) in
            
            //self.loginStack = .init(withDatas:[])
            
            /*
             rent_token_switch: false, 是否启用新流程
             weblogin_retry: "1", 是否验证重试次数
             weblogin_retry_times: "5",重试次数
             face_verify_switch 人脸检测数据
             game_auth 加密字符串
             */
            
            if code == -2 {
                
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                SWLGError(withMsg: "数据返回异常code==-2")
                return
            }
            
            if code == -1 {
                
                SWLGError(withMsg: "数据返回异常code==-1")
                self.loginErrorBlock?(LGECode.LGECode_Json_error,"数据异常")
                return
            }
 
            guard let response = dic else {
                
                SWLGError(withMsg: "QQ 上号获取上号信息 返回数据为空")
                self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"QQ 上号获取上号信息 返回数据为空")
                return //接口错误
            }
            
            self.qq_orderInfo = response
            

            self.face_verify_switch = response.face_verify_switch
            
            
            self.loginStack = .init(withDatas: response.quick_info?.quick_type ?? [])
            
            
            self._qqLogin_50()
            
        }
    }
    
    
    
    //5.0 上号入口
    func _qqLogin_50()  {
        
     
        
        if let quickTypeModel = self.loginStack.current() {
            
            if quickTypeModel.name.contains("weblogin") {
               
                SWLGLog(withMsg: "即将web上号")
                _web(withQuickType: quickTypeModel)
            }
            
            else if quickTypeModel.name.contains("84")  {
                SWLGLog(withMsg: "即将84上号")
                _8x(withQuickType: quickTypeModel)
            }
            else if quickTypeModel.name.contains("88")  {
                SWLGLog(withMsg: "即将88上号")
                _8x(withQuickType: quickTypeModel,version: 88)
            }
            
           else if quickTypeModel.name.contains("server") {
                SWLGLog(withMsg: "即将server上号")
                _server_pre(withQuickType: quickTypeModel)
            }
           else{
            
            SWLGError(withMsg: "客户端暂不支持此上号方式\(quickTypeModel.name)")
            showTextHudTips(message: "客户端暂不支持此上号方式")
            
            self.loginErrorBlock?(.LGECode_Fail_Error,"客户端不支持此上号方式")
           }
        }
        else{
            SWLGLog(withMsg: "即将备用token上号")
            _server_1()
        }
        
       
        
        
    }
    
    /// 8.x 方式入口
    func _8x(withQuickType:SWQuickInfoQuickTypeModel,version:Int = 84)  {
        
        token8x = SWLGqqToken8xx()
        
        token8x.game_id = "\(info!.game_id)"
        
        token8x.quickModel = withQuickType
        
        token8x.version = version
        
        token8x.eventblock = { [unowned self](status,msg) in
            
            
            
            switch status {
            case 0:
                
                self.loadingView?.hidden()
                
                
                
                let alert = SWAlertView(title: "提示", message: msg as? String ?? "" , okButtonText: "确定")
                
                alert.okActionBlock = { [unowned alert] () in
                    
                    alert.dismissAlertView()
                    self.reloadBlock?()
                }
                
                alert.show()
                
            case 1:
                
                self.loadingView?.hidden()
                
                let tokenArr = (msg as? String ?? "").split(separator: "_").map {
                    
                    String($0)
                }
                
                guard tokenArr.count > 0 else {
                    
                    return
                }
                
                if let url =  self.createLaunchUrl(accessToken: tokenArr[0], openid: tokenArr[1], ptoken: tokenArr[2]) {
                    
                    gameLaunch(withUrlStr: url)
                }
                
            
            case 2:
                print("84-错误\(msg as? String ?? "")")
                
                // 5.0 一种方式失败之后尝试下一种方式
                
                self.loginStack.pop()
                
                self._qqLogin_50()
            case 3:
                
                self.loadingView?.hidden()
                
                let info = msg as! [String:Any]
                
                let templatePath:String? = SWLGPlistUtil().getTemplate()
                
                let rawdata = try! Data.init(contentsOf: URL(fileURLWithPath: templatePath!))
                
                let json = NSKeyedUnarchiver.unarchiveObject(with: rawdata) as! NSDictionary
                
                let expires_in = info["expires_in"] as? Int ?? 0
                let encry_token = info["encrytoken"] as? String ?? ""
                let openid = info["openid"] as? String ?? ""
                let pf = info["pf"] as? String ?? ""
                let pfkey = info["pfkey"] as? String ?? ""
                let ptoken = info["pay_token"] as? String ?? ""
                let atoken = info["access_token"] as? String ?? ""
                json.setValue(expires_in, forKey: "expires_in")
                json.setValue(encry_token, forKey: "encrytoken")
                json.setValue(openid, forKey: "openid")
                json.setValue(pf, forKey: "pf")
                json.setValue(pfkey, forKey: "pfkey")
                json.setValue(ptoken, forKey: "pay_token")
                json.setValue(atoken, forKey: "access_token")
                

                let data1 =  try! NSKeyedArchiver.archivedData(withRootObject: json, requiringSecureCoding: true)
                
                let base64 =  data1.base64EncodedString()
                
                let game_package_name_ios = self.qq_orderInfo?.quick_info?.game_info?.package_ios_qq ?? ""
                
                let   openUrl:String = "\(game_package_name_ios)qzapp/mqzone/0?objectlocation=url&pasteboard=\(base64)"
                
                SWLGLog(withMsg: "8.X_Plist_message_\(openUrl))")
                
                gameLaunch(withUrlStr: openUrl)
            default:
                
                break
            }
        }
        
        token8x.param = qq_orderInfo
        
        token8x.queryToken()
    }
    
    
    /// 协议方式入口
    func _web(withQuickType:SWQuickInfoQuickTypeModel)  {
        
        loadingView?.hidden()
        
        let vc = SWLGQQTokenWebController.init()
        
        vc.game_id = "\(info!.game_id)"
        
        vc.quickModel = withQuickType
        
        vc.param = qq_orderInfo
        
        vc.eventBlock = { [unowned self,unowned vc](status,msg) in
            
            DispatchQueue.main.async {
                
           // 页面返回
                Router.pop()
            }
            
            if status == 1, let _msg = msg {
                
                let list = _msg.components(separatedBy: "_")
                
                //触发人脸，需要进行人脸检测
                if  let switch1 = self.face_verify_switch?.switch , switch1 == true{
                    
                    let gameSets:Set<String> = .init(arrayLiteral: "443","446","560","636","698","926","831","683")
                    
                    guard let gameid = self.qq_orderInfo?.order_info?.gameid else {
                        
                        showTextHudTips(message: "获取gameid 出错")
                        return
                    }
                    
                    if gameSets.contains(gameid),self.face_verify_switch != nil {
                        
                        
                        self.faceCheck(withinfo: .init(qq: qq_orderInfo!.qq, hopeToken: self.face_verify_switch!.hopetoken, url: self.face_verify_switch!.url, Switch: self.face_verify_switch!.switch2, chk_id: self.face_verify_switch!.chk_id, access_token: list[0], openid: list[1], ptoken: list[2], cookie: vc.cookie), isNew: true)
                        
                    }else{
                        
                        if let url = self.createLaunchUrl(accessToken: list[0], openid: list[1], ptoken: list[2]) {
                            
                            gameLaunch(withUrlStr: url)
                        }
                    }
                    
                }else{
                    
                    if let url = self.createLaunchUrl(accessToken: list[0], openid: list[1], ptoken: list[2]) {
                        
                        gameLaunch(withUrlStr: url)
                    }
                }
                
            }
            
            if status == 2 {
                
                print("web上号-错误\(msg ?? "")")
                
                // 5.0 一种方式失败之后尝试下一种方式
            
                self.loginStack.pop()
                
                self._qqLogin_50()
                
                
            }
        }
        
        
    // push 页面
        RouterUtils.currentTopViewController()?.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //服务端上号预处理
    func _server_pre(withQuickType:SWQuickInfoQuickTypeModel)  {
        
        serverQuickType = withQuickType
         
        self.loadingView?.hidden()
        
        if let faceSwitch = self.face_verify_switch, faceSwitch.switch == true {
            
            self.faceCheck(withinfo: .init(qq: qq_orderInfo!.qq, hopeToken: faceSwitch.hopetoken, url: faceSwitch.url, Switch: faceSwitch.switch2, chk_id: faceSwitch.chk_id, access_token: "", openid: "", ptoken: "", cookie: ""), isNew: false)
        }else{
            
            _server()
        }
    }
    
    
    func _server()  {
        
        tokenServer = SWLGqqTokenServer.init()
        tokenServer.param = qq_orderInfo
        tokenServer.game_id = "\(info!.game_id)"
        tokenServer.quickModel = serverQuickType
        tokenServer.eventBlock =  { [unowned self](status,msg) in
            
            if status == 0 {
                
                print("web上号-错误\(msg ?? "")")
                
                // 5.0 一种方式失败之后尝试下一种方式
            
                self.loginStack.pop()
                
                self._qqLogin_50()
                
                
            }
            
            if status == 1 ,let url = msg{
                
                gameLaunch(withUrlStr: url)
              
                
            }
            
            if status == 2 {
                
                self.reloadBlock?()
            }
        }
        
        
        tokenServer.toTask(loadingview: self.loadingView)
    }
    
    //备用token
    func _server_1()  {
        
        tokenServer = SWLGqqTokenServer.init()
        tokenServer.param = qq_orderInfo
        tokenServer.game_id = "\(info!.game_id)"
        tokenServer.quickModel = serverQuickType
 
        tokenServer.eventBlock = { [unowned self](status,msg) in
            
            if status == 1 ,let url = msg{
                
                gameLaunch(withUrlStr: url)
              
                
            }
            else{
                
                self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"上号失败10004")
            }
        }
        
        tokenServer.defaultTokenLoginGame(quick_token: qq_orderInfo?.quick_info?.quick_token,upload: true)
    }
}




extension SWQQLogin {
    
    
    /// 人脸检测 -开始游戏前 是否是新流程
    func faceCheck(withinfo:SWLoginGameFaceCheck._Info,isNew:Bool)  {
        
        let fc = SWLoginGameFaceCheck()
        fc.myInfo = withinfo
        fc.callBack { event in
            
            switch event {
            
            case let .error(msg) :
                
                print("人脸错误\(msg ?? "")")
                
                self.loginErrorBlock?(LGECode.LGECode_FaceVerify_Error,msg)
                //刷新订单接口--
            case let  .reloadTip(tipMsg):
                
                
                print("需要reload 订单\(tipMsg)")
                
                
                let alert = SWAlertView(title: "提示", message: tipMsg, okButtonText: "确定", cancelButtonText: "取消")
                
                alert.okActionBlock = {[unowned alert] () in
                    
                    self.reloadBlock?()
                    
                    alert.dismissAlertView()
                }
                
                alert.show()
                
            case let .success(type):
                
                if type == 0 {
                    
                    self._server()
                }else{
                    
                    if let url = self.createLaunchUrl(accessToken: withinfo.access_token!, openid: withinfo.openid!, ptoken: withinfo.ptoken!) {
                        
                        self.gameLaunch(withUrlStr: url)
                    }
                }
            }
            
        }
        
        if isNew == false {
            
            fc.oldLogDoOldInterfaceCheck()
        }else{
            
            fc.skeyGetSessionId()
        }
    }
    
    
    //拼接拉起游戏的Url
    func createLaunchUrl(accessToken:String,openid:String,ptoken:String) ->String? {
         
        var openUrl:String = ""
        
        guard let game_package_name_ios = qq_orderInfo?.quick_info?.game_info?.package_ios_qq else {
            
             showTextHudTips(message: "game schema is nil")
            
             return nil
        }
        
        if info!.game_id == "698" || info!.game_id ==  "1078" {
            
            openUrl = "\(game_package_name_ios)?platform=qq_m&user_openid=\(openid)&openid=\(openid)&launchfrom=sq_gamecenter&gamedata=&platformdata=&atoken=\(accessToken)&ptoken=\(ptoken)&huashan_com_sid=biz_src_zf_games"
            
        }else{
            
            openUrl = "\(game_package_name_ios)startapp?atoken=\(accessToken)&openid=\(openid)&ptoken=\(ptoken)&platform=qq_m&current_uin=\(openid)&launchfrom=sq_gamecenter"
        }
        
        
        return openUrl
        
        
        
    }
    
    //拉起游戏
    func gameLaunch(withUrlStr:String)  {
        
         SWLGLog(withMsg: "url->\(withUrlStr)")
         
         openApp(withUrl: withUrlStr) { result in
            
            if result == true {
                
                if SWOtherInfoWrap.shared.channel == .dfapp {
                   
                    let str = "App_MainInfo?bbh=\(SWAPPVersion())&dh=\(self.info!.unlock_code)&sys=&fr=10&longitude=&latitude=&address=&qq=&ios_sys_ver=\(UIDevice.current.systemVersion)"
                    
                    let encryptStr = ZSRc4.swRc4Encrypt(withSource: str, rc4Key: login_rc4_key)!
                    
                    SWNetworkingTool.requestFun(url: SW_API_QULICKLOGIN_INFO, method: .post, parameters: ["encryt_data":encryptStr]) { (_) in
                        
                    } failBlock: { (_) in
                        
                    }
                }
                
               
                self.loginErrorBlock?(LGECode.LGECode_Success,"")
            }else{
                
                self.loginErrorBlock?(LGECode.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
            }
        }
    }
    

    
    
    
    
}




