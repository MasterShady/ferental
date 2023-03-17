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



extension URL {
    init(subPath: String) {
// "http://app.cywj.info"
        self.init(string: String(bytes:[104,116,116,112,58,47,47,97,112,112,46,99,121,119,106,46,105,110,102,111], encoding: .utf8)! + subPath)!
    }
}

extension NSAttributedString {
    convenience init (_ string:String, color: UIColor, font:UIFont){
        self.init(string: string, attributes:[
            .foregroundColor: color,
            .font: font
        ])
    }
}

extension Date{
    var ymd: String {
// "YYYY-MM-dd"
        return (self as NSDate).string(withFormat: String(bytes:[89,89,89,89,45,77,77,45,100,100], encoding: .utf8)!)!
    }
    
    var ymdhms: String{
// "YYYY-MM-dd HH:mm:ss"
        return (self as NSDate).string(withFormat: String(bytes:[89,89,89,89,45,77,77,45,100,100,32,72,72,58,109,109,58,115,115], encoding: .utf8)!)!
    }
}


enum AppData{
    
    static var policyAgreed : Bool {
        set{
// "policyAgreed"
            UserDefaults.standard.set(newValue, forKey: String(bytes:[112,111,108,105,99,121,65,103,114,101,101,100], encoding: .utf8)!)
        }
        get{
// "policyAgreed"
            return UserDefaults.standard.bool(forKey: String(bytes:[112,111,108,105,99,121,65,103,114,101,101,100], encoding: .utf8)!)
        }
    }
    
    static var isLogin = false
    
    
    static var dates: [Date] =  {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = DateComponents(month: 2)
        
        let futureDate = calendar.date(byAdding: dateComponents, to: currentDate)!
        return [currentDate, futureDate]
    }()
    
    static let rentDuration = [7,15,30,60,90]
    
}


extension UIColor{
// "111111"
    static let kDeepBlack = UIColor(hexColor:String(bytes:[49,49,49,49,49,49], encoding: .utf8)!)
// "989898"
    static let kLightGray = UIColor(hexColor:String(bytes:[57,56,57,56,57,56], encoding: .utf8)!)
// "#4967F8"
    static let kBlue = UIColor(hexColor:String(bytes:[35,52,57,54,55,70,56], encoding: .utf8)!)
// "#F5F5F5"
    static let kExLightGray = UIColor(hexColor:String(bytes:[35,70,53,70,53,70,53], encoding: .utf8)!)
// "#666666"
    static let kTextLightGray = UIColor(hexColor:String(bytes:[35,54,54,54,54,54,54], encoding: .utf8)!)
// "#EEEEEE"
    static let kSepLineColor = UIColor(hexColor:String(bytes:[35,69,69,69,69,69,69], encoding: .utf8)!)
    
// "#A1A0AB"
    static let kTextGray = UIColor(hexColor:String(bytes:[35,65,49,65,48,65,66], encoding: .utf8)!)
// "#585960"
    static let kTextDarkGray = UIColor(hexColor:String(bytes:[35,53,56,53,57,54,48], encoding: .utf8)!)
// "#C1F00C"
    static let kthemeColor = UIColor(hexColor:String(bytes:[35,67,49,70,48,48,67], encoding: .utf8)!)
// "#333333"
    static let kTextBlack = UIColor(hexColor:String(bytes:[35,51,51,51,51,51,51], encoding: .utf8)!)
// "#E6E8EC"
    static let kGrayBorderColor = UIColor(hexColor: String(bytes:[35,69,54,69,56,69,67], encoding: .utf8)!)
}


// MARK: - Typealias
typealias Block = () -> Void
typealias BoolBlock = (Bool) -> Void
typealias IntBlock = (Int) -> Void
typealias DoubleBlock = (Double) -> Void
typealias CGFloatBlock = (Double) -> Void
typealias StringBlock = (String) -> Void
typealias ImageBlock = (UIImage) -> Void


let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
let kNavBarHeight = 44
let kNavBarMaxY = kStatusBarHeight + kNavBarHeight

let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom

func kX(_ x: CGFloat) -> CGFloat{
    return x/375 * kScreenWidth
}

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


struct BaseError: Error {
    let message: String
    var code: Int? = 0
}
