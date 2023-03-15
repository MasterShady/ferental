//
//  LolmDFFunctions.swift
//  lolmTool
//
//  Created by mac on 2022/2/28.
//

import UIKit
import DFBaseLib
import MBProgressHUD
import KeychainAccess
import DFOCBaseLib



func Lolmdf_APPid() ->String {
    return Global.kAppId
}

func LolmDF_APPDELEGATE() -> AppDelegate {
    var myDelegate:AppDelegate!
    
    myDelegate = UIApplication.shared.delegate as? AppDelegate
    return myDelegate
}



//func BaiDu_Mob_Stat_Evevt(_ ev:String,_ label:String? = "",_ attribute:[String:Any]? = nil)  {
////    if attribute == nil {
////        BaiduMobStat.default().logEvent(ev, eventLabel: label ?? "")
////    }else{
////        BaiduMobStat.default().logEvent(ev, eventLabel: label ?? "", attributes: attribute)
////    }
//    BaiduMobStat.default().logEvent(ev, eventLabel: label ?? "", attributes: attribute)
//}

/*
 注册通知
 */
//func LolmDF_NOTIFICATION_REGIST(name:String, param:Any?) {
//
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: param)
//}
//
///*
// 添加通知
// */
func LolmDF_NOTIFICATION_ADD(name:String, methName:String, param:Any?, obj:Any) {

    NotificationCenter.default.addObserver(obj, selector: NSSelectorFromString(methName), name: NSNotification.Name(rawValue: name), object: param)
}
//
///*
// 移除通知
// */
func LolmDF_NOTIFICATION_REMOVE(obj:Any) {

    NotificationCenter.default.removeObserver(obj)
}

///*
// 计算两个时间的时间差
// */
//func LolmDF_timeDifferenceCalculation(oneDate:String, twoDate:String) -> DateComponents {
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let date1 = dateFormatter.date(from: oneDate)
//    let date2 = dateFormatter.date(from: twoDate)
//
//    let calendar = NSCalendar.current
//    let timeInterval = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: date1!, to: date2!)
//
//    return timeInterval
//}
//
//
//func AutoProgressHUD.showAutoHud(message : String, view : UIView? = UIApplication.shared.keyWindow)  {
//
//    MBProgressHUD.show(text: message, to: view)
//}
//
//
///**
// 计算文字的宽度
// */
//func LolmDF_getContentWidth(str:String, font:UIFont, height:CGFloat) -> CGFloat {
//    let size = CGSize.init(width: 999, height: height)
//    let strSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context:nil).size
//    return strSize.width
//}
//
//
///*
// 计算文字的高度
// */
//func LolmDF_getContentHeight(str:String, font:UIFont, width:CGFloat,lineHeight:CGFloat = 0) -> CGFloat {
//    let size = CGSize(width: width, height: 0.0)
//    var dic:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font:font]
//
//    if lineHeight > 0 {
//
//        let style = NSMutableParagraphStyle.init()
//        style.lineSpacing = lineHeight
//        dic[NSAttributedString.Key.paragraphStyle] = style
//    }
//    let strSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic , context:nil).size
//    return strSize.height
//}
//
//
func LolmDFLog<T>(msg : T, file : String = #file, lineNum : Int = #line) {
#if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):[\(lineNum)]:   \(msg)")
#endif
}
//
//
///*
// 返回带段落的 样式字符串
// */
//func LolmDF_paragraphStyleAttributedString(string:String, lineSpacing: CGFloat) -> NSMutableAttributedString {
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineSpacing = lineSpacing
//
//    let attributedString = NSMutableAttributedString(string: string)
//    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//    return attributedString
//}
//
//// 获取当前控制器
//func LolmDF_CurrentViewcontroller() -> UIViewController?{
//    let rootController = UIApplication.shared.keyWindow?.rootViewController
//    if let tabController = rootController as? UITabBarController   {
//        if let navController = tabController.selectedViewController as? UINavigationController{
//            return navController.children.last
//        }else{
//            return tabController
//        }
//    }else if let navController = rootController as? UINavigationController {
//        return navController.children.last
//    }else{
//        return rootController
//    }
//}
//
//
//func LolmDF_ImpactFeedback(style:Int = 0) {
//
//    if #available(iOS 10.0, *) {
//
//        let feedback = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: style) ?? .light)
//
//        feedback.impactOccurred()
//    }
//}
//
//func LolmDF_DispatchTimer(withTime:Int = 1,_block:@escaping(()->())) -> DispatchSourceTimer {
//
//    let  timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
//
//    timer.schedule(deadline: .now(), repeating: Double(withTime))
//
//    timer.setEventHandler(handler: _block)
//
//    return timer
//}
//
func LolmDF_ToHomePage() {

    if let rootVc = UIApplication.shared.keyWindow?.rootViewController, let tabVc = rootVc as? UITabBarController {

        let currentNav =   tabVc.selectedViewController as! lolm_base_navVC;

        let currentIndex = tabVc.selectedIndex

        if currentIndex == 0 {

            currentNav.popToRootViewController(animated: true)
        }
        else{


            currentNav.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                tabVc.selectedIndex = 0
            }

        }

    }else{

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {



        }

    }

}



