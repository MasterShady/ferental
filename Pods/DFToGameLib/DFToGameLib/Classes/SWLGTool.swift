//
//  SWLoginGameEnter.swift
//  DoFunNew
//
//  Created by mac on 2021/6/1.
//

import Foundation


@objc public  protocol SWLoginGameLoadingViewProtocol:NSObjectProtocol{

    @objc   func play()
    
    @objc  func suspend()
    
    @objc  func hidden()
    
    @objc  func show()
}


public  protocol SWLoginGameToolProtocol:AnyObject {
    
    func toolFinished()

    func toolTaskError(withError:SWLoginGameError)

    func orderNeedReload(withMsg:String?)
    
    func getLoadingView() -> (SWLoginGameLoadingViewProtocol?)
    
    func HMCloudGamePresentViewController() -> UIViewController
    
    func getHMCloudGamePageLoadingView() -> (SWLoginGameLoadingViewProtocol?)
    
    func HMCloudGameClose()
        
    
    
}




public struct SWActInfo {
    
    public var yx:String = ""
    
    public var id:String = ""
    
    public var is_wx_server:Bool = false
    
    public var wx_type:Int = 0 // 0 老版本模拟器 1 新版本ipad
    
    public var game_package_name_ios:String = "" //包名
    
    public var game_package_name_ios_wx:String = "" 
    
    public var unlock_code:String  = "" // qq上号解锁码
    
    public var game_id:String = ""
    
    public var is_cloudGame:Bool = false
    
    public var order_id:String?
    
    public init() {
        
    }
}


public enum LGECode:Int  {
    
    case LGECode_Success = 0
    
    case LGECode_Request_Net = 10001 //网络出错
    
    case LGECode_Json_error = 10002 //json 解析出错
    
    case LGECode_Request_CodeError = 10003 //接口返回错误状态码
    
    case LGECode_Request_DataNull = 10004 //接口返回数据为空
    
    case LGECode_Param_Error = 20001 //缺少关键参数信息
    
    case LGECode_Type_Error = 30001 //数据类型错误
    
    case LGECode_Crypt_Error = 40001 //加解密出错
    
    case LGECode_OpenApp_Error = 50001 //打开app出错
    
    case LGECode_FaceVerify_Error = 600001 //人脸错误
    
    case LGECode_84_Error = 700001 //人脸错误
    
    case LGECode_protocol_Error = 800001 //人脸错误
    
    case LGECode_Fail_Error = 900001 //无更多上好方式
    
    case LGECode_HMCloud_Error = 1000001 //人脸错误
    
    case LGECode_TxRequest_Error = 1100001 //微信ipad协议上号错误 
    
}

public struct SWLoginGameError:Error {
    
    // 1 微信 2 qq  0 channel无关
    public  var channel:Int
    
    // 错误码
    public  var code:LGECode
    
    public  var message:String?
    
    public  func debugDescription() ->String {
        
        return "channel-\(channel)|code-\(code.rawValue)|message-\(message ?? "nil")"
    }
    
    public  func description() ->String {
        
        
        let channel = self.channel == 1 ? "微信" :(self.channel == 2 ? "QQ" : "错误")
        
        var result = ""
        
        result += channel
        
        return result
        
        
    }
}

enum SWAPPChannel {
    case dfapp
    case shanghaoqi
}

class SWOtherInfoWrap {
    
    static  var shared:SWOtherInfoWrap = .init()
    
    var token:String!
    
    var uuid:String!
    
    var appversion:String?
    
    var channel:SWAPPChannel = .dfapp
    
    var appId:String = "500100000"
    
    var httpSignStr:String = "m*hTXWMD^^hS&H6x"
    
    var websocketSignStr:String = "N9Mw0vPIXZP5@hba"
    
    var zhongtai_credential:String = "" //中台凭证
    
    var zhongtai_bid:String = ""
    
    var logoption:SWLGLogOption = .all //控制台输出日志级别
    
    var hmcloudLouadingView:SWLoginGameLoadingViewProtocol?
    
    var shumei_id:String?
    
}

public class SWLoginGameTool {
    
    
    /// 平台标识  判断租赁账号是否是iOS
    var OSTag:String {
        
        get {
            return "ios"
        }
    }
    
    
    
