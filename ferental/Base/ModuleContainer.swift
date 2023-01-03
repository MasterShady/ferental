//
//  ModuleContainer.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import UIKit
import SnapKit


extension UIView {
    func capsulatedViewWithInset(_ inset: UIEdgeInsets, autoLayout: Bool = true) -> UIView{
        let view = UIView()
        view.addSubview(self)
        if(autoLayout){
            self.snp.makeConstraints { make in
                make.edges.equalTo(inset)
            }
        }else{
            view.frame = frame.inset(by: inset)
            self.center = view.center
        }
        return view
    }
}



class ModuleContainer : UIView{
    
    var stackView : UIStackView
    
    init(layoutConstraintAxis: NSLayoutConstraint.Axis = .vertical, aligment:UIStackView.Alignment = .center) {
        stackView = UIStackView()
        stackView.axis = layoutConstraintAxis
        stackView.alignment = aligment

        super.init(frame: .zero)
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func addSpacer(spacing: CGFloat, color: UIColor = .clear){
        let spacer = UIView()
        spacer.snp.makeConstraints { make in
            if stackView.axis == .vertical{
                make.height.equalTo(spacing)
            }else{
                make.width.equalTo(spacer)
            }
        }
        self.stackView.addArrangedSubview(spacer)
    }
    
    func addModule(_ module: UIView, beforeSpacing: CGFloat = 0, afterSpacing: CGFloat = 0){
        if (beforeSpacing > 0){
            self.addSpacer(spacing: beforeSpacing)
        }
        self.stackView.addArrangedSubview(module)
        
        if (afterSpacing > 0){
            self.addSpacer(spacing: afterSpacing)
        }
        
    }
}
