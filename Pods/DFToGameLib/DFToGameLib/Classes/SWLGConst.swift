//
//  SWLGConst.swift
//  DoFunNew
//
//  Created by mac on 2021/6/4.
//

import Foundation


let rsa_key:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsHWwJ8nBCsSkq0jJVuVQQArzSaW8oOhH0nqZTa+FGN7fVLTl1vlSja+6MjlvoZeelubQExAaImD7pc/QxcrTh01uZuEmfikFe/pKDjcUnEtIBPMiPl49BXWtq4ZnEjgMIQv9Sirb6/Tnf8Cyc8+BTwstu+MV7AJbmFtbv9AvcjwIDAQAB"

let game_auth_key = "F21B543B29D7C5E9B2CCC59C5FF5974F"



let login_rc4_key = "dbe320f44b2c1a0a"


let SW_NETErrorDescription = "网络不稳定，请稍后重试"

let SW_HMCLoudChannelId = "zhw"





///iOS开始游戏，限制唯一设备检测 ---上号器未调用
let SW_API_LoginOaidCheck = "Quick/appLoginOaidCheck"

///QQ快速上号订单投诉人脸检测 ---没有使用
//let SW_API_FACEVERIFYCHKHAORENT = "FaceVerify/chkHaoRent"


///微信快速上号加入微信上号获取token队列-----
let SW_API_WX_QUICK_TOKEN_QUEUE = "Quick/setWxQueue"

///轮询微信快速上号code-----
//let SW_API_CHEK_WX_LOGIN_CODE = "appv3/quick/getWxToken"
let SW_API_CHEK_WX_LOGIN_CODE = "Quick/getWxToken"

///加入微信快速上号修复队列-----
let SW_API_WX_QUICK_RESER_QUEUE = "Quick/setWxResetQueue"

///获取微信快速上号修复后的token-----
let SW_API_WX_RESET_CODE = "Quick/getWxResetToken"

///开始游戏获取游戏信息-----
let SW_API_QQ_GetOrderInfo = "Quick/getTokenByUncode"

///QQ快速上号人脸检测结果上报-----
//let SW_API_QQ_FACEVERIFYREPORT = "appv3/faceVerify/report"
let SW_API_QQ_FACEVERIFYREPORT = "FaceVerify/report"

///  获取token上报token-----
//let SW_API_SETTOKENSOFT = "appv3/quick/setTokenRent"
let SW_API_SETTOKENSOFT = "Quick/setTokenRent"

/// 获取token上报错误-----
let SW_API_SETTOKENERROR = "Quick/addReportErr"


///  获取正确密码----
//let SW_API_QUICK_ENCRYPT = "appv3/quick/getQuickEncrypt"
let SW_API_QUICK_ENCRYPT = "Quick/getQuickEncrypt"
///上报快速上号信息 -- 上号器未调用

let SW_API_QULICKLOGIN_INFO = "IndexV2/entry"


//获取服务端上号token
let SW_API_GETSERVERORDER_TOKEN = "quick/getServerOrderToken"



//海马云上号成功进行上报
let SW_API_HMCloud_ReportOrder = "quick/cloudReportOrder"
//到时不下线-订单结束
let SW_API_HMCloud_OffLine = "quick/cloudOffline"
//中间件上报
let SW_API_HMCloud_middlewareLogin = "quick/middlewareLogin"

//微信上号结果上报
let SW_API_WxReport = "quick/reportWxOrderLog"


//中台请求上号
let SW_ZHT_API_LoginRequest = "api/quick/login/request"

//中台查询上号结果
let SW_ZHT_API_QueryLoginResult = "api/quick/login/getResult"

//中台 上号-请求tx数据包
let SW_ZHT_API_QueryTxDataPackage = "api/quick/login/getTxDataPackage"


//中台 上号-请求解析tx返回结果
let SW_ZHT_API_getResult = "api/quick/login/analysisResult"


//中台 上号-查询游戏授权码
let SW_ZHT_API_getAuthCode = "api/quick/login/getAuthCode"



//兼容上号器，没有token，传的是apitoken:处理方式url + 时间戳 + 签名
var SW_API_TOKEN_MAP:[String:String] =
    [
        SW_API_WxReport:"quickreportWxOrderLog",
        SW_API_QUICK_ENCRYPT:"QuickgetQuickEncrypt",
        SW_API_WX_QUICK_TOKEN_QUEUE:"QuicksetWxQueue",
        SW_API_CHEK_WX_LOGIN_CODE:"QuickgetWxToken",
        SW_API_WX_QUICK_RESER_QUEUE:"QuicksetWxResetQueue",
        SW_API_WX_RESET_CODE:"QuickgetWxResetToken",
        SW_API_QQ_GetOrderInfo:"QuickgetTokenByUncode",
        SW_API_SETTOKENSOFT:"QuicksetTokenRent",
        SW_API_SETTOKENERROR:"QuickaddReportErr",
        SW_API_QQ_FACEVERIFYREPORT:"FaceVerifyreport",
        SW_API_GETSERVERORDER_TOKEN:"quickgetServerOrderToken",
        SW_API_HMCloud_ReportOrder:"quickcloudReportOrder",
        SW_API_HMCloud_middlewareLogin:"quickmiddlewareLogin",
        SW_API_HMCloud_OffLine:"quickcloudOffline"
    ]

