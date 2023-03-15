//
//  UIColor+hexColor.swift
//  DoFunNew
//
//  Created by mac on 2021/2/4.
//

import UIKit


public extension UIColor {
    // Hex String -> UIColor
        convenience init(hexString: String) {
            let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            let scanner = Scanner(string: hexString)
             
            if hexString.hasPrefix("#") {
                scanner.scanLocation = 1
            }
             
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
             
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
             
            let red   = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue  = CGFloat(b) / 255.0
             
            self.init(red: red, green: green, blue: blue, alpha: 1)
        }
         
        // UIColor -> Hex String
        var hexString: String? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
             
            let multiplier = CGFloat(255.999999)
             
            guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
             
            if alpha == 1.0 {
                return String(
                    format: "#%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier)
                )
            }
            else {
                return String(
                    format: "#%02lX%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier),
                    Int(alpha * multiplier)
                )
            }
        }
}
public extension UIColor {
    
    /// 根据十六进制字符串获取颜色
    /// - Parameter hexString: 十六进制颜色字符串
    /// - Returns: 返回颜色值
    class func hexColor(_ hexString: String) -> UIColor {
        return hexColor(hexString, alpha:1.0)
    }
    
    
    /// 根据带透明度的十六进制字符串获取颜色
    /// - Parameters:
    ///   - hexString: 十六进制颜色字符串
    ///   - alpha: 透明度
    /// - Returns: 返回颜色值
    class func hexColor(_ hexString: String, alpha: CGFloat) -> UIColor {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
