//
//  LolmDFConst.swift
//  lolmTool
//
//  Created by mac on 2022/2/28.
//

import UIKit
import HandyJSON

var LolmDFConst_NetReferenceCount:Int = 0
// "eb9a910f5019499786c3cd6011a94dcf"
let LolmDF_FACE_BusnissId = String(bytes:[101,98,57,97,57,49,48,102,53,48,49,57,52,57,57,55,56,54,99,51,99,100,54,48,49,49,97,57,52,100,99,102], encoding: .utf8)!

let USER_DEFAULTS = UserDefaults.standard
let DELEGATE = UIApplication.shared.delegate!

typealias  SWjd = JSONDeserializer

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
