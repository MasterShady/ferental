//
//  UIColorExt.swift
//  Dylan.Lee
//
//  Created by Dylan on 2017/9/22.
//  Copyright © 2017年 Dylan.Lee. All rights reserved.
//

import UIKit

// MARK: 通过16进制初始化UIColor
public extension UIColor {
    
    convenience init(numberColor: Int, alpha: CGFloat = 1.0) {
        self.init(hexColor: String(numberColor, radix: 16), alpha: alpha)
    }
    
    convenience init(hexColor: String, alpha: CGFloat = 1.0) {
        var hex = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        if hex.hasPrefix("0x") || hex.hasPrefix(("0X")) {
            hex.removeSubrange((hex.startIndex ..< hex.index(hex.startIndex, offsetBy: 2)))
        }
        
        guard let hexNum = Int(hex, radix: 16) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        
        switch hex.count {
        case 3:
            self.init(red: CGFloat(((hexNum & 0xF00) >> 8).duplicate4bits) / 255.0,
                      green: CGFloat(((hexNum & 0x0F0) >> 4).duplicate4bits) / 255.0,
                      blue: CGFloat((hexNum & 0x00F).duplicate4bits) / 255.0,
                      alpha: alpha)
        case 6:
            self.init(red: CGFloat((hexNum & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((hexNum & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat((hexNum & 0x0000FF) >> 0) / 255.0,
                      alpha: alpha)
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    class func gradient(fromColors colors: [UIColor], size: CGSize) -> UIColor{
        return self.gradient(colors: colors, from: .init(x: 0, y: 0), to: .init(x: size.width, y: size.height), size: size)
    }
    
    
    class func gradient(colors: [UIColor], from: CGPoint, to: CGPoint, size: CGSize) -> UIColor{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        var cgColors: [AnyHashable] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        var gradient: CGGradient? = nil
        
        if let aColors = cgColors as CFArray? {
            gradient = CGGradient(colorsSpace: colorspace, colors: aColors, locations: nil)
        }
        
        if let gradient = gradient {
            context?.drawLinearGradient(gradient, start: from, end: to, options: [])
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}

private extension Int {
    var duplicate4bits: Int {
        return self << 4 + self
    }
}

extension UIColor {
    
}
