//
//  SWLaodingView.swift
//  DoFunNew
//
//  Created by mac on 2021/3/18.
//

import UIKit
import Lottie
import DFBaseLib

class LolmDFLoadingWidget: SWBaseView {

    public func animationStop() {
        lolp_animationView.stop()
    }
    
    override func uiConfigure() {
        self.addSubview(lolp_animationView)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: SCALE_WIDTHS(value: 50.0), height: SCALE_WIDTHS(value: 50.0))
    }
    
    
    override func myAutoLayout() {
        lolp_animationView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: SCALE_WIDTHS(value: 50.0), height: SCALE_WIDTHS(value: 50.0)))
        }
    }
    
    lazy var lolp_animationView:AnimationView = {
        let animationView = AnimationView(name: "lolm_loading")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleToFill
        animationView.play()
        return animationView
    }()
}
