//
//  SWLGHMCloudGame.swift
//  Alamofire
//
//  Created by mac on 2022/4/7.
//

import Foundation
import AVFoundation
import DFOCBaseLib
import HandyJSON
import SocketRocket
#if !targetEnvironment(simulator)

import HMCloudPlayerCore
#endif



struct SWHMCloudGameError:Error {
       
    var code:Int
    
    var message:String
    
    
}


protocol SWHMCloudGameLoginProtocol:AnyObject {
     
    func SWHMCloudGameLoginTaskError(with:SWHMCloudGameError)
    
    func SWHMCloudGamePageDidPresent(with:UIViewController)
    
    func SWHMCloudGameLoginSuccess()
    
    func SWHMCloudGameOrderEnd()
         
    func SWHMCloudGameOrderAutoTs()
    
    func SWHMCloudGameCloseDidGame()
        
    
    
}

class SWHMCloudGame:NSObject,SWLoginGamePlatformProtocol {
    func login(withInfo: SWActInfo) {
         
         info = withInfo
        
         self.doTask()
    }
    
    func taskCancel() {
#if !targetEnvironment(simulator)
        self.stopHmGame(withEventId: 101)
        
        #endif
    }
    
      
    
    weak  var delegate:SWHMCloudGameLoginProtocol?
    
    var info:SWActInfo! //账号信息
    
    var  currentViewController:UIViewController?
    
    var  unlockModel:SWQuickLoginGameModel? //云游戏上号信息接口返回数据
    
    var  loadingView:SWLoginGameLoadingViewProtocol?
    
    var  hmSDKRegisted:Int = -1 //-1 未注册 1注册成功 2注册失败
    
    var  hmSDKRegistBlock:(()->())?//注册完成回调
    //到时不下线
    var is_offline:Bool = false
    //到时不下线最长延迟时间
    var timeOut:Int = 0
    
    //游戏包名
    var gamePackage:String = ""
    
    var hmcloudStatus_InGame:Bool = false //在对局中
    

    //是否检测登录态-如果是微信的话 传0写死 表示不检测， QQ的需要通过接口下发
    var checkLoginStatus:Bool = false
    
    //判断是否已经上报过102 登录type
    var isReportLoginType:Bool = false
    
    //订单websocket
    var order_websocket:SRWebSocket?
    
    var websocket_session_id:String?
    
    var timer_websocket:DispatchSourceTimer?
    
    var timeOffLineTrigger:Bool = false //触发到时不下线
    
    var cloudGameVC:UIViewController?
    
    deinit {
#if !targetEnvironment(simulator)
         websocket_sendTask_cancel()
        NotificationCenter.default.removeObserver(self)
        #endif
    }
    
    override init() {
        
        super.init()
        
        #if !targetEnvironment(simulator)
        CloudPlayerWarpper.sharedWrapper().delegate = self
        
        hmSDKRegisted = CloudPlayerWarpper.sharedWrapper().isRegisted() ? 1 : -1
        
        self.motitorApp()
        
        #endif
        
        
        
    }
    func doTask(){
         
         checkMicro {
            
             let alertView = SWAlertView.init(title: "提示", message: "游戏过程中会消耗大量流量,请在wifi环境下体验游戏", okButtonText: "确定", cancelButtonText: nil)
             alertView.okActionBlock = { [unowned alertView] () in
                 
                 alertView.dismissAlertView()
                 
                 self.beginHmCloud()
             }
             alertView.show()
        }
    }
    
    
    
    //检查麦克风权限
    func checkMicro(withNext:@escaping(()->()))  {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        switch audioSession.recordPermission {
        case .denied:
            let alert = SWAlertView.init(title: "提示", message: "为使用云游戏功能，请打开麦克风权限!", okButtonText: "去开启", cancelButtonText: "取消")
            alert.show()
            alert.okActionBlock = { [unowned alert] () in
                
                alert.dismissAlertView()
                
                SWAPP_OPENSetPage()
            }
            alert.cancelActionBlock = { [unowned alert] () in
                
                self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 101, message: "麦克风权限未开启"))
                alert.dismissAlertView()
            }
            
//            delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 101, message: "麦克风权限未开启"))
        case .granted:
            
