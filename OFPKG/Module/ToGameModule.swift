//
//  ToGameModule.swift
//  OfflinePackage
//
//  Created by 刘思源 on 2023/2/20.
//

import UIKit
import DFToGameLib
import MBProgressHUD
import DFFaceVerifyLib
import ShareSDK
import ShareSDKUI
import Photos
import AEAlertView

@objcMembers class ToGameModule: NSObject, KKJSBridgeModule{
    var viewController: UIViewController?
    var lolmp_loginGameTool:SWLoginGameTool!
    var context: OfflinePackageController!
    var engine: KKJSBridgeEngine?
    var actInfo: SWActInfo!
    
    
    var loginResultHandler: ((NSDictionary)->())!
    var orderRefreshCallback: ((String)->())!
    
    
    lazy var loadingView:lolm_shanghao_loading_dfview = {
        let lv = lolm_shanghao_loading_dfview.lolmp_loadingView()
        lv.targetView = self.context.view
        lv.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        lv.closeBlock = {[unowned lv,unowned self] () in
            lv.hidden()
            self.lolmp_loginGameTool.cancel()
        }
        return lv
    }()
    
    static func isSingleton() -> Bool {
        return true
    }
    
    required init(engine: KKJSBridgeEngine, context: Any) {
        self.context = context as? OfflinePackageController
        self.engine = engine
        super.init()
        DispatchQueue.main.async {
            self.viewController = self.context.navigationController
        }
    }
    
    
    static func moduleName() -> String {
        return "ToGameModule"
    }
    
    
    
    @objc func AutoLoadGame(_ engine: KKJSBridgeEngine, params: NSDictionary, responseCallback:@escaping (String) -> ()){
        orderRefreshCallback = responseCallback
        
        let token: String = params["token"] as! String
        
//        var apiType = 3 // for release
//        if Global.isTest == true{
//            apiType = 1
//        }else{
//            apiType = 3
//        }
        
        lolmp_loginGameTool = SWLoginGameTool(isShanghaoqi:false,withToken: token, withUUID: LolmDF_uuid(),withApiType: LolmDFHttpConfig.shared.env.rawValue(),appversion: Global.df_version,appsign:DFHttpSignKey,appId: Global.kAppId,websocketSign: DFWebSocketSignKey)
        lolmp_loginGameTool.delegate = self
        
        
        let yx = params["yx"] as! String
        let id = params["Id"] as! String
        let is_wx_server = params["is_wx_server"] as! Bool
        let game_package_name_ios = params["game_package_name_ios"] as! String
        let uncode = params["uncode"] as! String
        let game_id = params["game_id"] as! String
        let is_cloudGame = (params["is_cloudGame"] as! Int) == 1 ? true : false
        
        let wxServerLoadingMsgs = params["wxServerLoadingMsgs"] as? [String]
        
        
        
        actInfo = .init()
        actInfo.wx_type = is_wx_server ? 1 : 0
        actInfo.order_id = id
        actInfo.yx = yx
        actInfo.id = id
        actInfo.is_wx_server = is_wx_server
        actInfo.game_package_name_ios = game_package_name_ios
        actInfo.unlock_code = uncode
        actInfo.game_id = game_id
        actInfo.is_cloudGame = is_cloudGame
        lolmp_loginGameTool.actInfo = actInfo
        
        if is_cloudGame {
            loadingView.lolmp_show_text = "云游戏准备中,请稍后"
            appdelegate.orientation = .all
        }
        else{
            if is_wx_server {
                loadingView.lolmp_msgArray = wxServerLoadingMsgs ?? []
            }else {
                loadingView.lolmp_show_text = "启动游戏..."
            }
        }
        lolmp_loginGameTool.doTask()
    }
    
    
    @objc func share(_ engine: KKJSBridgeEngine, params: NSDictionary, responseCallback:@escaping (NSDictionary) -> ()){
        let url = params["url"] as? String ?? ""
        
        let showPoster = params["showPoster"] as? Bool ?? true
        
//        var shareModel = DFFreePlayShareModel.deserialize(from: params)!
        let shareView = lolm_actDetail_share_alert_view(showPoster: showPoster)
        shareView.itemBtnClickedBlock = { tag in
            if tag == 0 { // 复制链接
                let board =  UIPasteboard.general
                board.string = url
                AutoProgressHUD.showAutoHud("链接已复制到剪切板")
            }else if tag == 1 {
                responseCallback(.init())
            }
            
        }
        UIApplication.shared.currentWindow()!.addSubview(shareView)
        shareView.show()
    }
    
