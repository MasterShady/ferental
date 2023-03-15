//
//  SWBaseView.swift
//  DoFunNew
//
//  Created by mac on 2021/3/10.
//

import UIKit

open class SWBaseView: UIView, PublicMethod {

   public  override init(frame: CGRect) {
        super.init(frame: frame)
        
        uiConfigure()
        myAutoLayout()
    }
    
    required  public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func uiConfigure() {
        
    }
    
    open func myAutoLayout() {
        
    }
    

}
