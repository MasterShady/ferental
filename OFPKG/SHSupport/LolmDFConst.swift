//
//  LolmDFConst.swift
//  lolmTool
//
//  Created by mac on 2022/2/28.
//

import UIKit
import HandyJSON

#if MJ_EmotionDiary
var DF_Universal_link = "https://www.zuhaowan.com"
#else
var DF_Universal_link = "https://www.zuhaowan.com/apple-app-site-association"
#endif
var LolmDFConst_NetReferenceCount:Int = 0

var is_ui_grey:Int = 0 //首页是否置灰 0否 1 是

let LolmDF_RC4_KRY_CODE = "85*&^d2B64C"

let LolmDF_FACE_BusnissId = "eb9a910f5019499786c3cd6011a94dcf"


let LolmDF_QULICK_LOGIN_RC4_KRY = "app-kssh-2019-*"

let LolmDF_LOGIN_SUCESS_KEY = "LOGINSUCESSLOLDF"
let LolmDF_LOGINOUT_SUCCESS_KEY = "LOGINOUTSUCESSLOLDF"


var LolmDF_KF_URL = "https://kf.zuhaowan.net/im/text/dFsK64a5h294wD85?is_header=1&sceneId=23"

//广告图片存储key
let LolmDF_AD_IMAGE_NAME = "AD_IMAGE_NAME"

//是否展示广告图
let LolmDF_SHOW_IMAGE = "SHOW_IMAGE"
//广告图的标题
let LolmDF_AD_TITLE = "AD_TITLE"
//广告url
let LolmDF_AD_URL = "AD_URL"



#if DEBUG
//数数统计埋点appID
    let LolmDF_ThinkingSDK_APPID = "0b21e685972a44b4af9bf13622c847b3"
//数数统计埋点 公钥
    let LolmDF_ThinkingSDK_PUBLICKEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu5WkOJ0k9HXVhfm9PsjBvfOtDBQVJmo5fkRrGNIQZi5zTChJoDAATTAmt9FsAzgQP4fRBFW/+oo14OzwLKUoXgae+hNpleeqkKdOo9t2oABhEQQwcm/oa9+/O59Nm5rLtPN0HWOmpNtS4JjY0Aswtzjn6XOOo8MLQsxiUFOenLeJRAI63IX59JLkrzeXTca/y6vyJcHGcbc1WrXLGb+ozxM3/dBP0cu2KE/j9qBb7HxDXJVt2PemrjVhnBx+tDUg9K0Iz38DwYjT8cvleMEZP2c/EFRq+ghBDtAjV9zSZQcSzn00H/hh+XUaUPPFLougNVwV8gRX9FuQVkRttMoJVwIDAQAB"

#else
    let LolmDF_ThinkingSDK_APPID = "0f0d35332c244d18b7d7e200a6d20e61"
    let LolmDF_ThinkingSDK_PUBLICKEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzltGVr97mnBmo2iOHxKeJ6pPbE10aCuXn/1ZU/Hv5SsaaHhZsCefEVXoXcs3wRAq7FI6aXLZY7zcsS+I9JQfwLDHonB/0SvkgtkeKFWLHIqQwgjaCmMP3DIfC/oFdTMPckdwLNhD49xUkiztCrwPRmBiUyP06ncG3IeP7Muz40tMR2Cp4E1SSUqbWF0ns0vAl8JvUGknymAGIrh3IYHbt9XgaTzVEt8BC5CK6FhA+xUzB4IPIhrFszss8XcUWPEykPOEgSR/9LoSxctsF0aeMEsK/o1dz7JHy6wjfViSoFO9oQnj3AUWcz7Y7FBS4aod+uMgE9LOoAAZRlA5GF2ttQIDAQAB"
#endif

//数数统计埋点上报地址
let LolmDF_ThinkingSDK_URL = "https://bd-track.zuhaowan.cn/"




//let LolmDF_TC_WBB_CODE_APPID = "2043279182"
let LolmDF_TC_WBB_CODE_APPID = "196400371"// 2022.11.2  "2043279182" 修改为 "196400371"
/*
 防沉迷缓存key
 */
let LolmDF_CHENMI_KEY = "CHENMI";


let LolmDF_HASHKEY = "m*hTXWMD^^hS&H6x"




/*
 青少年模式缓存key
 */
let LolmDF_YOUNG_KEY = "YOUNG";


/**
 存储对象
 */
let USER_DEFAULTS = UserDefaults.standard

/**
 当前delegate对象
 */
let DELEGATE = UIApplication.shared.delegate!


typealias   SWjd = JSONDeserializer

let LolmDF_PAYSOURCE_SCREEN_OrderPage = "256"  //支付paysource- 苹果特惠租号-下单
let LolmDF_PAYSOURCE_SCREEN_UserCenter = "255" //支付paysource- 苹果特惠租号-个人中心


let SW_GameAssist_RC4_KEY = "F21B543B29D7FWEGB2CCC59C5FF5974F"

//let MJ_APPID = "500180002"
let MJ_getIosVersion_type = "7"
let JPUSH_KEY = "ca0824fcb73eea639429160b"////极光推送key
let LolmDF_WX_APPID = "wx47b5177c44092b6b"
let LolmDF_WX_APPKEY = "0680f4692039502be39f0782715d12db"

let LolmDF_QQ_APPID = "102006271"
let LolmDF_QQ_APPKEY = "yqcCZjfNtCH8lBMJ"
//QQ分享 - 测试专用
//let LolmDF_QQ_APPID = "101917903"
//let LolmDF_QQ_APPKEY = "086f096d4ce9dd65a2a0b0485469946b"

//app 签名key 500180001  IhDmA58CMvRwqT3g 500180002  N4Uz3QglHrSeu5Ct  500180003  AiHgdNYBtQMaIz7k  500180004  7NkHrLBKRaU5vn2I  500100000  m*hTXWMD^^hS&H6x

//500180009 x8ecLyhIl4BT7tCD

let DFHttpSignKey = "x8ecLyhIl4BT7tCD"

let DFWebSocketSignKey = "N9Mw0vPIXZP5@hba"


let DF_MJCheck_strategy = 1
