//
//  Lolmdf_LoginModel.swift
//  lolmTool
//
//  Created by mac on 2022/3/1.
//

import Foundation
import HandyJSON

class Loldf_LoginRespose: HandyJSON {
    required init() {}
    
    var status:Int?
    var message:String = ""
    
    var data:Lolmdf_LoginModel?
}

class Lolmdf_LoginModel: HandyJSON {
    required init() {}
    static var `default`:Lolmdf_LoginModel?
    var token:String = ""
    var token_end_time:String = "" //token过期时间，启动时候用来判断重新登录
    var cookie_secure_stamp:String = ""
    var freePlay:String = ""
    var id:Int? //用户id
    var userid:String = "" //用户名
    var usermoney:String = ""
    var userdjmoney:String = "" //冻结金额
    var rent_verify:Int?
    var authname:Int?
    var head_img:String = "" //头像地址
    var is_new:Int = 0 //是否新用户
    var must_bind_phone:Int = 0 //是否需要绑定手机号0不需要 1需要 2强制绑定
    var antiIndulge:Lolmdf_AntiIndulgeModel?
    var new_hongbao:Lolmdf_new_hongbaoModel?
    var hb_info:lolmdf_redpacketModel?
    //首页订单租赁情况浮窗是否点击过关闭
    var is_clickedHomeOrderSiuationView:Bool = false
    //个人中心-有红包未使用时是否点过红包
    var is_clickedMineRedpacket:Bool = false
}
class Lolmdf_AntiIndulgeModel: HandyJSON {
    required init() {}
    
    var status:Int?
    var message:String = ""//"未开启实名认证"
    
    var face_status:Bool = false
    
    var modify_authname:Bool = false
    
    var face_msg:String = ""
    var need_face_verify:String = ""
}
class lolmdf_redpacketModel: HandyJSON {
    required init() {}
    
    var status:Int?
    var hbData:Array = [Any]()
}
class Lolmdf_new_hongbaoModel: HandyJSON {
    required init() {}
    
    var status:Int?
    var message:String = ""//"暂无新红包记录"
}




class SWTencentCapchaStatusModel: HandyJSON {
    
    required init() {
            
    }
    
    var captcha_switch:Bool = false
}