            SWLGLog(withMsg: "允许使用")
            withNext()
        case .undetermined:
            
            audioSession.requestRecordPermission { (allowed) in
                
                guard allowed else {
                    
                    self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 101, message: "HMCloud 麦克风权限未开启"))
                    return
                }
                
                DispatchQueue.main.async {
                    
                    withNext()
                }
            }
           
            
        @unknown default:
            delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 101, message: "麦克风权限未开启"))
        }
    }
    
    func beginHmCloud() {
        
     #if targetEnvironment(simulator)
        
        self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 102, message: "HMCloud 海马云SDK不支持模拟器运行"))
        
     #else
        
        self.loadingView?.show()
        
        sw_logingame_qq_getOrderInfo(withUnlockCode: info.unlock_code) { (status, model) in
            
            if status == -2 {
                
                self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 301, message: "HMCloud 获取上号信息失败-网络异常"))
                SWLGError(withMsg: "HMCloud 获取上号信息失败-网络异常")
                return
            }
            
            if status == -1 {
                self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 301, message: "HMCloud 获取上号信息失败-数据解析失败"))
                SWLGError(withMsg: "HMCloud 获取上号信息失败-数据解析失败")
                
                
                return
            }
            if status != 1 {
               
                self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 301, message: "HMCloud 获取上号信息失败-状态码异常"))
                SWLGError(withMsg: "HMCloud 获取上号信息失败-状态码异常")
                
                
                return
            }
            
            guard let response = model else {
                
                self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 301, message: "HMCloud 获取上号信息失败-返回数据为空"))
                
                return //接口错误
            }
            
            self.unlockModel = response
            
            self.beginHmGame()
        }
        

        
     #endif
       
    }
    
    #if !targetEnvironment(simulator)
    
    //开始游戏
    func beginHmGame(){
        
        guard let quickModel = unlockModel?.quick_info else {
            
            self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 401, message: "HMCloud 上号信息数据为空"))
            return
        }
        
        guard let orderInfo = unlockModel?.order_info else {
            self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 401, message: "HMCloud 上号订单信息数据为空"))
            return
        }
        
        
        //到时不下线 true 不下线
         is_offline = quickModel.offline_switch == 1
        //到时不下线最长延迟时间
        if is_offline {
            
           timeOut = quickModel.cloud_timeout*60
        }
        
        //是否检测登录态-如果是微信的话 传0写死 表示不检测， QQ的需要通过接口下发
    
        if info.is_wx_server  == false {
           
           checkLoginStatus = quickModel.cloud_login == 1
        }
        
        SWLGLog(withMsg: "订单\(is_offline ? "到时不下线":"")| \(is_offline ? "超时时间\(timeOut)":""),\(checkLoginStatus ? "检测登录态":"")")
        
        let quick_token:String = quickModel.quick_token
        
        gamePackage = quickModel.game_info!.package_android  //游戏包名
        let orientation:Int = 0 //游戏横竖屏
        let userId:String = quickModel.cloud_uid //cloud_uid
        let userToken:String = userId

        let accessKey:String = quickModel.cloud_access_key //cloud_access_key
        let accessKeyId:String = quickModel.cloud_bid
        
        let playTimes:Int =  Int(orderInfo.zq)!*3600 + timeOut
        let channelName:String = SW_HMCLoudChannelId
        
        CloudPlayerWarpper.sharedWrapper().accessKeyId = accessKeyId
        CloudPlayerWarpper.sharedWrapper().accessKey = accessKey
        CloudPlayerWarpper.sharedWrapper().regist(SW_HMCLoudChannelId)
       
        SWLGLog(withMsg: "accessKeyId:\(accessKeyId),channelId:\(SW_HMCLoudChannelId),accessKey:\(accessKey)")
        
        let cToken:String = SWLGUtils.hmcloud_generateCToken(gamePackage, withUserId: userId,withUserToken: userToken, withAccessKey: accessKey, withAccessKeyId: accessKeyId, withChannelId: SW_HMCLoudChannelId)
        
        var gameOptions:[String:Any] = [
                                        CloudGameOptionKeyId:gamePackage,//
                                        CloudGameOptionKeyUserId:userId,
                                        CloudGameOptionKeyArchive:0,
                                        CloudGameOptionKeyProtoData:"",
                                        CloudGameOptionKeyConfigInfo:"config",
                                 CloudGameOptionKeyUserToken:userToken,
                               CloudGameOptionKeyOrientation:orientation, //
                                    CloudGameOptionKeyCToken:cToken,//
                                  CloudGameOptionKeyPriority:0,//
                               CloudGameOptionKeyPlayingTime:playTimes * 1000,//
//                                   CloudGameOptionKeyExtraId:quick_token,//
                                CloudGameOptionKeyAppChannel:channelName,//
                                        CloudGameOptionKeyStreamType:CloudCoreStreamingType.RTC.rawValue,//
                               
        ]
        
        if quickModel.quick_cloud.count > 0 {
           
            gameOptions[CloudGameOptionKeyCid] = quickModel.quick_cloud
        }
        
        if let option_des = gameOptions.toJsonString() {
            
            SWLGLog(withMsg: "HMCloud startSDK params : \(option_des)")
        }
        
        guard let currentVc = currentViewController else {
            SWLGLog(withMsg: "HMCloud currentViewController nil .")
            self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 103, message: "HMCloud currentViewController nil ."))
            
            return
        }
        
        
        if hmSDKRegisted != -1 {
            
            SWLGLog(withMsg: "hmSDK registed")
            self.prepare_HMCloudPage(with: currentVc, options: gameOptions)
            
        }else{
            
            hmSDKRegistBlock  = { [unowned self] () in
                
                
                if self.hmSDKRegisted == 1 {
                    SWLGLog(withMsg: "hmSDK registed success")
                    self.prepare_HMCloudPage(with: currentVc, options: gameOptions)
                }else{
                    SWLGLog(withMsg: "hmSDK registed fail")
                    self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 201, message: "HMCloud startSDK Registed Fail ."))
                }
                
                
            }
            
        }
         
    }
    
    func prepare_HMCloudPage(with:UIViewController,options:[String:Any])  {
        
        guard let vc = CloudPlayerWarpper.sharedWrapper().prepare(options) else {
            
            SWLGLog(withMsg: "HMCloud startSDK Failed .")
            self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: 201, message: "HMCloud startSDK Failed ."))
            return
        }
        //打开云游戏页面 -代表上号成功
        vc.modalPresentationStyle = .fullScreen
        
        with.present(vc, animated: true) {
            
            self.delegate?.SWHMCloudGamePageDidPresent(with: vc)
            
            self.loadingView?.hidden()
        }
        
        cloudGameVC = vc
       
        
    }
    
    //游戏登录成功启动
    func gameSuccess(withId:String?)  {
         
        if let cloudId = withId {
            
            SWLGLog(withMsg: "HMCloud cloudId \(cloudId)")
            
            //上报
            setReportHmRent()
            
            //开启socket
            
            connectWebsocket()
            
            self.delegate?.SWHMCloudGameLoginSuccess()
            
            
            if let _cloudVC = cloudGameVC  {
                    
                self.showSuspendView(WithSuperView: _cloudVC.view)
            }
            
        }else{
            SWLGLog(withMsg: "HMCloud cloudId 为空")
            stopHmGame(withEventId: 1,withmsg: "HMCloud cloudId 为空")
        }
    }
    
    //停止游戏
    func stopHmGame(withEventId:Int,withmsg:String = "")  {
        
        
        CloudPlayerWarpper.sharedWrapper().stopAndDismiss(true)
        
        websocket_sendTask_cancel()
        
        closeWebsocket()
        
        //游戏订单结束  501 投诉撤单
        if withEventId == 0  {
           
            self.delegate?.SWHMCloudGameOrderEnd()
        }
        else if withEventId == 501 {
            
            self.delegate?.SWHMCloudGameOrderAutoTs()
        }
        else if withEventId == 101 {
            
            //无需处理
        }
        // 用户关闭
        else if withEventId == 300 {
            
            self.delegate?.SWHMCloudGameCloseDidGame()
            
        }
        else{
            
            self.delegate?.SWHMCloudGameLoginTaskError(with: .init(code: withEventId, message: withmsg))
        }
    }
    
    func updatePlayTime(withTimes:Int)  {
         
         CloudPlayerWarpper.sharedWrapper().updateTimes(withTimes)
         
    }
    //MARK: 显示游戏手柄按钮
    func showSuspendView(WithSuperView:UIView)  {
        
        let suspendView = DFSuspendView.suspendView(With: WithSuperView)
        
        suspendView.clickCallBack = { [unowned self] () in
            
            self.showBackGameView(withSuperView: WithSuperView)
        }
        
         
    }
    
    //MARK: 监听程序进入后台 前台
    func motitorApp()  {
         
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    
   @objc  func appEnterBackground()  {
        
       CloudPlayerWarpper.sharedWrapper().pause()
    }
    
    @objc  func appEnterForeground()  {
        
        CloudPlayerWarpper.sharedWrapper().resume(0)
        
    }
    
    //MARK: 显示返回游戏
    func showBackGameView(withSuperView:UIView)  {
        
        let backView = DFBackGameView.backGameView()
        backView.closeGameBlock = { [unowned self] () in
            
            self.userClose()
        }
        
        backView.show(with: withSuperView)
    }
    
    //MARK: 定时发消息任务
    func websocket_sendTask_do()  {
        
        websocket_sendTask_cancel()
        
        timer_websocket = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
        
        timer_websocket?.schedule(deadline: .now(), repeating: 10)
        
        timer_websocket?.setEventHandler(handler: { [unowned self] () in
            
            if let data = self.websocketMessage() {
               
                try? self.order_websocket?.send(data: data)
            }
        })
        
        timer_websocket?.resume()
    }
    
    func websocket_sendTask_cancel()  {
         
            timer_websocket?.cancel()
            timer_websocket = nil
        
         
    }
    
    
    //MARK: 需要发送给服务端Websocket的数据包
    func websocketMessage() -> Data? {
        
        guard let sessionId = websocket_session_id else {
            
            return nil
        }
        //获取当前时间戳
        let timestamp:String = Date().timeStamp
        
        let websocketSignStr = SWOtherInfoWrap.shared.websocketSignStr
        
        let str:String = "session_id=\(sessionId)&timestamp=\(timestamp)&appsecret=\(websocketSignStr)"
        
        //md5计算签名
        let sign:String = str.swMD5Encrypt()
    
        
        var dic:Dictionary<String,Any> = [:]
        
       
        dic = ["action":"order_progress", "session_id":"\(sessionId)", "sign":"\(sign)", "timestamp":"\(timestamp)", "uncode":"\(info.unlock_code)"]
        
        
        let indata:Data = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let send_str:String = String(data: indata, encoding: .utf8)!
        
        return send_str.data(using: .utf8)!
    }
    //MARK: 需要发送给中间件的数据包
    //--检测登录态
    func hmCloudMessage_loginStatus() -> [String:Any] {
        
        let gameId = gamePackage //游戏包名
        var jsonDic:[String:Any] = [:]
        
        jsonDic["type"] = 101
        jsonDic["from"] = "com.houmingxuan.bundleid.test"
        jsonDic["game"] = gameId
           
        if gameId == "com. tencent. ikchess" {
                jsonDic["db"] = "itop_login.txt"
                jsonDic["table"] = ""
                jsonDic["column"] = ""
        }else{
                
                jsonDic["db"] = "WEGAMEDB2"
                jsonDic["table"] = "qq_login_info"
                jsonDic["column"] = "open_id"
        }
            
        
        return jsonDic
        
    }
    
    
    
    //MARK:  接口调用
    //上报接口
    func setReportHmRent(){
        
        guard let cloudId =  CloudPlayerWarpper.sharedWrapper().getCloudId() else {
            
            SWLGWarning(withMsg: "HMCloud cloudId is nil")
            return
        }
            
        SWLGLog(withMsg: "cloudId==\(cloudId)")
        let cloud_json = ["cid":cloudId].toJsonString()!
        let cloud_data = cloud_json.data(using: .utf8)!.base64EncodedString()
        
        var param:[String:Any] = [:]
        param["order_id"] = unlockModel?.order_info?.orderid
        param["status"] = 1
        if let qtype = unlockModel?.quick_info?.quick_type.first {
            
            param["source"] = qtype.source
        }else{
            param["source"] = unlockModel?.default_source
        }
        param["order_login"] = unlockModel?.quick_info?.order_login
        param["quick_version"] = 7
        param["remark"] = "haimaCloud_login_game cid-\(cloudId)"
        param["cloud_data"] = cloud_data
        
        
        SWNetworkingTool.requestFun(url: SW_API_HMCloud_ReportOrder, method: .post, parameters: param) { response in
            
            SWLGLog(withMsg: "cloudReportOrder response \(response)")
            
        } failBlock: { error in
            
            SWLGLog(withMsg: "cloudReportOrder error \(error)")
        }

    }
    
    //登录态
    func middilewareLogin(withMode:Int,withOpenId:String)  {
        
        SWLGLog(withMsg: "middilewareLogin")
        var param:[String:Any] = [:]
        
        param["quick_version"] = 7
        if let qtype = unlockModel?.quick_info?.quick_type.first {
            
            param["source"] = qtype.source
        }else{
            param["source"] = unlockModel?.default_source
        }
        param["type"] = 3
        param["mode"] = withMode
        param["openid"] = withOpenId
        param["order_id"] = unlockModel?.order_info?.orderid
        
        SWNetworkingTool.requestFun(url: SW_API_HMCloud_middlewareLogin, method: .post, parameters: param) { response in
            
            SWLGLog(withMsg: "SW_API_HMCloud_OffLine response \(response)")
            
            guard let model = JSONDeserializer<SWHttpResponse<SWHMCloudMiddlewareLoginModel>>.deserializeFrom(json: response) else {
                
                return
            }
            
            if model.data.auto_ts == true {
                
                SWLGLog(withMsg: "HMCLoud 无登录态 自动撤单")
                self.stopHmGame(withEventId: 501,withmsg: "HMCLoud 无登录态 自动撤单")
            }
            
            
            
        } failBlock: { error in
            
            SWLGLog(withMsg: "cloudReportOrder error \(error)")
        }
    }
    
    //云游戏到时下线
    func cloudOffLine(in_game:Int)  {
        
        var param:[String:Any] = [:]
        
        param["quick_version"] = 7
        param["order_id"] = unlockModel?.order_info?.orderid
        param["in_game"] = in_game
        SWNetworkingTool.requestFun(url: SW_API_HMCloud_OffLine, method: .post, parameters: param) { response in
            
            SWLGLog(withMsg: "SW_API_HMCloud_OffLine response \(response)")
            
        } failBlock: { error in
            
            SWLGLog(withMsg: "cloudReportOrder error \(error)")
        }
    }
    
    //MARK: 连接webSocket
    func connectWebsocket()  {
         
        if order_websocket != nil {
            order_websocket!.close()
            order_websocket!.delegate = nil
            order_websocket = nil
        }
            
        order_websocket = SRWebSocket.init(url: websocket_Url())
        order_websocket!.delegate = self
        order_websocket!.open()
        
        
    }
    
    func closeWebsocket()  {
         
        order_websocket?.close()
        order_websocket = nil
    }
    
    //MARK:  用户主动关闭游戏
    func userClose()  {
        
        self.stopHmGame(withEventId: 300, withmsg: "")
    }
    
    #endif
}

