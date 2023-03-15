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
    static let kAppId = "500180009"
    static let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
    static let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom
    static var isTest = true //是否是测试. 这个会影响到上号Lib的接口.
    static let df_version = Bundle.main.infoDictionary!["long_verison_key"] as? String ?? "1.0.0.0"
    static var notificationAvaliable = false
    static let kNotificationStatusChanged = "kNotificationStatusChanged"
}


let kBundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
let kCachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let kTempPath = NSTemporaryDirectory()
let kNameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
let kAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let kBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

let kJushAppKey = "0acbd33bc6e17e7dd664e690"


extension URL {
    init(subPath: String) {
        self.init(string: "http://app.cywj.info" + subPath)!
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
        return (self as NSDate).string(withFormat: "YYYY-MM-dd")!
    }
    
    var ymdhms: String{
        return (self as NSDate).string(withFormat: "YYYY-MM-dd HH:mm:ss")!
    }
}


enum AppData{
    
    static var policyAgreed : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "policyAgreed")
        }
        get{
            return UserDefaults.standard.bool(forKey: "policyAgreed")
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
    static let kDeepBlack = UIColor(hexColor:"111111")
    static let kLightGray = UIColor(hexColor:"989898")
    static let kBlue = UIColor(hexColor:"#4967F8")
    static let kExLightGray = UIColor(hexColor:"#F5F5F5")
    static let kTextLightGray = UIColor(hexColor:"#666666")
    static let kSepLineColor = UIColor(hexColor:"#EEEEEE")
    
    static let kTextGray = UIColor(hexColor:"#A1A0AB")
    static let kTextDarkGray = UIColor(hexColor:"#585960")
    static let kthemeColor = UIColor(hexColor:"#C1F00C")
    static let kTextBlack = UIColor(hexColor:"#333333")
    static let kGrayBorderColor = UIColor(hexColor: "#E6E8EC")
}



// MARK: - Typealias
typealias Block = () -> Void
typealias BoolBlock = (Bool) -> Void
typealias IntBlock = (Int) -> Void
typealias DoubleBlock = (Double) -> Void
typealias CGFloatBlock = (Double) -> Void
typealias StringBlock = (String) -> Void
typealias ImageBlock = (UIImage) -> Void


// MARK: - Font
func kRegularFont(_ size: CGFloat) -> UIFont {
    if let font = getFontWithName("AcariSans Regular", size) {
        return font
    }
    return UIFont.systemFont(ofSize: size, weight: .regular)
}

func kMediumFont(_ size: CGFloat) -> UIFont {
    if let font = getFontWithName("Acari Sans Medium", size) {
        return font
    }
    return UIFont.systemFont(ofSize: size, weight: .medium)
}

func kBoldFont(_ size: CGFloat) -> UIFont {
    if let font = getFontWithName("Acari Sans Bold", size) {
        return font
    }
    return UIFont.systemFont(ofSize: size, weight: .bold)
}

func kBlackFont(_ size: CGFloat) -> UIFont {
    if let font = getFontWithName("Acari Sans Black", size) {
        return font
    }
    return UIFont.systemFont(ofSize: size, weight: .black)
}

func kSemiBoldFont(_ size: CGFloat) -> UIFont {
    if let font = getFontWithName("Acari Sans SemiBold", size) {
        return font
    }
    return UIFont.systemFont(ofSize: size, weight: .bold)
}

private func getFontWithName(_ name: String, _ size: CGFloat) -> UIFont? {
    if let font = UIFont(name: name, size: size) {
        return font
    }
    if let font = UIFont(name: name.replacingOccurrences(of: " ", with: "-"), size: size) {
        return font
    }
    if let font = UIFont(name: name.replacingOccurrences(of: " ", with: ""), size: size) {
        return font
    }
    return nil
}



//MARK: Layout

/*
 获取设备statusBar高度的方式
 
 方式一: UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.top
 方式二: UIApplication.shared.statusBarFrame.height
 
 safeAreaInsets 说明:
 
 实际上这个top的值就是设备statusBar的高度. safeAreaInsets.top  == [[UIApplication sharedApplication] statusBarFrame].size.height

 不同型号设备值是不一样的, 下面为测试结果.
 (top = 44, left = 0, bottom = 34, right = 0) for iphoneX
 (50,0,34,0) for iphone12 mini
 (47,0,34,0) for 12 pro & 12 pro max
 (20,0,0,0) for normal device eg: iphone6.
 (24,0,20,0) for 4th iPad Air
 */
let kStatusBarHeight: CGFloat = UIApplication.shared.windows.first!.safeAreaInsets.top
let kNavBarHeight = 44
let kNavBarMaxY = kStatusBarHeight + kNavBarHeight

let kBottomSafeInset = UIApplication.shared.windows.first!.safeAreaInsets.bottom

func kX(_ x: CGFloat) -> CGFloat{
    return x/375 * kScreenWidth
}

let kDebugServer = "http://app.cywj.info/api"
var kServerHost: String {
    return kDebugServer
}

let kUserChanged = Notification(name: Notification.Name("kUserChanged"), object: nil)

let kUserMakeOrder = Notification(name: Notification.Name("kUserMakeOrder"), object: nil)
//用户重新联网
let kUserReConnectedNetwork = Notification(name: Notification.Name("kUserReConnectedNetwork"), object: nil)




struct BaseError: Error {
    let message: String
    var code: Int? = 0
}
