//
//  SWLoginGameRequestTasks.swift
//  DoFunNew
//
//  Created by mac on 2021/6/1.
//

import Foundation


/// 快速上号检测设备是否封禁
/// - Parameters:
///   - loadOfview: load super view
///   - callback: 回调
/// - Returns:
func sw_loginGame_checkDeviceUid(lockcode:String,loadOfview:UIView?,callback:@escaping(Bool,String)->())  {
     
       let loading = loadOfview != nil
      
        SWNetworkingTool.requestFun(url:  SW_API_LoginOaidCheck, method: .get, parameters: ["dh":lockcode], showLoading: loading) { json in
            
            guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
                
                callback(false,"数据解析异常")
                return
            }
            
            if model.status == 1{
                
                callback(true,"")
            }
            else{
                callback(true,model.message)
            }
            
            
            
        } failBlock: { error in
            
            callback(false,"网络异常")
        }

    
    
}


/// 加入获取token队列
/// - Parameters:
///   - orderId: 订单id
///   - callBack: 回调
/// - Returns:
func sw_logingame_wx_joinTokenQueue(orderId:String,callBack:@escaping(Int?)->())  {
     
    var param = [String:Any]()
    param["order_id"] = orderId
    param["source"] = "808"
    
    if SWOtherInfoWrap.shared.channel == .shanghaoqi {
        param["source"] = "810"
    }
    SWNetworkingTool.requestFun(url:  SW_API_WX_QUICK_TOKEN_QUEUE, method: .post, parameters: param) { json in
        
        guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
            
            callBack(-1)
            return
        }
        
        callBack(model.status)
        
    } failBlock: { error in
        
        callBack(nil)
    }

    
}


/// 轮询接口 微信上号数据
/// - Parameters:
///   - orderId: 订单id
///   - callBack: 回调
/// - Returns:
func sw_logingame_wx_getToken(orderId:String, callBack:@escaping (Int?,String)->())  {
     
    var param = [String:Any]()
    param["order_id"] = orderId
    
    SWNetworkingTool.requestFun(url:  SW_API_CHEK_WX_LOGIN_CODE, method: .post, parameters: param,showLoading: false) { json in
        
        guard let model = SWjd<SWHttpResponse<SWLoginGameWXCodeModel>>.deserializeFrom(json: json) else {
            
            callBack(-1,"")
            return
        }
        
        guard model.status == 1 else {
            callBack(model.status,model.message)
            return
        }
        
        callBack(1,model.data.token)
        
    } failBlock: { error in
        
        callBack(nil,"")
    }

}



/// 修复队列
/// - Parameters:
///   - orderId: 订单id
///   - callBack: 回调
/// - Returns:
func sw_logingame_wx_joinResetQueue(orderId:String,callBack:@escaping(Int?)->())  {
    
    var param = [String:Any]()
    param["order_id"] = orderId
    param["source"] = "808"
    if SWOtherInfoWrap.shared.channel == .shanghaoqi {
        param["source"] = "810"
    }
    SWNetworkingTool.requestFun(url:  SW_API_WX_QUICK_RESER_QUEUE, method: .post, parameters: param,showLoading: false) { json in
        
        guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
            
            callBack(-1)
            return
        }
        
        callBack(model.status)
        
    } failBlock: { error in
        
        callBack(nil)
    }

    
}


/// 微信轮询修复code
/// - Parameters:
///   - orderId: 订单id
///   - callBack: 回调
/// - Returns:
func sw_logingame_wx_resetData(orderId:String, callBack:@escaping (Int?,String)->())  {
    
    var param = [String:Any]()
    
    param["order_id"] = orderId
    
    
    SWNetworkingTool.requestFun(url:  SW_API_WX_RESET_CODE, method: .post, parameters: param,showLoading: false) { json in
        
        guard let model = SWjd<SWHttpResponse<SWLoginGameWXCodeModel>>.deserializeFrom(json: json) else {
            
            callBack(-1,"")
            return
        }
        
        guard model.status == 1 else {
            
            callBack(model.status,model.message)
            return
        }
        
        callBack(1,model.data.token)
        
    } failBlock: { error in
        
        callBack(nil,"")
    }

}