#if !targetEnvironment(simulator)
extension SWHMCloudGame:CloudPlayerWarpperDelegate{
    
    func cloudPlayerReigsted(_ success: Bool) {
        
         SWLGLog(withMsg: "HMCloud registed \(success ? "sussess" : "fail")")
        
         hmSDKRegisted = success ? 1 : 2
         DispatchQueue.main.async {
            
             self.hmSDKRegistBlock?()
         }
            
        
    }
    
    func cloudPlayerResolutionList(_ resolutions: [HMCloudPlayerResolution]!) {
        
        SWLGLog(withMsg: "HMCloud ResolutionList")
    }
    
    func cloudPlayerRecvMessage(_ msg: String!) {
        SWLGLog(withMsg: "HMCloud recvMessage \(msg ?? "")")
        
        //{"type":102,"gameStatus":1,"desc":"登陆成功","log":"04-11 11:17:07.776  5308  5308 I GCloudCore: [2022-04-11 11:17:07 776] | Info | [GCloudCore] |5308| WGPlatformHandler.mm:78|OnLoginNotify| flag:0,plat:2,desc:MSDK Login Success!\n"}
        if let messageModel = JSONDeserializer<SWHMCloudMessageModel>.deserializeFrom(json: msg) {
            
            if is_offline {
                
                if messageModel.type == 102 {
                    
                    //记录游戏是否是对局中 =2 对局中 1 3 非对局
                    hmcloudStatus_InGame = messageModel.gameStatus == 2
                    
                    if messageModel.gameStatus == 1 {
                        SWLGLog(withMsg: "海马游戏Status 游戏登陆成功")
                    }
                    if messageModel.gameStatus == 2 {
                        SWLGLog(withMsg: "海马游戏Status 进入对局")
                    }
                    if messageModel.gameStatus == 3 {
                        SWLGLog(withMsg: "海马游戏Status 对局结束")
                    }
                }
            }
            
            if checkLoginStatus {
                
                //查库(101)的方式 上报mode 是0  查日志(102)的model是 1
                if messageModel.type == 102  && messageModel.gameStatus == 1 {
                    
                    if isReportLoginType == false {
                        
                        isReportLoginType = true
                        
                        middilewareLogin(withMode: 1, withOpenId: messageModel.desc)
                        
                       
                    }
                    
                    
                    
                    
                }
                
                if messageModel.type == 101 {
  
                    var openId = messageModel.openId
                    
                    if messageModel.errorMsg != "" {
                        
                        openId = messageModel.errorMsg
                    }
                    //未获取到openid
                    if openId == "" {
                       
                       SWLGError(withMsg: "HMCloud 获取登录Type openid 失败")
                    }
                    
                    middilewareLogin(withMode: 0, withOpenId: openId)
                }
            }
            
        }
        
         
    }
    
