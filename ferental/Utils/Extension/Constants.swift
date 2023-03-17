//
//  Constants.swift
//  StoryMaker
//
//  Created by Park on 2022/1/9.
//  Copyright © 2020 mayqiyue. All rights reserved.
//

import UIKit
import HandyJSON

//appId 生产 com.fundo.ferental

@objcMembers class Global: NSObject{
// "500180009"
    static let kAppId = String(bytes:[53,48,48,49,56,48,48,48,57], encoding: .utf8)!
    static let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
    static let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom
    static var isTest = true //是否是测试. 这个会影响到上号Lib的接口.
// "long_verison_key"
    static let df_version = Bundle.main.infoDictionary![String(bytes:[108,111,110,103,95,118,101,114,105,115,111,110,95,107,101,121], encoding: .utf8)!] as! String
    static var notificationAvaliable = false
// "kNotificationStatusChanged"
    static let kNotificationStatusChanged = String(bytes:[107,78,111,116,105,102,105,99,97,116,105,111,110,83,116,97,116,117,115,67,104,97,110,103,101,100], encoding: .utf8)!
// "https://www.zuhaowan.com"
    static let kOrigin = String(bytes:[104,116,116,112,115,58,47,47,119,119,119,46,122,117,104,97,111,119,97,110,46,99,111,109], encoding: .utf8)!
// "http://h5.package.zuhaowan"
    static let kPkgHost = String(bytes:[104,116,116,112,58,47,47,104,53,46,112,97,99,107,97,103,101,46,122,117,104,97,111,119,97,110], encoding: .utf8)!
// "h5.package.zuhaowan"
    static let kPkgHostPart = String(bytes:[104,53,46,112,97,99,107,97,103,101,46,122,117,104,97,111,119,97,110], encoding: .utf8)!
// "WKBrowsingContextController"
    static let kWKBCCClassName = String(bytes:[87,75,66,114,111,119,115,105,110,103,67,111,110,116,101,120,116,67,111,110,116,114,111,108,108,101,114], encoding: .utf8)!
// "registerSchemeForCustomProtocol:"
    static let kRegisterProtocolSelectorName = String(bytes:[114,101,103,105,115,116,101,114,83,99,104,101,109,101,70,111,114,67,117,115,116,111,109,80,114,111,116,111,99,111,108,58], encoding: .utf8)!
}


// "CFBundleName"
let kBundleName = Bundle.main.infoDictionary![String(bytes:[67,70,66,117,110,100,108,101,78,97,109,101], encoding: .utf8)!] as! String
let kCachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let kTempPath = NSTemporaryDirectory()
// "CFBundleExecutable"
let kNameSpage = Bundle.main.infoDictionary![String(bytes:[67,70,66,117,110,100,108,101,69,120,101,99,117,116,97,98,108,101], encoding: .utf8)!] as! String
// "CFBundleShortVersionString"
let kAppVersion = Bundle.main.infoDictionary![String(bytes:[67,70,66,117,110,100,108,101,83,104,111,114,116,86,101,114,115,105,111,110,83,116,114,105,110,103], encoding: .utf8)!] as! String
// "CFBundleVersion"
let kBuildNumber = Bundle.main.infoDictionary![String(bytes:[67,70,66,117,110,100,108,101,86,101,114,115,105,111,110], encoding: .utf8)!] as! String


// "http://app.cywj.info/api"
let kDebugServer = String(bytes:[104,116,116,112,58,47,47,97,112,112,46,99,121,119,106,46,105,110,102,111,47,97,112,105], encoding: .utf8)!
var kServerHost: String {
    return kDebugServer
}

// "kUserChanged"
let kUserChanged = Notification(name: Notification.Name(String(bytes:[107,85,115,101,114,67,104,97,110,103,101,100], encoding: .utf8)!), object: nil)

// "kUserMakeOrder"
let kUserMakeOrder = Notification(name: Notification.Name(String(bytes:[107,85,115,101,114,77,97,107,101,79,114,100,101,114], encoding: .utf8)!), object: nil)
//用户重新联网
// "kUserReConnectedNetwork"
let kUserReConnectedNetwork = Notification(name: Notification.Name(String(bytes:[107,85,115,101,114,82,101,67,111,110,110,101,99,116,101,100,78,101,116,119,111,114,107], encoding: .utf8)!), object: nil)


