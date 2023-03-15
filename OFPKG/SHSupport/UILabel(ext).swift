//
//  UILabel(ext).swift
//  lolmTool
//
//  Created by mac on 2022/3/1.
//

import Foundation

extension UILabel {
    
    static func lol_getLaberl(content:String,fontsize:CGFloat,color:UIColor = UIColor.init(hexString: "#333333"),isbold:Bool = false) ->UILabel {
        
        
         
        let label = UILabel.init(frame: CGRect.zero)
        
        label.text = content
        
        label.font = UIFont.lolmf_Font(fontsize, bold: isbold)
        
        label.textColor = color
        
    
        return label
    }
}