func LolmDF_toIndex(with:Int)  {

    if let rootVc = UIApplication.shared.keyWindow?.rootViewController, let tabVc = rootVc as? UITabBarController {

        let currentNav =   tabVc.selectedViewController as! lolm_base_navVC;

        let currentIndex = tabVc.selectedIndex

        if currentIndex == with {

            currentNav.popToRootViewController(animated: true)
        }
        else{


            currentNav.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                tabVc.selectedIndex = with
            }

        }

    }else{

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {



        }

    }
}
//
//func LolmDF_RC4Encrypt(_string:String) -> String {
//
//    //当前时间戳
//    let timestamp:String = Date().timeStamp
//
//    let map:Dictionary = ["phone":_string, "timeStamp":timestamp]
//    //字典转化为json字符串
//    let jsonStr:String = map.toJsonString()!
//
//    //对jsonStr进行rc4加密
//    return ZSRc4.swRc4Encrypt(withSource: jsonStr, rc4Key: "LolmDF_RC4_KRY_CODE") as String
//
//}
//
func LolmDF_uuid() ->String {

    let service = "com.lolmdf.app.ios"

    let keychain = Keychain(service: service)

    if let uuid = keychain["uuid"] {

        return uuid
    }
    else{

        let uuid =  UUID().uuidString

        keychain["uuid"] = uuid

        return uuid
    }
}


//手机号正则
func LolmDF_isPhone(phone:String) -> Bool {
    let regex:String = "^((13[0-9])|(14[5-9])|(15([0-3]|[5-9]))|(16[6-7])|(17[1-8])|(18[0-9])|(19[1|3])|(19[5|6])|(19[8|9]))\\d{8}$"
    let p:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    if p.evaluate(with: phone) {
        return true
    }else {
        return false
    }
}
//判断是否是整数
func LolmDF_isPurnInt(string: String) -> Bool {
    let scan: Scanner = Scanner(string: string)
    var val:Int = 0
    return scan.scanInt(&val) && scan.isAtEnd
}
//判断是否是数组（浮点数也为true）
func LolmDF_isPurnFloat(string: String) -> Bool {
    let scan: Scanner = Scanner(string: string)
    var val:Float = 0
    return scan.scanFloat(&val) && scan.isAtEnd
}


/// 获取当前时间的component
/// - Returns:
func LolmDF_getCurrentTimeComponent() -> DateComponents {

    let date = Date()

    let calendar = NSCalendar.current

    let formatlist:[Calendar.Component] = [.year,.month,.weekday,.day,.hour,.minute,.second]

    return  calendar.dateComponents(.init(formatlist), from: date)


}


func LolmDF_dateStrToDateIntervale(str:String,dataformat:String = "yyyy.MM.dd HH:mm:ss") -> TimeInterval {

    let format = DateFormatter.init()
    format.dateStyle = .medium
    format.timeStyle = .short

    format.dateFormat = dataformat

    let date = format.date(from: str)
    return date!.timeIntervalSince1970
}



/// 日期字符串转换为 component
/// - Parameters:
///   - withTime: 日期字符串
///   - format: 格式化
/// - Returns:
func LolmDF_timeComPonment(withTime:String,format:String = "yyyy-MM-dd HH:mm:ss") -> DateComponents  {

    let dataFormatter = DateFormatter.init()
    dataFormatter.dateFormat = format
    let date = dataFormatter.date(from: withTime)

    let calendar = NSCalendar.current
    return  calendar.dateComponents(.init([.year,.month,.weekday,.day,.hour,.minute,.second]), from: date!)


}


/// 获取几天后的日期字符串
/// - Parameters:
///   - withday:
///   - count: =
///   - out_format:
/// - Returns:
func LolmDF__afterDay(withday:String,count:Int,out_format:String = "yyyy.MM.dd") -> String {


    let dataFormatter = DateFormatter.init()
    dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dataFormatter.date(from: withday)!

    let out_date = Date.init(timeInterval: TimeInterval(60*60*24*count), since: date)

    let out_formatter = DateFormatter.init()
    out_formatter.dateFormat = out_format

    return  out_formatter.string(from: out_date)



}


