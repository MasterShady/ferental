//
//  LaunchView.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

class LaunchView: BaseView {

    override func configSubviews() {
        backgroundColor = .yellow
        let grandientBgView = UIView()
        addSubview(grandientBgView)
        grandientBgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(512)
        }
        grandientBgView.backgroundColor = .gradient(colors: [.init(hexColor: "#4764F2", alpha: 0.29), .init(hexColor: "#4764F2", alpha: 0)], from: CGPoint(x: kScreenWidth/2, y: 0), to: CGPoint(x: kScreenWidth/2, y: 512), size: CGSize(width: kScreenWidth, height: 512))
        
        
    }

}