///  QQ 上号获取上号信息
/// - Parameters:
///   - withUnlockCode:
///   - withcallBack:
/// - Returns:
func sw_logingame_qq_getOrderInfo(withUnlockCode:String,withcallBack:@escaping (Int,SWQuickLoginGameModel?)->())  {
    
    let currentTime = String.timeIntervalChangeToTimeStr(timeInterval: NSDate().timeIntervalSince1970)
    //（分组名+控制器名+方法名+时间戳+秘钥 拼接一起的md5值）
    /**
     上号5.0
     MD5签名 去掉AppV3
     新增参数：quick_version == 5
       添加海马云 quick_version == 7
     */
    let paramStr = "QuickgetTokenByUncode\(currentTime)3b133bd80074285c335ce57ae5cfd0a9"
    
    let api_token = paramStr.swMD5Encrypt(.lowercase32)
    
    var param = [String:Any]()
    
    param["api_token"] = api_token
    
    param["uncode"] = withUnlockCode
    
    param["time"] = currentTime
    
    param["quick_version"] = "7"
    
    SWNetworkingTool.requestFun(url:  SW_API_QQ_GetOrderInfo, method: .get, parameters: param) { (json) in
        
        SWLGLog(withMsg: "获取上号信息:\(json)")
        guard let model = SWjd<SWHttpResponse<SWQuickLoginGameModel>>.deserializeFrom(json: json) else {
            
            withcallBack(-1,nil)
            return
        }
        
        guard model.status == 1 else {
            
            withcallBack(model.status,nil)
            
            return
        }
        
        withcallBack(1,model.data)
        
    } failBlock: { (error) in
        
        withcallBack(-2,nil)
    }

    
}



/// 上报人脸结果

func sw_logingame_qq_faceverify_report(withChk_id:Int,chk_memo:String,isface:Int,type:Int = 0,callBack:@escaping(Int?,String)->())  {
    
    
    var param:[String:Any] = [:]
    param["chk_id"] = withChk_id
    param["chk_memo"] = chk_memo
    param["isface"] = isface
    param["type"] = type
    
    SWNetworkingTool.requestFun(url:  SW_API_QQ_FACEVERIFYREPORT, method: .post, parameters: param) { (json) in
        
        guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
            
            callBack(-1,"")
            return
        }
        
        callBack(model.status,model.message)
        
    } failBlock: { (error) in
        
        callBack(nil,"")
    }

}


/// 微信上号结果上报
/// - Parameters:
///   - withQueue_id: 上号id 重试需和第一次上号保持一致
///   - withOrder_id: 订单id 可能为空
///   - withUncode: 解锁码
///   - status: 上号状态
///   - remark: 标识
///   - quick_version: 上报版本
///   - callBack: 回调
func sw_wx_login_report(withQueue_id:String,withOrder_id:String?,withUncode:String ,status:String, remark:String , quick_version:String , callBack:@escaping(Int,String)->())  {
    
    var param:[String:Any] = [:]
    param["queue_id"] = withQueue_id
    param["order_id"] = withOrder_id
    param["withUncode"] = withUncode
    param["status"] = status
    param["remark"] = remark
    param["quick_version"] = quick_version
    
    SWNetworkingTool.requestFun(url:  SW_API_WxReport, method: .post, parameters: param) { (json) in
        
        guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
            
            callBack(-1,"")
            return
        }
        
        callBack(model.status,model.message)
        
    } failBlock: { (error) in
        
        callBack(-2,"")
    }

}

//中台请求上号
func sw_zht_login_request(withBusinessType:String ,openMode:String ,pt:String, businessData:String,withCallBack:@escaping (_ response: MJHttpResult)->Void)  {
     
    let service = MJHttpService.init()
    service.apiType = 1
    service.httpMethod = .post
    service.api = SW_ZHT_API_LoginRequest
    var params = ["businessType":withBusinessType,
                  "openMode":openMode,
                  "pt":pt
                  
                 ]
    if businessData.isEmpty == false {
       
        params["businessData"] = businessData
    }
    service.param = params
    
    SimpleHttp.default.httpTask(service) { response in
        
        withCallBack(response)
    }
}

