//
//  SWBaseReusableView.swift
//  DoFunNew
//
//  Created by mac on 2021/3/29.
//

import UIKit

open class SWBaseReusableView: UICollectionReusableView, PublicMethod {
        
   public override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfigure()
        myAutoLayout()
    }
    
   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   open func uiConfigure() {
        
    }
    
   open func myAutoLayout() {
        
    }
    
}
