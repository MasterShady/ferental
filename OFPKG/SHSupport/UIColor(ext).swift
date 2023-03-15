//
//  UIColor(ext).swift
//  lolmTool
//
//  Created by mac on 2022/3/1.
//

import Foundation
extension UIColor {
    
    static var SWColor_main:UIColor {
        
        get{
            
            return UIColor.init(hexString: "#FE3F6D")
        }
    }
    
    /// 标题 重要文字 字体颜色
    static var SWColor_text_1:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#333333")
        }
    }
    
    ///普通级段落信息字体
    static var SWColor_text_2:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#A1A0AB")
        }
    }
    
    /// 描述 文字 标题下方
    static var SWColor_text_4:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#666666")
        }
    }
    /// 用于辅助，次要的文字信息 占位符 时间 日期等
    static var SWColor_text_3:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#D4D5DB")
        }
    }
    ///间隔线
    static var SWColor_line:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#EEEEEE")
        }
    }
    /// 全局底色
    static var SWColor_globalbackColor:UIColor{
        
        get {
            
            return UIColor.init(hexString: "#F9FAF9")
        }
    }
    
    
    /**
     渐变色 -- 返回渐变色layer
     默认：水平渐变
     */
    class func gradientColorLayer(_ colors:[Any], _ start:CGPoint = CGPoint.zero, _ end:CGPoint = CGPoint(x: 1.0, y: 0.0), _ frame:CGRect, _ radius:CGFloat = 0.0) -> CAGradientLayer {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.locations = [0, 1]
        gradient.startPoint = start
        gradient.endPoint = end
        if radius > 0 {
            gradient.cornerRadius = SCALE_HEIGTHS(value: radius)
        }
        
        return gradient
    }
}
