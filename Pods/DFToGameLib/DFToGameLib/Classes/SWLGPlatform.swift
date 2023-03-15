//
//  SWLoginGameWX.swift
//  DoFunNew
//
//  Created by mac on 2021/6/2.
//

import Foundation



public protocol SWLoginGamePlatformProtocol {
    
    func login(withInfo:SWActInfo)
    
    func openApp(withUrl:String,withHandler:((Bool)->())?)
    
    func taskCancel() 
    
    var loadingView:SWLoginGameLoadingViewProtocol?{get set}
}

 extension SWLoginGamePlatformProtocol {
    
    
    func openApp(withUrl:String,withHandler:((Bool)->())? = nil) {
        
        guard let url = URL(string: withUrl) else {
            
            withHandler?(false)
            return
        }
        
        DispatchQueue.main.async {
            
            if UIApplication.shared.canOpenURL(url) {
                
                withHandler?(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
     
            }else{
                
                   withHandler?(false)
            }
        }
    }
}