// "https://static.zuhaowan.com/client/download/fe-hot-update-elec/h5app-500180009/debug/last.json"
let kDebugVersionRequestURL =  String(bytes:[104,116,116,112,115,58,47,47,115,116,97,116,105,99,46,122,117,104,97,111,119,97,110,46,99,111,109,47,99,108,105,101,110,116,47,100,111,119,110,108,111,97,100,47,102,101,45,104,111,116,45,117,112,100,97,116,101,45,101,108,101,99,47,104,53,97,112,112,45,53,48,48,49,56,48,48,48,57,47,100,101,98,117,103,47,108,97,115,116,46,106,115,111,110], encoding: .utf8)!

// "https://static.zuhaowan.com/client/download/fe-hot-update-elec/h5app-500180009/release/last.json"
let kReleaseVersionRequestURL =  String(bytes:[104,116,116,112,115,58,47,47,115,116,97,116,105,99,46,122,117,104,97,111,119,97,110,46,99,111,109,47,99,108,105,101,110,116,47,100,111,119,110,108,111,97,100,47,102,101,45,104,111,116,45,117,112,100,97,116,101,45,101,108,101,99,47,104,53,97,112,112,45,53,48,48,49,56,48,48,48,57,47,114,101,108,101,97,115,101,47,108,97,115,116,46,106,115,111,110], encoding: .utf8)!


var LolmDFConst_NetReferenceCount:Int = 0
// "eb9a910f5019499786c3cd6011a94dcf"
let LolmDF_FACE_BusnissId = String(bytes:[101,98,57,97,57,49,48,102,53,48,49,57,52,57,57,55,56,54,99,51,99,100,54,48,49,49,97,57,52,100,99,102], encoding: .utf8)!

let USER_DEFAULTS = UserDefaults.standard
let DELEGATE = UIApplication.shared.delegate!



// "wx47b5177c44092b6b"
let LolmDF_WX_APPID = String(bytes:[119,120,52,55,98,53,49,55,55,99,52,52,48,57,50,98,54,98], encoding: .utf8)!
// "0680f4692039502be39f0782715d12db"
let LolmDF_WX_APPKEY = String(bytes:[48,54,56,48,102,52,54,57,50,48,51,57,53,48,50,98,101,51,57,102,48,55,56,50,55,49,53,100,49,50,100,98], encoding: .utf8)!

// "102006271"
let LolmDF_QQ_APPID = String(bytes:[49,48,50,48,48,54,50,55,49], encoding: .utf8)!
// "yqcCZjfNtCH8lBMJ"
let LolmDF_QQ_APPKEY = String(bytes:[121,113,99,67,90,106,102,78,116,67,72,56,108,66,77,74], encoding: .utf8)!

//app 签名key 500180001  IhDmA58CMvRwqT3g 500180002  N4Uz3QglHrSeu5Ct  500180003  AiHgdNYBtQMaIz7k  500180004  7NkHrLBKRaU5vn2I  500100000  m*hTXWMD^^hS&H6x
//500180009 x8ecLyhIl4BT7tCD
// "x8ecLyhIl4BT7tCD"
let DFHttpSignKey = String(bytes:[120,56,101,99,76,121,104,73,108,52,66,84,55,116,67,68], encoding: .utf8)!
// "N9Mw0vPIXZP5@hba"
let DFWebSocketSignKey = String(bytes:[78,57,77,119,48,118,80,73,88,90,80,53,64,104,98,97], encoding: .utf8)!

// "http://10.10.24.178:9502/"
let kPreviewReleaseServer = String(bytes:[104,116,116,112,58,47,47,49,48,46,49,48,46,50,52,46,49,55,56,58,57,53,48,50,47], encoding: .utf8)!
// "https://zhwapp.zuhaowan.com/"
let kReleaseServer = String(bytes:[104,116,116,112,115,58,47,47,122,104,119,97,112,112,46,122,117,104,97,111,119,97,110,46,99,111,109,47], encoding: .utf8)!
// "0acbd33bc6e17e7dd664e690"
let kJushAppKey = String(bytes:[48,97,99,98,100,51,51,98,99,54,101,49,55,101,55,100,100,54,54,52,101,54,57,48], encoding: .utf8)!


// ""
let SW_KHOST = String(bytes:[], encoding: .utf8)!
// "Login/qqLoginNew"
let LolDF_QQLogin = String(bytes:[76,111,103,105,110,47,113,113,76,111,103,105,110,78,101,119], encoding: .utf8)!
// "Login/wxLoginV2"
let LolDF_WECHATLogin = String(bytes:[76,111,103,105,110,47,119,120,76,111,103,105,110,86,50], encoding: .utf8)!
// "Information/getIosVersion"
let kGetAppInfo = String(bytes:[73,110,102,111,114,109,97,116,105,111,110,47,103,101,116,73,111,115,86,101,114,115,105,111,110], encoding: .utf8)!



