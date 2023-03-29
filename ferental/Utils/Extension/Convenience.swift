//
//  Convenience.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/17.
//

import Foundation


typealias  SWjd = JSONDeserializer

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


