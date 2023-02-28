//
//  Constants.swift
//  StoryMaker
//
//  Created by Park on 2022/1/9.
//  Copyright © 2020 mayqiyue. All rights reserved.
//

import UIKit
import HandyJSON




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
    
//    //"绝地求生","英雄联盟","王者荣耀","逆战","QQ飞车","枪神纪", "原神", "倩女幽魂"
//    static var computerGames: [Game] = {
//      (0...10).map {.init(name:"电脑游戏" + String($0))}
//    }()
//
//    static var phoneGames: [Game] = {
//        (0...10).map {.init(name:"手机游戏" + String($0))}
//    }()
    
    static var dates: [Date] =  {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = DateComponents(month: 2)
        
        let futureDate = calendar.date(byAdding: dateComponents, to: currentDate)!
        return [currentDate, futureDate]
    }()
    
    static let rentDuration = [7,15,30,60,90]
    
    static let computeBrands = [
        Brand(name: "Intel", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel2", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel3", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel4", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel5", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel6", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel7", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel8", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel")
    ]
    
    static let phoneBrands = [
        Brand(name: "Apple", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple2", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple3", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple4", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple5", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple6", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple7", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple8", logo: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel")
    ]
    
    
    //Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "夜空铺满狼的眼睛\n刺穿天真的梦呓", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 20)
    
    static let mockDevices = [
        Device()
//        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 25),
//        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 21),
//        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 22),
//        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 23),
//        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , name: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, price: 24)
    ]
    
    
    static let order = Order()
    //Order(status: .pendingReview, cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", orderDate: Date() , orderId: "1234567", startDate:Date())
    
    static let orders = [
        Order(),
        Order(),
        Order()
    ]
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


// MARK: - Other
let kCachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
let kTempPath = NSTemporaryDirectory()


let kNameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
let kDebugServer = "http://app.cywj.info/api"
var kServerHost: String {
    return kDebugServer
}

let kUserChanged = Notification(name: Notification.Name("kUserChanged"), object: nil)

let kUserMakeOrder = Notification(name: Notification.Name("kUserMakeOrder"), object: nil)

//用户重新联网
let kUserReConnectedNetwork = Notification(name: Notification.Name("kUserReConnectedNetwork"), object: nil)



