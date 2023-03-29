//
//  Constants.swift
//  StoryMaker
//
//  Created by Park on 2022/1/9.
//  Copyright © 2020 mayqiyue. All rights reserved.
//

import UIKit


@objcMembers public class PKGContext : NSObject{
    public static let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
    public static let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom
    
// "kNotificationStatusChanged"
    public static let kNotificationStatusChanged = String(bytes:[107,78,111,116,105,102,105,99,97,116,105,111,110,83,116,97,116,117,115,67,104,97,110,103,101,100], encoding: .utf8)!
// "https://www.zuhaowan.com"
    public static let kOrigin = String(bytes:[104,116,116,112,115,58,47,47,119,119,119,46,122,117,104,97,111,119,97,110,46,99,111,109], encoding: .utf8)!
// "http://h5.package.zuhaowan"
    public static let kPkgHost = String(bytes:[104,116,116,112,58,47,47,104,53,46,112,97,99,107,97,103,101,46,122,117,104,97,111,119,97,110], encoding: .utf8)!
// "h5.package.zuhaowan"
    public static let kPkgHostPart = String(bytes:[104,53,46,112,97,99,107,97,103,101,46,122,117,104,97,111,119,97,110], encoding: .utf8)!
// "WKBrowsingContextController"
    public static let kWKBCCClassName = String(bytes:[87,75,66,114,111,119,115,105,110,103,67,111,110,116,101,120,116,67,111,110,116,114,111,108,108,101,114], encoding: .utf8)!
// "registerSchemeForCustomProtocol:"
    public static let kRegisterProtocolSelectorName = String(bytes:[114,101,103,105,115,116,101,114,83,99,104,101,109,101,70,111,114,67,117,115,116,111,109,80,114,111,116,111,99,111,108,58], encoding: .utf8)!
    //"kNetworkAvaliableUpdateNotification"
    public static let kNetworkAvaliableUpdateNotification = String(bytes:[107,78,101,116,119,111,114,107,65,118,97,108,105,97,98,108,101,85,112,100,97,116,101,78,111,116,105,102,105,99,97,116,105,111,110], encoding: .utf8)!
}




var LolmDFConst_NetReferenceCount:Int = 0

// "wx47b5177c44092b6b"
//let LolmDF_WX_APPID = String(bytes:[119,120,52,55,98,53,49,55,55,99,52,52,48,57,50,98,54,98], encoding: .utf8)!
//// "0680f4692039502be39f0782715d12db"
//let LolmDF_WX_APPKEY = String(bytes:[48,54,56,48,102,52,54,57,50,48,51,57,53,48,50,98,101,51,57,102,48,55,56,50,55,49,53,100,49,50,100,98], encoding: .utf8)!
//
//// "102006271"
//let LolmDF_QQ_APPID = String(bytes:[49,48,50,48,48,54,50,55,49], encoding: .utf8)!
//// "yqcCZjfNtCH8lBMJ"
//let LolmDF_QQ_APPKEY = String(bytes:[121,113,99,67,90,106,102,78,116,67,72,56,108,66,77,74], encoding: .utf8)!


// "http://10.10.24.178:9502/"
let kPreviewReleaseServer = String(bytes:[104,116,116,112,58,47,47,49,48,46,49,48,46,50,52,46,49,55,56,58,57,53,48,50,47], encoding: .utf8)!
// "https://zhwapp.zuhaowan.com/"
let kReleaseServer = String(bytes:[104,116,116,112,115,58,47,47,122,104,119,97,112,112,46,122,117,104,97,111,119,97,110,46,99,111,109,47], encoding: .utf8)!

// ""
// "Login/qqLoginNew"
//let LolDF_QQLogin = String(bytes:[76,111,103,105,110,47,113,113,76,111,103,105,110,78,101,119], encoding: .utf8)!
//// "Login/wxLoginV2"
//let LolDF_WECHATLogin = String(bytes:[76,111,103,105,110,47,119,120,76,111,103,105,110,86,50], encoding: .utf8)!
//// "Information/getIosVersion"
let kGetAppInfo = String(bytes:[73,110,102,111,114,109,97,116,105,111,110,47,103,101,116,73,111,115,86,101,114,115,105,111,110], encoding: .utf8)!




