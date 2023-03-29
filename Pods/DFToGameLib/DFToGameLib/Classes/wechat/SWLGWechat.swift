//
//  SWLGWechat.swift
//  DoFunNew
//
//  Created by mac on 2021/6/3.
//

import Foundation
import DFBaseLib
import DFOCBaseLib
import HandyJSON







class SWWechatLoginBase: SWLoginGamePlatformProtocol {
    
    
    /// 微信上号 工厂方法
    /// - Parameter with: 0 老版本 (模拟器方式)  1新版本ipad协议
    static func wechatLogin(with:SWQuickLoginQuickInfoModel?) -> SWWechatLoginBase {
        
        
        if let quickModel = with {
            
            if quickModel.open_mode == "1" {
                
                let ipad = SWWechatLogin_ipad_server.init()
                ipad.quickModel = quickModel
                return ipad
            }else{
                let ipad  = SWWechatLogin_ipad_local.init()
                ipad.quickModel = quickModel
                return ipad
            }
        }else{
          
            let simulator = SWWechatLogin_simulator.init()
            
            return simulator
        }
        
         
    }
    
    var loadingView: SWLoginGameLoadingViewProtocol?
    
    var loginErrorBlock:((LGECode,String?)->())?
    
    var info:SWActInfo?
    
    var reloadBlock:((String?)->())?
    
    var quickModel:SWQuickLoginQuickInfoModel!
    
    //微信货架游戏包名 -刀锋互娱APP QQ和微信一致，上号器 为game_package_name_ios_wx
    var wx_package_openScheme:String {
        
        get {
            
            if SWOtherInfoWrap.shared.channel == .shanghaoqi {
                
                return info!.game_package_name_ios_wx
                
            }else{
                
                return info!.game_package_name_ios
            }
        }
    }
    
   
    
    func login(withInfo: SWActInfo) {
        
         info = withInfo
         
        
    }
    
    func tokenDecrypt(withToken:String) -> String? {
         
        return  ZSRc4.swRc4Decrypt(withSource: withToken, rc4Key: game_auth_key)
        
    }
    
    func taskCancel() {
        
         
    }
}


func runTimer(withSumTimes:Int,withstep:Int = 2,withHandler:@escaping()->(),withFinish:@escaping ()->()) -> DispatchSourceTimer {
    
    let timer =  DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
    
    timer.schedule(deadline: DispatchTime.now(), repeating: Double(withstep))
    
    var times = withSumTimes
    
    timer.setEventHandler {
         
        times -= withstep
        
        if times > 0 {
            
            withHandler()
        }else{
            withFinish()
            
        }
          
    }
    
    timer.resume()
    
    return timer
}

func freeTimer(withTimer: inout DispatchSourceTimer?)  {
    
    withTimer?.cancel()
    withTimer = nil
    
}

/// 微信登录 模拟器方式
class SWWechatLogin_simulator: SWWechatLoginBase {
    
    
    
