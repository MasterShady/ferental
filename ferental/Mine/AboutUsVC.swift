//
//  AboutUsVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

class AboutUsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBgAlpha = 0
        self.edgesForExtendedLayout = .top
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        setBackTitle("关于我们")
        
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: kNavBarMaxY + 4, left: 14, bottom: 14, right: 14))
        }
        container.chain.backgroundColor(.white).corner(radius: 6)
        
        let imageView = UIImageView()
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }
        imageView.image = .init(named: "logo_with_slogan")
        
    }
    


}