    /// 初始化方法
    /// - Parameters:
    ///   - isShanghaoqi: 是否是上号器
    ///   - withToken: token
    ///   - withUUID: 设备id
    ///   - withApiType: 接口api环境
    ///   - appversion: app版本号
    ///   - appsign: app签名sign
    ///   - appId: appid
    ///   - shumeiId: 数美sdk id
    public convenience init(isShanghaoqi:Bool,withToken:String,withUUID:String, withApiType:Int = 3,appversion:String,appsign:String? = nil,appId:String? = nil,websocketSign:String? = nil,shumeiId:String?) {
        
        if isShanghaoqi {
            
            self.init(withUnlockCode: withToken, withUUID: withUUID, withApiType: withApiType)
        }else{
            
            self.init(withToken: withToken, withUUID: withUUID, withApiType: withApiType)
        }
        
        SWOtherInfoWrap.shared.shumei_id = shumeiId
        
        SWOtherInfoWrap.shared.appversion = appversion
        if let _appid = appId {
            
            SWOtherInfoWrap.shared.appId = _appid
        }else{
            
            if isShanghaoqi {
                
                SWOtherInfoWrap.shared.appId = "500100500"
            }else{
                
                SWOtherInfoWrap.shared.appId = "500100000"
            }
            
        }
        
        if let _appsign = appsign {
            
            SWOtherInfoWrap.shared.httpSignStr = _appsign
        }
        
        if let _websocketSign = websocketSign {
            
            SWOtherInfoWrap.shared.websocketSignStr = _websocketSign
        }
        
        
        #if DEBUG
        SWOtherInfoWrap.shared.logoption = .all
        #else
        
        SWOtherInfoWrap.shared.logoption = .none
        #endif
    }
    
    
    public init(withToken:String,withUUID:String, withApiType:Int = 3) {
        
        SWOtherInfoWrap.shared.token = withToken
        SWOtherInfoWrap.shared.uuid  = withUUID
        
        switch withApiType {
            
        case 1,0:
            
            SimpleHttp.default.api_env = .test
        case 2 :
            SimpleHttp.default.api_env = .pre_release
            
        default:
            SimpleHttp.default.api_env = .release
        }
        
        
        
    }
    
    //兼容上号器上号代码
    public init(withUnlockCode:String,withUUID:String, withApiType:Int = 3) {
        
        SWOtherInfoWrap.shared.token = withUnlockCode
        SWOtherInfoWrap.shared.channel = .shanghaoqi
        SWOtherInfoWrap.shared.uuid  = withUUID
        
        switch withApiType {
            
        case 1,0:
            
            SimpleHttp.default.api_env = .test
        case 2 :
            SimpleHttp.default.api_env = .pre_release
            
        default:
            SimpleHttp.default.api_env = .release
        }
        
    }
    
    
    public var actInfo:SWActInfo?
    
    public  weak var delegate:SWLoginGameToolProtocol?
    
    public  var currentPlatform:SWLoginGamePlatformProtocol?
    
    public  func cancel()  {
        
        currentPlatform?.taskCancel()
        
        currentPlatform = nil
    }
    
     
    /// 开始上号流程
    public  func doTask(){
        
        guard let info = actInfo else {
            
            
            return
        }
        
        if info.is_cloudGame {
            
            cloud(withInfo: info)
            
            return
        }
        
        
        if info.yx != OSTag {
            
            self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Param_Error, message: "账号非iOS平台"))
            return
        }
        
        if SWOtherInfoWrap.shared.channel == .shanghaoqi {
            
            if info.is_wx_server {
                //启动微信登录流程
                self.wx(withInfo: info)
            }else{
                //启动QQ登录流程
                self.qq(withinfo: info)
            }
            
        }else{
            
            sw_loginGame_checkDeviceUid(lockcode: info.unlock_code,loadOfview: nil) { (result,msg) in
                
                guard result == true else {
                    
                    self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Request_CodeError, message: msg))
                    return
                }
                
                if info.is_wx_server {
                    //启动微信登录流程
                    self.wx(withInfo: info)
                }else{
                    //启动QQ登录流程
                    self.qq(withinfo: info)
                }
            }
            
        }
        

    }
    
    
   
    
    
    var qq:SWQQLogin?
    
    var wechat:SWWechatLoginBase?
    
    var hmcloud:SWHMCloudGame?
    
    
}


extension SWLoginGameTool:SWHMCloudGameLoginProtocol {
    func SWHMCloudGameLoginSuccess() {
        
        
        
        DispatchQueue.main.async {
           
            //隐藏loading
            if   let hmloading = SWOtherInfoWrap.shared.hmcloudLouadingView {
                
                hmloading.hidden()
            }
            self.delegate?.toolFinished()
        }
    }
    
    func SWHMCloudGameOrderEnd() {
         
        DispatchQueue.main.async {
            
            self.delegate?.orderNeedReload(withMsg: "订单已经结束")
        }
    }
    