    var tokenpollingTimer:DispatchSourceTimer?
    var resetpollingTimer:DispatchSourceTimer?
    
    
    
    
    deinit {
        
        freeTimer(withTimer: &tokenpollingTimer)
        
        freeTimer(withTimer: &resetpollingTimer)
        
    }
    
    
    override func login(withInfo: SWActInfo) {
        
        super.login(withInfo: withInfo)
        
        loadingView?.show()
        
        sw_logingame_wx_joinTokenQueue(orderId: "\(withInfo.id)") { code in
            
            guard let status = code else {
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                return
            }
           
            
            switch status {
            
            //已经获取过token,使用之前获取的token直接登录
            case 4:
                self.loadingView?.hidden()
                self.openApp(withUrl: self.wx_package_openScheme) { result in
                   
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                }
        
            //轮询微信上号token,6分钟 2秒一次
            case 1,3:
                let time:Int = 360
                
                self.tokenpollingTimer = self.tokenpollingTimer ?? runTimer(withSumTimes: time, withHandler: {
                    
                    self.checkLoginCode()
                }, withFinish: {
                    
                    freeTimer(withTimer: &self.tokenpollingTimer)
                })
                
            case -1:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Json_error,"加入token队列-数据异常")
            default:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"加入token队列-逻辑错误")
                break
            
            }
        }
    }
    
    
    //获取微信token -轮询调用
    func checkLoginCode()  {
         
        sw_logingame_wx_getToken(orderId: "\(info!.id)") { (code,msg) in
            
            guard let status = code else {
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                return
            }
            
            switch status {
            //获取失败 进入修复队列
            case 0,3:
                
                freeTimer(withTimer: &self.tokenpollingTimer)
                self.joinResetQueue()
            //成功
            case 1:
                freeTimer(withTimer: &self.tokenpollingTimer)
                self.loadingView?.hidden()
                guard msg.count > 0 else {
                   
                    self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"获取微信token为空")
                    
                    return
                }
                
                guard let rc4CodeStr = self.tokenDecrypt(withToken: msg.uppercased()),rc4CodeStr.count > 0 else {
                    
                    self.loginErrorBlock?(LGECode.LGECode_Crypt_Error,"获取微信code解密失败")
                    return
                }
                
                let url = "\(self.wx_package_openScheme)oauth?code=\(rc4CodeStr)&state=weixin"
                SWLGLog(withMsg: "wexin:\(url)")
                
                self.openApp(withUrl: url) { result in
                   
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                }
             
            //等待开通中
            case 2:
                print("正在获取游戏信息...")
            case -1:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Json_error,"获取微信token接口数据异常")
            default:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,msg)
                break
            }
        }
    }
    
    
    // 加入修复token 队列
    func joinResetQueue()  {
        
        sw_logingame_wx_joinResetQueue(orderId: "\(info!.id)") { code in
            
            guard let status = code else {
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                return
            }
            
            
            switch status {
            
            case 1,3:
                let time = 180
                self.resetpollingTimer = self.resetpollingTimer ?? runTimer(withSumTimes: time, withHandler: {
                    
                    self.checkResetcodeData()
                    
                }, withFinish: {
                   
                    freeTimer(withTimer: &self.resetpollingTimer)
                });
            
            case 4:
                self.loadingView?.hidden()
                self.openApp(withUrl: self.wx_package_openScheme) { result in
                   
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                }
            case -1:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Json_error,"json error")
            default:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"")
                break
            }
        }
       

    }
    
    
    // 轮询修复token
    func checkResetcodeData()  {
         
        sw_logingame_wx_resetData(orderId: "\(info!.id)") { (code, msg ) in
            
            guard let status = code else {
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                return
            }
            
            switch status {
            
            case 1 :
                self.loadingView?.hidden()
                freeTimer(withTimer: &self.tokenpollingTimer)
                
                guard let rc4CodeStr = self.tokenDecrypt(withToken: msg.uppercased()),rc4CodeStr.count > 0 else {
                    
                    self.loginErrorBlock?(LGECode.LGECode_Crypt_Error,"获取微信code解密失败")
                    return
                }
                
                let url = "\(self.wx_package_openScheme)oauth?code=\(rc4CodeStr)&state=weixin"
                
                self.openApp(withUrl: url) { result in
                    
                   
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                }
            case 2 :
            
                print("等待开通")
            case -1:
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Json_error,"轮询修复-数据异常")
            default :
                self.loadingView?.hidden()
                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,msg)
                break
                
            }
        }
         
    }
    
    
    
    
    
    
    
    override func taskCancel() {
        
        freeTimer(withTimer: &tokenpollingTimer)
        freeTimer(withTimer: &resetpollingTimer)
    }
}


/// 微信登录 ipad 方式 服务端上号
class SWWechatLogin_ipad_server: SWWechatLoginBase {
      
    override func login(withInfo: SWActInfo) {
        
        super.login(withInfo: withInfo)
        
        requestLoginTask()
        
        
    }
    
    var isReport:Bool = false
    
    
    //php 上号接口返回code=2 需要重试
    func retry()  {
         isReport = false
         self.server_queue_task?.taskEnd()
         requestLoginTask()
    }
    
    var server_queue_task:DFQueueHttpTask<String>?
    
    //中台轮询id
    var queryModel:SWZHTQueryModel?
    
    
    
