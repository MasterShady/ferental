//
//  SWLoginGameModels.swift
//  DoFunNew
//
//  Created by mac on 2021/6/1.
//

import Foundation
import HandyJSON

class SWLoginGameWXCodeModel: HandyJSON {
    
    var token:String = ""
    
    required init() {
        
    }
}


class SWQuickLoginGameModel: HandyJSON {
    
    required init() {
        
    }
    
    var qq:String = ""
    var type:Int = 0
    var default_source:String = "999"
    
    var order_info:SWQuickLoginOrderInfoModel?
    
    var face_verify_switch:SWQuickLoginFaceSwitchModel?
    
    var quick_info:SWQuickLoginQuickInfoModel?
    
}


class SWQuickLoginOrderInfoModel: HandyJSON {
    
    required init() {
        
    }
    
    var orderid = ""
    var add_time = ""
    var zq = ""
    var stimer = ""
    var etimer = ""
    var zt = ""
    var hid = ""
    var gameid = ""
    var add_form = ""
    var game_server = ""
    
    
}
class SWQuickLoginFaceSwitchModel: HandyJSON {
    
    required init() {
        
    }
    
    var `switch`:Bool = false
    
    var switch2:Int = 0
    
    var quick_token:String = ""
    
    var url:String = ""
    
    var hopetoken = ""
    
    var chk_id:Int = 0
    
    
    
    
}
class SWQuickLoginQuickInfoModel: HandyJSON {
    
    required init() {
        
    }
    var order_login:String = ""
    var repair_switch:Bool = false
    var is_wx_server:Bool = false
    var game_mm:String = ""
    var game_auth:String = ""
    var game_auth_88:String = ""
    var quick_token:String = ""
    var rent_auth_address:String = ""
    var rent_auth_port:Int = 0
    var rent_auth_ports:String = ""
    var quick_identity:String = ""
    var total_times:Int = 0
    var try_times:Int = 0
    var usable_times:Int = 0
   
    var quick_device:String = ""
    var default_source:String = ""
    var last_source:String = ""
    var hid:String = ""
    var game_auth_address:String = ""
    var game_auth_port:Int = 0
    var quick_cloud:String = "" // 云游戏参数
    
    var game_info:SWQuickInfoGameInfoModel?
    
    var quick_type:[SWQuickInfoQuickTypeModel] = []
    
    var haima_cloud:Int = 0   // 海马云开关 0关闭,1-uid,2-中间件
    var loading:String = ""
    
    var offline_switch:Int = 0  // 到时不下线开关   0-关闭,1-开启
    var cloud_login:Int = 0  // 云游戏登录态开关 0-关闭,1-开启
    var cloud_bid:String  = ""  // 云游戏BID配置
    var cloud_access_key:String = ""   // 云游戏accesskey
    var cloud_timeout:Int = 0
    var cloud_uid:String = ""
    var cloud_plan:Int = 0
    
    
    /***********************微信参数*************************/
    
    var open_mode:String = "" //开通模式【1->服务端发包；2->客户端发包】
    var credential:String = "" //sdk使用和中台交互
    var pt:String = ""//平台, sdk使用和中台交互 上号平台 0：PC、1：Android、2：iOS
    var biz_id:String = "" //传输给sdk的业务id
    var biz_data:String = "" //传输给sdk使用的数据, json格式
    var biz_type:String = ""//传输给sdk的业务平台标识
    var queue_id:String = ""//上号队列id, 上报时使用
    
    
    
    
    
}


class SWQuickInfoGameInfoModel: HandyJSON {
    
    required init() {
        
    }
    
    var gid:String = ""
    var gname:String = ""
    var package_android:String = ""
    var appid_android_qq:String = ""
    var package_ios_qq:String = ""
    var sign_android:String = ""
    var status:String = ""
    
    
    
    
    
    
    
}


class SWQuickInfoQuickTypeModel: HandyJSON {
      
    required init() {
        
    }
    /** name
     
     快速上号方式
     84 => 8.4上号方式
     qrcode => 扫码方式(暂无)
     server => 服务端v2.0方式(默认token上号)
     weblogin => web登录
     */
    var name:String = ""
    //上报token或者错误的时候带上
    var source:String = ""
    //这个是会自动投诉的条件, 碰见这种上报错误, 我就直接投诉掉了
    var off_rent:[String] = []
    
    //这个是重试条件,碰见就重试
    var retry:[String] = []
    
    //这是重试次数
    var retry_times:Int = 0
    
    var loading:String = ""
}

//海马云消息模型
class SWHMCloudMessageModel: HandyJSON {
    required init() {
        
    }
    
    var type:Int = 0
    var gameStatus:Int = 0 //1 游戏登录成功 2 开始对局 3 对局结束
    var openId:String = ""
    var log:String = ""
    var desc:String = ""
    
    var errorMsg:String = ""
    
    
    
}

//websocket 消息模型
class SWWebsocketMessageModel: HandyJSON {
    
    required init() {
        
    }
    
    var action:String = ""
    var status:String = ""
    var message:String = ""
    var data:SWWebsocketWrapModel?
    
    
}

struct SWWebsocketWrapModel:HandyJSON {
    
    var order_status:Int = 0 //1 正常 0异常 2结束
    
    var session_id:String = ""
}

struct SWHMCloudMiddlewareLoginModel: HandyJSON {
    
    var log:String = ""
    
    var auto_ts:Bool = false //true的话 需要 退出 终止
}
class  SWZHTQueryModel: HandyJSON {
    
    required init() {
        
    }
    
    var queueId:String = ""
    
    
   
}

class SWZHTReqTxModel: HandyJSON {
    
    required init() {
    
    }
    
    var reqTxData:String  = ""
    var handleStatus:Int = 0
    var handleStatusMsg:String = ""
    var authCode:String = ""
}