    func cloudPlayerPrepared(_ success: Bool) {
        
        DispatchQueue.main.async { [self] in
            
            if success {
                
                CloudPlayerWarpper.sharedWrapper().play()
                
               
            }else{
                
                self.stopHmGame(withEventId: 2,withmsg: "Prepare fail")
            }
        }
    }
    
    func cloudPlayerId(_ cid: String?) {
        
        SW_mainthread_call {
            
            self.gameSuccess(withId: cid)
        }
         
    }
    
    func cloudPlayerStateChanged(_ state: CloudPlayerState) {
        
        switch state {
        case .PlayerStateInstancePrepared:
            
            
            SWLGLog(withMsg: "HMCloud Show Loading")
        case .PlayerStateVideoVisible:
            //视频第一帧
            SWLGLog(withMsg: "HMCloud Remove Loading")
            
            self.gameSuccess(withId: CloudPlayerWarpper.sharedWrapper().getCloudId())
            //视频第一帧 如果检测登录态 发送消息到中间件
            if checkLoginStatus {
  
                let msg = hmCloudMessage_loginStatus().toJsonString()!
                
                CloudPlayerWarpper.sharedWrapper().sendMessage(msg)
            }
            
        case .PlayerStateStopCanRetry:
            SWLGLog(withMsg: "HMCloud Stoped")
            stopHmGame(withEventId: 3,withmsg: "HMCloud Stoped")
        case .PlayerStateStop:
            SWLGLog(withMsg: "HMCloud Stopped")
            stopHmGame(withEventId: 3,withmsg: "HMCloud Stopped")
        case .PlayerStateFailed:
            SWLGLog(withMsg: "HMCloud Failed.")
            stopHmGame(withEventId: 3,withmsg: "HMCloud Failed.")
        case .PlayerStateTimeout:
            SWLGLog(withMsg: "HMCloud Timeout")
            stopHmGame(withEventId: 3,withmsg: "HMCloud Timeout")
        case .PlayerStateSToken:
            SWLGLog(withMsg: "HMCloud Show Loading")
        @unknown default:
            SWLGLog(withMsg: "HMCloud state unowned state")
        }
    }
    
