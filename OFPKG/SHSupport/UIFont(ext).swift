//
//  UIFont(ext).swift
//  lolmTool
//
//  Created by mac on 2022/3/1.
//

import Foundation


extension UIFont {
    
    static func lolmf_Font(_ size:CGFloat,bold:Bool = false,chinese:Bool = true) -> UIFont {
        
        let fontName = chinese ? "PingFang SC":"DIN Alternate"
        if bold == false  {
            
            return UIFont.init(name: fontName, size: size * BASE_WIDTH_SCALE) ?? UIFont.systemFont(ofSize: size * BASE_WIDTH_SCALE)
        }else{
            
            return UIFont.boldSystemFont(ofSize: size * BASE_WIDTH_SCALE)
        }
        
    }
}
