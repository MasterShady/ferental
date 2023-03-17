//
//  LolmDFConst.swift
//  lolmTool
//
//  Created by mac on 2022/2/28.
//

import UIKit
import HandyJSON

var LolmDFConst_NetReferenceCount:Int = 0
let LolmDF_FACE_BusnissId = "eb9a910f5019499786c3cd6011a94dcf"

let USER_DEFAULTS = UserDefaults.standard
let DELEGATE = UIApplication.shared.delegate!

typealias  SWjd = JSONDeserializer

let LolmDF_WX_APPID = "wx47b5177c44092b6b"
let LolmDF_WX_APPKEY = "0680f4692039502be39f0782715d12db"

let LolmDF_QQ_APPID = "102006271"
let LolmDF_QQ_APPKEY = "yqcCZjfNtCH8lBMJ"

//app 签名key 500180001  IhDmA58CMvRwqT3g 500180002  N4Uz3QglHrSeu5Ct  500180003  AiHgdNYBtQMaIz7k  500180004  7NkHrLBKRaU5vn2I  500100000  m*hTXWMD^^hS&H6x
//500180009 x8ecLyhIl4BT7tCD
let DFHttpSignKey = "x8ecLyhIl4BT7tCD"
let DFWebSocketSignKey = "N9Mw0vPIXZP5@hba"

let kPreviewReleaseServer = "http://10.10.24.178:9502/"
let kReleaseServer = "https://zhwapp.zuhaowan.com/"
let kJushAppKey = "0acbd33bc6e17e7dd664e690"


let SW_KHOST = ""
let LolDF_QQLogin = "Login/qqLoginNew"
let LolDF_WECHATLogin = "Login/wxLoginV2"
let kGetAppInfo = "Information/getIosVersion"
