//
//  lolm_base_view.swift
//  lolmTool
//
//  Created by mac on 2022/3/4.
//

import Foundation
import DFBaseLib

open class lolm_base_widget: UIView, PublicMethod {

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
