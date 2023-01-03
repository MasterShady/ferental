//
//  Colors.swift
//  ReCamV5
//
//  Created by Park on 2020/3/20.
//  Copyright © 2020 Wade. All rights reserved.
//

import UIKit

func UIColorFromHex(_ color: String, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor.init(hex: color, alpha: alpha)
}

func UIColorFromRGB(_ red: Int,_ green: Int,_ blue: Int) -> UIColor {
    return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
}

func UIColorFromRGBA(_ red: Int,_ green: Int,_ blue: Int,_ alpha: CGFloat) -> UIColor {
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var rHex = hex
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            rHex = String(hex[start...])
        }
        
        let scanner = Scanner(string: rHex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Int(r), green: Int(g), blue: Int(b), alpha: alpha)
    }
    
    static func random() -> UIColor {
        return UIColorFromRGB(Int(arc4random())%255, Int(arc4random())%255, Int(arc4random())%255)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}