    func cloudPlayerQueueStateChanged(_ state: CloudPlayerQueueState) {
        
        switch state {
        case .PlayerQueueStateConfirm:
            
            CloudPlayerWarpper.sharedWrapper().queueConfirm()
        case .PlayerQueueStateUpdate:
            SWLGLog(withMsg: "HMCloud Update")
        case .PlayerQueueStateEntering:
            
            SWLGLog(withMsg: "HMCloud  Entering")
        @unknown default:
            SWLGLog(withMsg: "HMCloud QueueState unknown ")
        }
    }
    
    func cloudPlayerResolutionStateChange(_ state: CloudPlayerResolutionState) {
        
        SWLGLog(withMsg: "HMCloud ResolutionStateChange\(state)")
    }
    
    func cloudPlayerStasticInfoReport(_ state: CloudPlayerStasticState) {
        
        SWLGLog(withMsg: "HMCloud StasticInfoReport \(state)")
    }
    
    func cloudPlayerMaintanceStateChanged(_ state: CloudPlayerMaintanceState) {
        
        SWLGLog(withMsg: "HMCloud MaintanceStateChanged\(state)")
    }
    
    func cloudPlayerTimeStateChanged(_ state: CloudPlayerTimeState) {
        
        SWLGLog(withMsg: "HMCloud TimeStateChanged\(state)")
    }
}





