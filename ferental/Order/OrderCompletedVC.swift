//
//  OrderCompletedVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/19.
//

import UIKit

class OrderCompletedVC: BaseVC {
    
    let order: Order
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func configSubViews() {
        self.navBarBgAlpha = 0
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: kNavBarMaxY + 4, left: 14, bottom: 0, right: 14))
        }
        contentView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
        }
        imageView.image = .init(named: "commit_success")
        
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        titleLabel.chain.font(.boldSystemFont(ofSize: 18)).text(color: .kDeepBlack).text("订单提交成功")
        
        let desLabel = UILabel()
        contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            
        }
        desLabel.chain.font(.systemFont(ofSize: 15)).text(color: .init(hexColor: "999999")).textAlignment(.center).numberOfLines(0).text("您已提交申请成功，请保持电话顺畅，\n耐心等待我们的通知，届时您可至自提点提货")
        
        let checkBtn = UIButton()
        contentView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { make in
            make.top.equalTo(desLabel.snp.bottom).offset(37)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 180, height: 44))
        }
        checkBtn.chain.backgroundColor(.kthemeColor).normalTitle(text: "查看订单").font(.boldSystemFont(ofSize: 16)).corner(radius: 6).clipsToBounds(true).normalTitleColor(color: .kTextBlack)
        checkBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            guard let self = self else {return}
            let orderVC = OrderStatusVC(order:self.order)
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
        
        setBackTitle("") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
