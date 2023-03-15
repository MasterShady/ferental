//
//  PublicMethodProtocol.swift
//  DoFunNew
//
//  Created by mac on 2021/2/4.
//

import UIKit


@objc public protocol PublicMethod {
    
    /*
     UI控件写在此方法中
     */
    func uiConfigure()
    
    /*
     布局代码写在此方法中
     */
    func myAutoLayout()
    
    @objc optional func dataRequest()
    
}