    /// 发起服务端上号流程 -获取query id
    func requestLoginTask()  {
        
        sw_zht_login_request(withBusinessType: quickModel.biz_type, openMode: "1", pt: quickModel.pt, businessData: quickModel.biz_data) { response in
            
            switch response {
            case .succese(let string):
                 
                guard let model  = SWjd<SWHttpResponseOrNil<String>>.deserializeFrom(json: string) else {
                    
                    self.loginErrorBlock?(.LGECode_Json_error, "数据解析异常")
                    
                    return
                    
                }
                
                guard let data = model.data else {
                    
                    self.loginErrorBlock?(.LGECode_Request_DataNull, "接口返回数据为空")
                    
                    return
                }
                
                guard let json = zhongTai_data(data: data,tp:SWZHTQueryModel.self)  else {
                    
                    self.loginErrorBlock?(.LGECode_Crypt_Error, "数据解密失败")
                    return
                }
                
                
                self.queryModel = json
                
                self.queueTask_queryLoginResult()
                
            case .netError:
                
                self.loginErrorBlock?(.LGECode_Request_Net, SW_NETErrorDescription)
            }
        }
    }
    
    
    /// 轮询查询服务端上号结果
    func queueTask_queryLoginResult()  {
        
        server_queue_task = DFQueueHttpTask<String>.init(withResult: {[unowned self] (result) in
            
            if let info = result {
                
                //状态码异常 停止轮询
                if info.code != 200  {
                   
                   self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"状态码异常")
                   self.server_queue_task?.taskEnd()
                    
                }else{
                    //获取到异步轮询的数据 停止轮询
                    if let data = info.data , data.isEmpty == false {
                        
                       let jsonStr =  DFAES.aes256DecryptECB(data, key: zhongtai_aesKey())
                       
                        if jsonStr == "null" {
                            //未获取到异步轮询的数据 继续 轮询
                            SWLGLog(withMsg: "未获取到异步轮询的数据 继续 轮询")
                        }else{
                           
                            self.server_queue_task?.taskEnd()
                            
                            if let model = SWjd<SWZHTReqTxModel>.deserializeFrom(json: jsonStr) {
                                
                                SWLGLog(withMsg: "服务器上号结果:\(jsonStr)")
                                
                                guard self.isReport == false else {
                                    
                                    return
                                }
                                
                                self.isReport = true
                                
                                self.uploadResult(withModel: model)
                            }else{
                                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"数据解密失败")
                            }
                            
                            
                        }
                            
                        
                    }else{
                        
                        
                        self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"返回数据为空")
                        self.server_queue_task?.taskEnd()
                    }
                }
                
            }else{
                //网络异常 数据解析异常 停止轮询
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                self.server_queue_task?.taskEnd()
            }
        })
        let service = MJHttpService.init()
        service.apiType = 1
        service.httpMethod = .post
        service.param = ["queueId":queryModel!.queueId,"openMode":"1"]
        service.api = SW_ZHT_API_QueryLoginResult
        server_queue_task?.httpService = service
        server_queue_task?.taskDo()
    }
    
    
    /// 结果上报
    func uploadResult(withModel:SWZHTReqTxModel)  {
        
        sw_wx_login_report(withQueue_id: quickModel.queue_id, withOrder_id: info?.order_id, withUncode: info!.unlock_code, status: "\(withModel.handleStatus == 30 ? 1 :withModel.handleStatus)", remark: withModel.handleStatusMsg, quick_version: "7") { (status, message) in
            
            switch status {
                
            case -1,-2,1:
                //接口失败 或者是 状态码1  直接上号
                print("上号")
                guard withModel.authCode.isEmpty == false else {
                    self.loginErrorBlock?(.LGECode_Request_DataNull, "授权码为空")
                    return
                }
                let url = "\(self.wx_package_openScheme)oauth?code=\(withModel.authCode)&state=weixin"
                SWLGLog(withMsg: "打开游戏url=\(url)")
                self.openApp(withUrl: url) { (result) in
                    
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                    
                }
                
                
            case 2:
                self.retry()
                //撤单
            case 3:
                self.reloadBlock?(message)
                self.taskCancel()
            default:
                self.loginErrorBlock?(.LGECode_TxRequest_Error, message)
                self.taskCancel()
            }
           
        }
    }
    
    
    override func taskCancel() {
        
        server_queue_task?.taskEnd()
    }
}

