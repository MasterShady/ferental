//
//  Constants.swift
//  StoryMaker
//
//  Created by Park on 2022/1/9.
//  Copyright © 2020 mayqiyue. All rights reserved.
//

import UIKit
import SwiftUI

struct Order{
    enum Status {
        case pendingReview
        case pendingPickup
        case completed
    }
    
    var status: Status
    var cover: String
    var title: String
    var orderDate: Date
    var orderId: String
    var startDate: Date
    var duration: Int = 7
    var rentalFee: Double = 10
    
    var endDate: Date{
        return (startDate as NSDate).addingDays(duration)!
    }
    
    var amount: Double{
        return duration * rentalFee
    }
    
    var statusTitle: String{
        switch status{
        case .pendingReview:
            return "待审核"
        case .pendingPickup:
            return "待提货"
        case .completed:
            return "已完成"
        }
    }
    
    var descTitle: String{
        switch status{
        case .pendingPickup:
            return "包裹已到达，请尽快前往指定地点提货"
        default:
            return ""
        }
    }
    
}

struct Brand{
    let name: String
    let icon: String
    let id: String
}

struct Device{
    var cover: String
    var title: String
    var cpu: String
    var gpu: String
    var screenSize: Double
    var deposit: Double
    var rentalFee: Double
    //租用次数
    var rentCount = 0
    
    var address: String = "湖北省武汉市洪山区高新二路9号,北辰光谷里1111111111111"
    var longitude: Double = 114.415359
    var latitude: Double = 30.479471
    
    var pics = [
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201809%2F29%2F20180929003248_xtsbf.jpg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673782471&t=4b1f37c073757e5c66f8849c2f487f2e",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F10wallpaper.com%2Fwallpaper%2F1366x768%2F1608%2FStephen_Curry-2016_NBA_Poster_HD_Wallpaper_1366x768.jpg&refer=http%3A%2F%2F10wallpaper.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673782471&t=de7ae7d2cd4da63221c88094a47a63ca",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg-blog.csdnimg.cn%2F20200823165302774.jfif%3Fx-oss-process%3Dimage%2Fwatermark%2Ctype_ZmFuZ3poZW5naGVpdGk%2Cshadow_10%2Ctext_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwODYwMTM3%2Csize_16%2Ccolor_FFFFFF%2Ct_70&refer=http%3A%2F%2Fimg-blog.csdnimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673782471&t=8025c1e2b6f79cafb21e47bcc8216485",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201602%2F15%2F20160215224102_aFcMv.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673782471&t=ded68d72ea290cc196283b14cba952fc"
    ]
    
}

struct Game: Equatable{
    var title: String
    var id: String?
}



extension Date{
    var ymd: String {
        return (self as NSDate).string(withFormat: "YYYY-MM-dd")!
    }
    
    var ymdhms: String{
        return (self as NSDate).string(withFormat: "YYYY-MM-dd HH:mm:ss")!
    }
}

//struct DateItem: PickerItem{
//    var title: String {
//        get {
//            return (date as NSDate).string(withFormat: "YYYY-MM-dd")!
//        }
//
//    }
//    var date: Date
//
//    init(_ date: Date) {
//        self.date = date
//    }
//}

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
    
    //"绝地求生","英雄联盟","王者荣耀","逆战","QQ飞车","枪神纪", "原神", "倩女幽魂"
    static var games: [Game] = {
        return ["绝地求生","英雄联盟","王者荣耀","逆战","QQ飞车","枪神纪", "原神", "倩女幽魂"].map {
            .init(title: $0)
        }
    }()
    
    static var dates: [Date] =  {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = DateComponents(month: 2)
        
        let futureDate = calendar.date(byAdding: dateComponents, to: currentDate)!
        return [currentDate, futureDate]
    }()
    
    static let rentDuration = [7,15,30,60,90]
    
    static let computeBrands = [
        Brand(name: "Intel", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel2", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel3", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel4", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel5", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel6", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel7", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Intel8", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel")
    ]
    
    static let phoneBrands = [
        Brand(name: "Apple", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple2", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple3", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple4", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple5", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple6", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple7", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel"),
        Brand(name: "Apple8", icon: "https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png", id: "Intel")
    ]
    
    static let mockDevice = Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "夜空铺满狼的眼睛\n刺穿天真的梦呓", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 20)
    
    static let mockDevices = [
        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 25),
        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 21),
        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 22),
        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 23),
        Device(cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", cpu: "Intel Core i9", gpu: "GeForce RTX 3080Ti", screenSize: 27, deposit: 5000, rentalFee: 24)
    ]
    
    
    static let order = Order(status: .pendingReview, cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", orderDate: Date() , orderId: "1234567", startDate:Date())
    
    static let orders = [
        Order(status: .pendingReview, cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", orderDate: Date() , orderId: "1234567", startDate:Date()),
        Order(status: .pendingPickup, cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", orderDate: Date() , orderId: "1234567", startDate:Date()),
        Order(status: .completed, cover:"https://i3.hoopchina.com.cn/newsPost/2277-9qbkanrc-upload-1657173425541-143.png" , title: "HUAWEI WATCH GT 2 Pro 联想笔记本电脑 拯救者专业电竞本锐龙8核处理器", orderDate: Date() , orderId: "1234567", startDate:Date())
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
func kCachesPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
}

func kTempPath() -> String {
    return NSTemporaryDirectory()
}

func kXcodeAppName() -> String? {
    return Bundle.main.infoDictionary?["CFBundleName"] as? String
}


let kNameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"]