extension SWHMCloudGame:SRWebSocketDelegate {
    
    //链接成功
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        
        SWLGLog(withMsg:"==== Websocket Connected ====")
        
    }
    
    //链接失败
    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        //这里可进行重连
        SWLGLog(withMsg: ":( Websocket Failed With Error \(error)")
    }
    
    //接收数据
    func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any) {
        
        guard let messageModel = JSONDeserializer<SWWebsocketMessageModel>.deserializeFrom(json: message as? String) else {
            
            SWLGError(withMsg: "不支持的消息类型")
            return
        }
        
        guard let messageData = messageModel.data else {
            
            SWLGError(withMsg: "消息data 为空")
            return
        }
         
        if messageModel.action == "link" {
            
            //已链接然后获取session_id
            websocket_session_id = messageData.session_id
            
            websocket_sendTask_do()
            
        }
        
        if messageModel.action == "order_progress" {
            
            switch messageData.order_status {
            case 2,0:
                
                SWLGLog(withMsg:"订单结束或者是异常\(messageData.order_status)")
                
                //王者荣耀且开启了到时不下线 判断是否要加游戏时长
                if  gamePackage == "com.tencent.tmgp.sgame" && is_offline == true {
                    
                    
                    //判断是否在游戏中-
                    
                    if hmcloudStatus_InGame == false {
                        
                        SWLGLog(withMsg:"订单游戏结束")
                        cloudOffLine(in_game: 0)
                        
                        stopHmGame(withEventId: 0)
                        
                    }else{
                        SWLGLog(withMsg:"订单还在游戏中")
                        
                        cloudOffLine(in_game: 1)
                        
                        if timeOffLineTrigger == false {
                            print("开启到时不下线任务")
                            timeOffLineTrigger = true
                            //最大超时时间 结束云游戏订单
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(timeOut)) {
                                
                                print("到时不下线任务响应")
                                
                                self.stopHmGame(withEventId: 0)
                            }
                        }
                        
                       
                    }
                    
                }else{
                    SWLGLog(withMsg:"订单游戏结束-不是王者或者是未开启到时不下线")
                     //直接结束游戏
                    stopHmGame(withEventId: 0)
                    
                }
          
            default:
                SWLGLog(withMsg:"订单正常")
            }
            
        }
            
        
    }
    
    //连接关闭
    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
        // 判断是何种情况的关闭，如果是人为的就不需要重连，如果是其他情况，就重连
        SWLGLog(withMsg: "==== webSocket Closed! ====")
    }
    
    // 接收服务器发送的pong消息
    func webSocket(_ webSocket: SRWebSocket, didReceivePong pongData: Data?) {
        
         SWLGLog(withMsg: "==== Websocket received pong ====")
    }
    
}

#endif