    func shareImage(_ engine: KKJSBridgeEngine, params: NSDictionary, responseCallback:@escaping (NSDictionary) -> ()){
        let shareView = DFScreenShortSharedWidget()
        guard let base64String = params["image"] as? String else {
            return
        }
        
//        NSURL *baseImageUrl = [NSURL URLWithString:base64ImageStr];
//        NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
        
        let imageUrl = URL(string: base64String)!
        let data = try! Data(contentsOf: imageUrl)
        
        //let data = Data(base64Encoded:base64String,options: [.ignoreUnknownCharacters]);
        
        shareView.imageData = data
        UIApplication.shared.currentWindow()!.addSubview(shareView)
        shareView.show()
        shareView.itemBtnClickedBlock = { tag,image in
            
//            //0微信好友 1朋友圈 2QQ
//            if tag == 0 || tag == 1 || tag == 2 {//微信好友
//                DFPlatformShareUtil.free_shareImageTask(image: image, platform: tag)
//            }
//            else
            if tag == 0 {//保存到相册
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized || status == .notDetermined{
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                        }, completionHandler: { (isSuccess, error) in
                            DispatchQueue.main.async {
                                if isSuccess {// 成功
                                    AutoProgressHUD.showAutoHud( "保存成功")
                                }
                            }
                        }
                        )
                    }else{
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title:"未获得权限访问您的照片", message:"请在设置选项中允许访问您的照片", preferredStyle: .alert)
                            let confirm = UIAlertAction(title:"去设置", style: .default) { (_)in
                                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                            let cancel = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                            alert.addAction(cancel)
                            alert.addAction(confirm)
                            UIViewController.getCurrent()!.present(alert, animated:true, completion:nil)
                        }
                    }
                }
            }
            
        }
    }
    
    
    func thirdLogin(_ engine: KKJSBridgeEngine, params: NSDictionary, responseCallback:@escaping (NSDictionary) -> ()){
        self.loginResultHandler = responseCallback
        let type = params["type"] as! String
        if type == "wechat"{
            let seq =  SendAuthReq.init()
            seq.state = "wx_oauth_authorization_state"
            seq.scope = "snsapi_userinfo"
            WXApi.send(seq) { result in
                
            }
        }else if type == "qq"{
            ShareSDK.authorize(.typeQQ, settings: nil) {  state, user, error in
                guard error == nil else {
                    self.loginResultHandler([
                        "error":error!.localizedDescription
                    ])
                    return
                }
                
                switch state {
                case .success:
                    
                    guard let userData = user else {
                        self.loginResultHandler([
                            "error":"数据为空"
                        ])
                        return
                    }
                    
                    
                    
                    if let openid = userData.credential.rawData.getValue(key: "openid", t: String.self),let accessToken = userData.credential.rawData.getValue(key: "access_token", t: String.self)  {
                        var params:[String:Any] = [:]
                        params["device_type"] = "4"
                        params["access_token"] = accessToken
                        params["openid"] = openid
                        params["ios_version"] =  Global.df_version
                        LolmDFHttpUtil.lolm_dohttpTask(url: SW_KHOST + LolDF_QQLogin, method: .post, parameters: params, showLoading: true, view: UIViewController.getCurrent().view) {json in
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as? [String: Any] {
                                    self.loginResultHandler([
                                        "user":jsonDict
                                    ])
                                }
                            } catch {
                                self.loginResultHandler([
                                    "error":error.localizedDescription
                                ])
                            }
                        } failBlock: { error in
                            self.loginResultHandler([
                                "error":error
                            ])
                        }
                        
                    }
                    
                    
                case .cancel,.platformCancel:
                    self.loginResultHandler([
                        "error":"取消登录"
                    ])
                case .fail:
                    self.loginResultHandler([
                        "error":"失败"
                    ])
                    
                default :
                    
                    break
                }
            }
        }
        
    }
    
}