/// 微信登录 ipad 方式 本地上号
class SWWechatLogin_ipad_local: SWWechatLoginBase {
    
    
    //中台轮询id
    var queryModel:SWZHTQueryModel?
    
    var currentQueryTask:DFQueueHttpTask<String>?
    
    var redo_460:Bool = false  //获取轮询获取授权码数据包时候 如果 返回 460 ，返回的不止460  还有新的腾讯报文，你要拿报文重新去调腾讯，
    var step:Int = 1 //本地上号流程步骤
    
    override func login(withInfo: SWActInfo) {
        
        super.login(withInfo: withInfo)
        
        loadingView?.show()
        
        doTask()
        
    }
    override func taskCancel() {
        
        currentQueryTask?.taskEnd()
        currentQueryTask = nil
        
    }
    func retry()  {
        
        //
        currentQueryTask?.taskEnd()
        currentQueryTask = nil
        redo_460 = false
        step = 1
        doTask()
    }
    
    func doTask(withData:Any? = nil)  {
        
       switch step {
        
        
        case 1:
            
        requestLoginTask();
            
        case 2:
            
        queueTask_queryRefreshTokenPackage()
        case 3:
             
        tencentTask_refreshToken(withReqTxData: withData as! String)
        case 4:
        sendTokenTask(withTokenData: withData as! String)
        case 5:
        queueTask_queryAuthCodePackage()
        
        case 6:
        tencentTask_queryAuthCode(withReqTxData: withData as! String)
        case 7:
        sendAuthCodeTask(withAuthCodeData: withData as! String)
        case 8:
        queueTask_queryResult()
        default:
            SWLGError(withMsg: "未知操作")
        }
    }
    //MARK:  Step 1  发起本地上号流程 -获取query id
    func requestLoginTask()  {
        
        SWLGLog(withMsg: "即将发起本地上号流程")
        sw_zht_login_request(withBusinessType: quickModel.biz_type, openMode: "2", pt: quickModel.pt, businessData: quickModel.biz_data) { response in
            
            switch response {
            case .succese(let string):
                 
                guard let model  = SWjd<SWHttpResponseOrNil<String>>.deserializeFrom(json: string) else {
                    
                    self.loginErrorBlock?(.LGECode_Json_error, "数据解析异常")
                    
                    return
                    
                }
                
                guard let data = model.data else {
                    
                    self.loginErrorBlock?(.LGECode_Request_DataNull, "接口返回数据为空")
                    
                    return
                }
                
                guard let json = zhongTai_data(data: data,tp:SWZHTQueryModel.self)  else {
                    
                    self.loginErrorBlock?(.LGECode_Crypt_Error, "数据解密失败")
                    return
                }
                
                
                self.queryModel = json
                
                self.step = 2
                self.doTask()
                
            case .netError:
                
                self.loginErrorBlock?(.LGECode_Request_Net, SW_NETErrorDescription)
            }
        }
    }
    
    
    //MARK:  Step  4发送token到中台
    func sendTokenTask(withTokenData:String)  {
        SWLGLog(withMsg: "Step  4发送token到中台")
        let service = MJHttpService.init()
        service.httpMethod = .post
        service.apiType = 1
        service.api  = SW_ZHT_API_getResult
        service.param = ["queueId":queryModel!.queueId, "openMode":"2","analysisType":"1","txdata":withTokenData]
        SimpleHttp.default.httpTask(service) { response in
            
            switch response {
            case .succese(let string):
                
                guard let model  = SWjd<SWHttpResponseOrNil<String>>.deserializeFrom(json: string) else {
                    
                    self.loginErrorBlock?(.LGECode_Json_error, "数据解析异常")
                    
                    return
                    
                }
                
                guard model.code == 200 else {
                    
                    self.loginErrorBlock?(.LGECode_Request_CodeError, model.msg)
                    
                    return
                }
                
                self.step = 5
                self.doTask()
            case .netError:
                
                self.loginErrorBlock?(.LGECode_Request_Net, SW_NETErrorDescription)
            }
        }
    }
    //MARK:  Step   7发送授权码到中台
    func sendAuthCodeTask(withAuthCodeData:String)  {
        SWLGLog(withMsg: "Step   7发送授权码到中台")
        let service = MJHttpService.init()
        service.httpMethod = .post
        service.apiType = 1
        service.api  = SW_ZHT_API_getResult
        service.param = ["queueId":queryModel!.queueId, "openMode":"2","analysisType":"2","txdata":withAuthCodeData]
        SimpleHttp.default.httpTask(service) { response in
            
            switch response {
            case .succese(let string):
                
                guard let model  = SWjd<SWHttpResponseOrNil<String>>.deserializeFrom(json: string) else {
                    
                    self.loginErrorBlock?(.LGECode_Json_error, "数据解析异常")
                    
                    return
                    
                }
                
                guard model.code == 200 else {
                    
                    self.loginErrorBlock?(.LGECode_Request_CodeError, model.msg)
                    
                    return
                }
                
                self.step = 8
                self.doTask()
            case .netError:
                
                self.loginErrorBlock?(.LGECode_Request_Net, SW_NETErrorDescription)
            }
        }
    }
    