    func SWHMCloudGamePageDidPresent(with: UIViewController) {
        
        DispatchQueue.main.async {
            
            //显示loading
            if let hmloading = SWOtherInfoWrap.shared.hmcloudLouadingView  as? UIView{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    
                    hmloading.frame = with.view.bounds
                    
                    with.view.addSubview(hmloading)
                }
            }
        }
       
    }
    
    func SWHMCloudGameCloseDidGame() {
         
        DispatchQueue.main.async {
            
            self.delegate?.HMCloudGameClose()
        }
         
    }
    func SWHMCloudGameOrderAutoTs(){
        
        DispatchQueue.main.async {
            self.delegate?.orderNeedReload(withMsg: "云游戏登录异常，已自动撤单")
        }
        
    }
    
    func cloud(withInfo:SWActInfo)  {
         
        hmcloud = SWHMCloudGame.init()
        currentPlatform = hmcloud
        hmcloud?.currentViewController = self.delegate?.HMCloudGamePresentViewController()
        hmcloud?.delegate = self
        hmcloud?.loadingView = self.delegate?.getLoadingView()
        SWOtherInfoWrap.shared.hmcloudLouadingView = self.delegate?.getHMCloudGamePageLoadingView()
        hmcloud?.login(withInfo: withInfo)
        
        
    }
    
    func SWHMCloudGameLoginTaskError(with: SWHMCloudGameError) {
        
        DispatchQueue.main.async {
            
            self.hmcloud?.loadingView?.hidden()
           
            self.delegate?.toolTaskError(withError: .init(channel: 3, code: .LGECode_HMCloud_Error, message: "hmErrorCode:\(with.code),message:\(with.message)"))
        }
        
    }
    
   
}


extension SWLoginGameTool {
    
    /// 微信登录
    func wx(withInfo:SWActInfo)  {
        
        
        let doBlock:()->() = {[unowned self] () in
            
            currentPlatform = wechat
           
            wechat?.loadingView = self.delegate?.getLoadingView()
            
            wechat?.loginErrorBlock = {[unowned self] (ecode,msg) in
               self.wechat?.loadingView?.hidden()
               if ecode == .LGECode_Success {

                   self.delegate?.toolFinished()
               }else{

                   self.delegate?.toolTaskError(withError: .init(channel: 2, code: ecode, message: msg))
               }
            }
            
            wechat?.reloadBlock = { [unowned self] (message ) in
                self.wechat?.loadingView?.hidden()
                self.delegate?.orderNeedReload(withMsg: message ?? "已撤单")
            }
            
            wechat?.loadingView?.show()
            
            wechat?.login(withInfo: withInfo)
        }
        
         
         //根据接口下发是老版本模拟器还是新版本ipad协议 0 模拟器 1 ipad
        
         if withInfo.wx_type == 0 {
           
            wechat = SWWechatLoginBase.wechatLogin(with: nil)
            doBlock()
         }
        else{
            
            sw_logingame_qq_getOrderInfo(withUnlockCode: withInfo.unlock_code) { (code,model ) in
                
                
                if code == -2 {
                    self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Request_Net, message: SW_NETErrorDescription))
                    
                    SWLGError(withMsg: "数据返回异常code==-2")
                    return
                }
                
                if code == -1 {
                    
                    SWLGError(withMsg: "数据返回异常code==-1")
                   
                    self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Json_error, message: "数据异常"))
                    return
                }
     
                guard let response = model?.quick_info  else {
                    
                    self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Request_DataNull, message: "微信上号返回数据错误"))
                    
                    return //接口错误
                }
                
                guard response.credential.isEmpty == false  else {
                    
                    self.delegate?.toolTaskError(withError: .init(channel: 0, code: .LGECode_Request_DataNull, message: "微信上号凭证为空"))
                    
                    return //接口错误
                }
                SWOtherInfoWrap.shared.zhongtai_credential = response.credential
                SWOtherInfoWrap.shared.zhongtai_bid = response.biz_id
                self.wechat = SWWechatLoginBase.wechatLogin(with: response)
                doBlock()
            }
        }
         
        
        
         
    }
}



extension SWLoginGameTool {
    
    /// qq登录
    func qq(withinfo:SWActInfo)  {
        
        qq =  SWQQLogin()
        
        currentPlatform = qq
        
        qq?.loadingView = self.delegate?.getLoadingView()
        
        qq?.login(withInfo: withinfo)
        
        qq?.loginErrorBlock = {[unowned self] (ecode,msg) in
           
            if ecode == .LGECode_Success {
                
                self.delegate?.toolFinished()
            }else{
                
                self.delegate?.toolTaskError(withError: .init(channel: 1, code: ecode, message: msg))
            }
        }
        
        qq?.reloadBlock = { [unowned self]() in
            
            self.delegate?.orderNeedReload(withMsg: nil)
        }
        
        
    }
}