extension ToGameModule:SWLoginGameToolProtocol{
    func HMCloudGameClose() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            AppDelegate.shareDelegate.orientation = .portrait
            UIDevice.switchNewOrientation(UIInterfaceOrientation.portrait)
            
        }
    }
    
    func toolFinished() {
        MBProgressHUD.hide(for: self.context.view, animated: true)
        if !actInfo.is_cloudGame {
           //游戏登录成功返回
           // context.webView.goBack()
        }

    }
    
    func toolTaskError(withError: SWLoginGameError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let msg = withError.message else { return }
            if msg.count > 0 {
                MBProgressHUD.show(text: msg)
            }
            
            //接口逻辑错误 直接cancel
            if withError.code == .LGECode_Request_CodeError || withError.code == .LGECode_Fail_Error || withError.code == .LGECode_Request_DataNull {
                self.lolmp_loginGameTool.cancel()
                self.loadingView.hidden()
            }
            AppDelegate.shareDelegate.orientation = .portrait
            UIDevice.switchNewOrientation(.portrait)
        }
        
    }
    
    func orderNeedReload(withMsg: String?) {
        MBProgressHUD.hide(for: self.context.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AppDelegate.shareDelegate.orientation = .portrait
            UIDevice.switchNewOrientation(.portrait)
            self.orderRefreshCallback?(withMsg ?? "")
        }
    }
    
    func getLoadingView() -> SWLoginGameLoadingViewProtocol? {
        return loadingView
        
    }
    
    func HMCloudGamePresentViewController() -> UIViewController {
        
        return self.context.navigationController ?? self.context
    }
    
    func getHMCloudGamePageLoadingView() -> (SWLoginGameLoadingViewProtocol?) {
        
        let view = Loldf_hmCloud_loadingView.loadingView()
        
        return view
        
    }
}



@objcMembers class FaceVerifyModule: NSObject, KKJSBridgeModule, DFFaceVerifyProtocol{
    static func moduleName() -> String {
        "FaceVerifyModule"
    }
    var viewController: UIViewController?
    var context: Any
    var engine: KKJSBridgeEngine
    var faceVerifySucceededHandler: ((String)->())?
    
    static func isSingleton() -> Bool {
        return true
    }
    
    required init(engine: KKJSBridgeEngine, context: Any) {
        self.context = context
        self.viewController = self.context as? UIViewController
        self.engine = engine
        super.init()
    }
    
    @objc func faceVerify(_ engine: KKJSBridgeEngine, params: NSDictionary, responseCallback:@escaping (String) -> ()){
        let item = DFFaceVerifyItem()
        item.purpose = params["purpose"] as! Int
        item.rname = params["rname"] as! String
        item.verify_id = params["verify_id"] as! String
        faceVerifySucceededHandler = responseCallback
        DFFaceVerifyManager.share().verifyTask(with: item, withTarget: self)
    }
    
    func dfFaceVerifySuccess(withMsg content: Any) {
        if let msg = content as? String{
            faceVerifySucceededHandler?(msg)
        }
    }
}



extension ToGameModule:WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        if let auth = resp as? SendAuthResp {
            if auth.state == "wx_oauth_authorization_state" {
                var param:[String:Any] = [:]
                param["device_type"] = "4"
                param["wx_code"] = auth.code!
                LolmDFHttpUtil.lolm_dohttpTask(url: SW_KHOST + LolDF_WECHATLogin, method: .get, parameters: param, showLoading: true, view: UIViewController.getCurrent().view) { json in
                    do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as? [String: Any] {
                            self.loginResultHandler([
                                "user":jsonDict
                            ])
                        }
                    } catch {
                        self.loginResultHandler([
                            "error":error.localizedDescription
                        ])
                    }
                } failBlock: { error in
                    self.loginResultHandler([
                        "error":error
                    ])
                    
                }
            }
        }
    }
}


 