    //MARK:  Step 2 轮询查询 刷新token数据包接口
    func queueTask_queryRefreshTokenPackage() {
        SWLGLog(withMsg: "Step 2 轮询查询 刷新token数据包接口")
        currentQueryTask?.taskEnd()
        currentQueryTask = nil
        
        let service = MJHttpService.init()
        service.httpMethod = .post
        service.apiType = 1
        service.api  = SW_ZHT_API_QueryTxDataPackage
        service.param = ["queueId":queryModel!.queueId, "openMode":2,"txDataType":1]
        currentQueryTask =  DFQueueHttpTask<String>.init { result in
            
            if let info = result {
                
                //状态码异常 停止轮询
                if info.code != 200  {
                   
                   self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"状态码异常")
                   self.currentQueryTask?.taskEnd()
                    
                }else{

                    //获取到异步轮询的数据 停止轮询
                    if let data = info.data , data.isEmpty == false {
                        
                       let jsonStr =  DFAES.aes256DecryptECB(data, key: zhongtai_aesKey())
                       
                        if jsonStr == "null" {
                            //未获取到异步轮询的数据 继续 轮询
                            SWLGLog(withMsg: "未获取到异步轮询的数据 继续 轮询")
                        }else{
                           
                            self.currentQueryTask?.taskEnd()
                            
                            if let model = SWjd<SWZHTReqTxModel>.deserializeFrom(json: jsonStr) {
                                
                                SWLGLog(withMsg: "轮询刷新token接口返回结果:\(jsonStr)")
                                
                                if model.handleStatus == 30 {
                                    
                                    guard self.step != 3 else { return }
                                    self.step = 3
                                    self.doTask(withData: model.reqTxData)
                                }else{
                                    
                                    self.uploadResult(withModel: model)
                                }
                            }else{
                                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"数据解密失败")
                            }
                            
                            
                        }
                            
                        
                    }else{
                        
                        
                        self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"返回数据为空")
                        self.currentQueryTask?.taskEnd()
                    }
                }
                
            }else{
                //网络异常 数据解析异常 停止轮询
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                self.currentQueryTask?.taskEnd()
            }
        }
        currentQueryTask?.httpService = service
        currentQueryTask?.taskDo()
        
    }
    //MARK:  Step  5 轮询查询 查询游戏授权码数据包接口
    func queueTask_queryAuthCodePackage() {
        SWLGLog(withMsg: "Step  5 轮询查询 查询游戏授权码数据包接口")
        currentQueryTask?.taskEnd()
        currentQueryTask = nil
        
        
        let service = MJHttpService.init()
        service.httpMethod = .post
        service.apiType = 1
        service.api  = SW_ZHT_API_QueryTxDataPackage
        service.param = ["queueId":queryModel!.queueId, "openMode":2,"txDataType":2]
        currentQueryTask =  DFQueueHttpTask<String>.init { result in
            
            if let info = result {
                
                //状态码异常 停止轮询
                if info.code  != 200  {
                   
                   self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"状态码异常")
                   self.currentQueryTask?.taskEnd()
                    
                }else{

                    
                    if let data = info.data , data.isEmpty == false {
                        
                       let jsonStr =  DFAES.aes256DecryptECB(data, key: zhongtai_aesKey())
                       
                        if jsonStr == "null" {
                            //未获取到异步轮询的数据 继续 轮询
                            SWLGLog(withMsg: "未获取到异步轮询的数据 继续 轮询")
                        }else{
                           
                            self.currentQueryTask?.taskEnd()
                            
                            if let model = SWjd<SWZHTReqTxModel>.deserializeFrom(json: jsonStr) {
                                
                                SWLGLog(withMsg: "游戏授权码数据包接口返回数据:\(jsonStr)")
                                if model.handleStatus == 30 {
                                    
                                    guard self.step != 6 else { return }
                                    self.step = 6
                                    self.doTask(withData: model.reqTxData)
                                }
                                else if model.handleStatus == 460  {
                                    
                                    if self.redo_460 == false {
                                        SWLGLog(withMsg: "游戏授权码数据包接口 460 ")
                                        self.redo_460 = true
                                        
                                        guard self.step != 3 else { return }
                                        self.step = 3

                                        self.doTask(withData: model.reqTxData)
                                    }else{
                                        
                                        SWLGLog(withMsg: "游戏授权码数据包接口 460 重复")

                                        self.uploadResult(withModel: model)
                                    }
                                    
                                }
                                else{
                                    self.uploadResult(withModel: model)

                                }
                            }else{
                                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"数据解密失败")
                            }
                            
                            
                        }
                            
                        
                    }else{
                        
                        
                        self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"返回数据为空")
                        self.currentQueryTask?.taskEnd()
                    }
                }
            }else{
                //网络异常 数据解析异常 停止轮询
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                self.currentQueryTask?.taskEnd()
            }
        }
        currentQueryTask?.httpService = service
        currentQueryTask?.taskDo()
    }
    //MARK: Step   8 轮询查询 查询解密过的授权码
    func queueTask_queryResult() {
        SWLGLog(withMsg: "MARK: Step   8 轮询查询 查询解密过的授权码")
        currentQueryTask?.taskEnd()
        currentQueryTask = nil
        
        
        let service = MJHttpService.init()
        service.httpMethod = .post
        service.apiType = 1
        service.api  = SW_ZHT_API_getAuthCode
        service.param = ["queueId":queryModel!.queueId, "openMode":2]
        currentQueryTask =  DFQueueHttpTask<String>.init { result in
            
            
            if let info = result {
                
                //状态码异常 停止轮询
                if info.code  != 200  {
                   
                   self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"状态码异常")
                   self.currentQueryTask?.taskEnd()
                
                    
                }else{
 
                    
                    if let data = info.data , data.isEmpty == false {
                        
                       let jsonStr =  DFAES.aes256DecryptECB(data, key: zhongtai_aesKey())
                       
                        if jsonStr == "null" {
                            //未获取到异步轮询的数据 继续 轮询
                            SWLGLog(withMsg: "未获取到异步轮询的数据 继续 轮询")
                        }else{
                           
                            self.currentQueryTask?.taskEnd()
                            
                            if let model = SWjd<SWZHTReqTxModel>.deserializeFrom(json: jsonStr) {
                                
                                SWLGLog(withMsg: "查询解密过的授权码返回结果:\(jsonStr)")
                                guard self.step != 1 else { return }
                                self.step = 1
                                self.uploadResult(withModel: model)
                            }else{
                                self.loginErrorBlock?(LGECode.LGECode_Request_CodeError,"数据解密失败")
                            }
                            
                            
                        }
                            
                        
                    }else{
                        
                        
                        self.loginErrorBlock?(LGECode.LGECode_Request_DataNull,"返回数据为空")
                        self.currentQueryTask?.taskEnd()
                    }
                }
            }else{
                //网络异常 数据解析异常 停止轮询
                self.loginErrorBlock?(LGECode.LGECode_Request_Net,SW_NETErrorDescription)
                self.currentQueryTask?.taskEnd()
            }
        }
        currentQueryTask?.httpService = service
        currentQueryTask?.taskDo()
    }
    
    //MARK:  Step 3调用腾讯刷新token接口
    func tencentTask_refreshToken(withReqTxData:String)  {
        SWLGLog(withMsg: "Step 3调用腾讯刷新token接口")
        let reqTxData = withReqTxData
        
        do {
            
           let request = try URLRequest.urlRequest(fromBase64Str: reqTxData)
           SWLGLog(withMsg: "tx Request==>\(request.debugDescription)")
           let task =  URLSession.shared.dataTask(with: request) { (data, res , error ) in
                
               
               self.safeDo {
                   
                   guard  error == nil else {
                       
                       self.taskCancel()
                       SWLGError(withMsg: error.debugDescription)
                       self.loginErrorBlock?(.LGECode_TxRequest_Error, "Tx接口访问失败3")
                       return
                   }
                   
                   guard let _data = data else {
                       
                       self.taskCancel()
                       SWLGError(withMsg: "Tx接口data为空3")
                       self.loginErrorBlock?(.LGECode_TxRequest_Error, "Tx接口返回数据为空3")
                       return
                   }
                   
                   let base64Data = _data.base64EncodedString()
                   SWLGLog(withMsg: "TX刷新token接口返回数据--》\(base64Data)")
                   self.step = 4
                   
                   self.doTask(withData: base64Data)
                   
               }
               
           }
            
          task.resume()
            
            
        } catch  {
            
            taskCancel()
            let err = error as! SWLoginGameError
            loginErrorBlock?(err.code, err.message)
        }
        
    }
    
    //MARK: Step  6  调用腾讯获取游戏授权码接口
    func tencentTask_queryAuthCode(withReqTxData:String)  {
        SWLGLog(withMsg: "Step  6  调用腾讯获取游戏授权码接口")
        let reqTxData = withReqTxData
        
        do {
            
           let request = try URLRequest.urlRequest(fromBase64Str: reqTxData)
           
           let task =  URLSession.shared.dataTask(with: request) { (data, res , error ) in
                
               
               self.safeDo {
                   
                   guard  error == nil else {
                       
                       self.taskCancel()
                        SWLGError(withMsg: error.debugDescription)
                       self.loginErrorBlock?(.LGECode_TxRequest_Error, "Tx接口访问失败6")
                       return
                   }
                   
                   guard let _data = data else {
                       
                       self.taskCancel()
                       SWLGError(withMsg: "Tx接口data为空6")
                       self.loginErrorBlock?(.LGECode_TxRequest_Error, "Tx接口返回数据为空6")
                       return
                   }
                   
                   let base64Data = _data.base64EncodedString()
                   SWLGLog(withMsg: "TX游戏授权码接口返回数据--》\(base64Data)")
                   self.step = 7
                   
                   self.doTask(withData: base64Data)
                   
               }
               
           }
            
          task.resume()
            
            
        } catch  {
            
            taskCancel()
            let err = error as! SWLoginGameError
            loginErrorBlock?(err.code, err.message)
        }
    }
    
    /// 结果上报
    func uploadResult(withModel:SWZHTReqTxModel)  {
        
       
        
        sw_wx_login_report(withQueue_id: quickModel.queue_id, withOrder_id: info?.order_id, withUncode: info!.unlock_code, status: "\(withModel.handleStatus == 30 ? 1 :withModel.handleStatus)", remark: withModel.handleStatusMsg, quick_version: "7") { (status, message) in
            
            switch status {
                
            case -1,-2,1:
                //接口失败 或者是 状态码1  直接上号
                print("上号")
                guard withModel.authCode.isEmpty == false else {
                    self.loginErrorBlock?(.LGECode_Request_DataNull, "授权码为空")
                    return
                }
                let url = "\(self.wx_package_openScheme)oauth?code=\(withModel.authCode)&state=weixin"
                SWLGLog(withMsg: "打开游戏url=\(url)")
                self.openApp(withUrl: url) { (result) in
                    
                    if result {
                        
                        self.loginErrorBlock?(.LGECode_Success,nil)
                    }else{
                        self.loginErrorBlock?(.LGECode_OpenApp_Error,"您未安装游戏，请前往AppStore安装")
                    }
                    
                }
                
                
            case 2:
                self.retry()
                //撤单
            case 3:
                self.taskCancel()
                self.reloadBlock?(message)
            default:
                self.taskCancel()
                self.loginErrorBlock?(.LGECode_TxRequest_Error, message)
                
            }
           
        }
    }
    
    func safeDo(call:@escaping ()->())  {
        
        DispatchQueue.main.async {
            
            call()
        }
    }
}