/// 获取几个小时之后的字符串
/// - Parameters:
///   - withday:
///   - hour: 小时数
///   - format:
/// - Returns:
func LolmDF__afterDay(withday:String,hour:Int,format:String = "yyyy.MM.dd HH:mm") -> String {


    let dataFormatter = DateFormatter.init()
    dataFormatter.dateFormat = format
    let date = dataFormatter.date(from: withday)!

    let out_date = Date.init(timeInterval: TimeInterval(60*60*hour), since: date)

    let out_formatter = DateFormatter.init()
    out_formatter.dateFormat = format

    return  out_formatter.string(from: out_date)



}


func LolmDF_image(name:String) -> UIImage {

    return UIImage.init(named: name) ?? UIImage.init()
}


//func LolmDF_IsLogin() -> Bool {
//
//    return LolmDF_LoginCenter.center.isLogin()
//}



/**
 Json字符串转字典
 */
func getDictionaryFromJSONString(jsonString:String) -> NSDictionary {

    let jsonData:Data = jsonString.data(using: .utf8)!

    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)

    if dict != nil {
        return dict as! NSDictionary
    }

    return NSDictionary()
}
/// 获取当前设备IP
func getOperatorsIP() -> String? {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}



func DFCacheRootPath() -> String  {

    let str = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true)[0]

    return str
}




//秒数转为时分秒
func DF_secondsToTime(withSeconds:Int) ->String{

    func __format(with:Int) -> String{

        if with <= 0 {

            return "00"

        }else if with > 9 {

            return "\(with)"
        }else{

            return "0\(with)"
        }
    }
    let hour = withSeconds / 3600


    let minutes = (withSeconds - hour * 3600)/60

    let seconds = withSeconds - hour * 3600 - minutes * 60

    return "\(__format(with: hour)):\(__format(with: minutes)):\(__format(with: seconds))"
}


func DF_webviewPublicParam() -> String {

    //添加共用参数
    var params = [String:Any]()

    params["app_id"] = Lolmdf_APPid()
    params["app_channel"] = "appstore"
    let versionName:String = Global.df_version
    params["app_version_name"] = versionName
    let versionCode = versionName.replacingOccurrences(of: ".", with: "")
    params["app_version_code"] = versionCode

    if let token:String = LolmDFHttpSession.shareManager().paramProvider?.getToken(), token.count > 0 {
        params["token"] = token
    }

    params["native_type"] = "ios-app"
    let array =  params.map { ky in

        return "\(ky.key)=\(ky.value)"
    }

    return array.joined(separator: "&")
}
func DF_getPushNotificationStatus(with:@escaping (Bool)->())  {





    UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
        switch setttings.authorizationStatus{


        case .denied,.notDetermined,.ephemeral:

            with(false)
        default :
            with(true)
        }
    }


}

func ZH_FOUNT(size:CGFloat, weight:UIFont.Weight) -> UIFont {
    return UIFont.systemFont(ofSize: size * BASE_WIDTH_SCALE, weight: weight)
}


/**
 绘制虚线
 lineView:目标试图
 isHorizontal;虚线方向
 lineLength:线长度
 lineSpacing：空格长度
 lineColor：线颜色
 */
func drawDashLine(lineView:UIView,isHorizontal:Bool,lineLength:Int,lineSpacing:Int,lineColor:UIColor) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = lineView.bounds
    shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
    shapeLayer.strokeColor = lineColor.cgColor

    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
    let path = CGMutablePath()
    if isHorizontal == true {//横向
        shapeLayer.lineWidth = lineView.bounds.size.height
        path.move(to: CGPoint(x: 0, y: lineView.bounds.size.height/2))
        path.addLine(to: CGPoint(x: lineView.bounds.size.width, y: lineView.bounds.size.height/2))
    }else{
        shapeLayer.lineWidth = lineView.bounds.size.width
        path.move(to: CGPoint(x: lineView.bounds.size.width/2, y: 0))
        path.addLine(to: CGPoint(x: lineView.bounds.size.width/2, y: lineView.bounds.size.height))
    }
    shapeLayer.path = path
    lineView.layer.insertSublayer(shapeLayer, at: 0)
}

//带标签的文本，用于label显示HTML文本
func getHTMLAttributedString(str:String,attributeds:[NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
    do {
        let attributedString = try NSMutableAttributedString(data: str.data(using: String.Encoding.unicode, allowLossyConversion: true) ?? Data(),
                                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                                             documentAttributes: nil)


        if attributeds != nil {
            attributedString.addAttributes(attributeds!, range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString

    } catch {
        return NSAttributedString()
    }
}

