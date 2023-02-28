//
//  MyOrderView.swift
//  ferental
//
//  Created by 刘思源 on 2023/1/3.
//

import Foundation
import SnapKit

class MyOrderView : BaseView{
    
    var tapMoreHandler : Block?
    
    var order : Order? {
        didSet{
            updateUI()
        }
    }
    
    private var coverView = UIImageView()
    private var orderStatusLabel = UILabel()
    private var descLabel = UILabel()
    
    private var heightConstraint : Constraint?
    
    
    override func configSubviews() {
        self.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let orderLabel = UILabel()
        self.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { make in
            make.left.top.equalTo(14)
        }
        
        orderLabel.chain.font(.boldSystemFont(ofSize: 16)).text(color: .kTextBlack).text("我的订单")
        
        let btn = UIButton()
        self.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalTo(orderLabel)
        }
        btn.chain.normalTitle(text: "查看更多").normalImage(.init(named: "arrow_right")).font(.systemFont(ofSize: 12)).normalTitleColor(color: .init(hexColor: "#A1A0AB"))
        btn.setImagePosition(.right, spacing: 3)
        
        btn.chain.addAction(action: { [weak self] _ in
            if let self = self{
                self.tapMoreHandler?()
            }
        })
        
        self.snp.makeConstraints { make in
            self.heightConstraint =  make.height.equalTo(50).constraint
        }
        
        
    }
    
    lazy var orderCard: UIView = {
        
        
        let orderCard = UIView()
        let width = kScreenWidth - 14 * 2 - 14 * 2
        orderCard.backgroundColor = .gradient(colors: [.init(hexColor: "#EFF7FF"), .init(hexColor: "#F1FFF3")], from: CGPoint(x: 0, y: 34), to: CGPoint(x: width, y: 34), size: CGSize(width: width, height: 68))
        
        
        
        orderCard.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.left.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(coverView.snp.height)
        }
        coverView.contentMode = .scaleAspectFit
        
        
        
        orderCard.addSubview(orderStatusLabel)
        orderStatusLabel.snp.makeConstraints { make in
            make.left.equalTo(coverView.snp.right).offset(10)
            make.top.equalTo(14)
        }
        orderStatusLabel.chain.text(color: .kDeepBlack).font(.boldSystemFont(ofSize: 14))
        
        
        orderCard.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(coverView.snp.right).offset(10)
            make.top.equalTo(orderStatusLabel.snp.bottom).offset(4)
        }
        descLabel.chain.text(color: .init(hexColor: "#878787")).font(.systemFont(ofSize: 12))
        
        return orderCard
    }()
    
    
    func updateUI(){
        if let order = order{
            coverView.kf.setImage(with: URL(subPath: order.cover))
            orderStatusLabel.text = order.statusTitle
            descLabel.text = order.descTitle
            
            self.addSubview(orderCard)
            orderCard.snp.makeConstraints { make in
                make.top.equalTo(48)
                make.left.equalTo(14)
                make.right.equalTo(-14)
                make.height.equalTo(68)
            }
            heightConstraint?.update(offset:139)
            
        }else{
            orderCard.removeFromSuperview()
            heightConstraint?.update(offset:50)
        }
    }
}
