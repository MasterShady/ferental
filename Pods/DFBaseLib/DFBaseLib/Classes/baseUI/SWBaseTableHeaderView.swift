//
//  SWBaseTableHeaderView.swift
//  DoFunNew
//
//  Created by mac on 2021/3/30.
//

import UIKit

open class SWBaseTableHeaderView: UITableViewHeaderFooterView, PublicMethod {

   public  override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
