//
//  Loldf_hmCloud_loadingView.swift
//  lolmTool
//
//  Created by mac on 2022/4/25.
//

import Foundation
import Lottie
import DFToGameLib

//横屏布局
class Loldf_hmCloud_loadingView: UIView {
    
    static func loadingView() ->Loldf_hmCloud_loadingView {
         
        let view  = Loldf_hmCloud_loadingView.init(frame: UIScreen.main.bounds)
        
        view.uiConfigure()
        
        return view
    
    }
    
    lazy var lolmp_animationView:AnimationView = {
        
        let view = AnimationView.init(name: "quick_login_loading")
        
        view.contentMode = .scaleAspectFill
        
        view.loopMode = .loop
        
        return view
    }()
    
    func uiConfigure()  {
        
         addSubview(lolmp_animationView)
         lolmp_animationView.snp.makeConstraints { make in
            
             make.center.equalTo(self)
             make.size.equalTo(CGSize(width: SCALE_HEIGTHS(value: 208), height: SCALE_HEIGTHS(value: 208)))
         }
        
         play()
    }
}
extension Loldf_hmCloud_loadingView:SWLoginGameLoadingViewProtocol{
    
    
    func play() {
        
        lolmp_animationView.play()
    }
    
    func suspend() {
        
        lolmp_animationView.pause()
    }
    
    func hidden() {
         
        
        self.removeFromSuperview()
        
    }
    
    func show() {
       
         
        
    }
    
    
    
}
