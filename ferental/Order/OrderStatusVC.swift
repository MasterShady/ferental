//
//  OrderStatusVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/19.
//

import UIKit

class OrderStatusVC: BaseVC {
    
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
        self.edgesForExtendedLayout = .top
        self.extendedLayoutIncludesOpaqueBars = true
        setBackTitle("订单详情") { [weak self] in
            self?.popToController(withBlackList: [
                "\(kNameSpage).OrderCompletedVC"
            ])
        }
        
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        
        let statusView = UIView()
        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarMaxY + 3)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(69)
        }
        statusView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let statusLabel = UILabel()
        statusView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.left.equalTo(14)
        }
        statusLabel.chain.font(.boldSystemFont(ofSize: 16)).text(color: .kDeepBlack)
        
        let statusDescLabel = UILabel()
        statusView.addSubview(statusDescLabel)
        statusDescLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(6)
            make.left.equalTo(14)
        }
        statusDescLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "878787"))
        
        
        let statusIconView = UIImageView()
        view.addSubview(statusIconView)
        statusIconView.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        

        
        
        switch order.status{
        case .completed:
            statusLabel.text = "已完成"
            statusDescLabel.text = ""
        case .pendingPickup:
            statusLabel.text = "待提货"
            statusDescLabel.text = "包裹已到达，请尽快前往指定地点提货"
            let hintView = UIView()
            statusView.insertSubview(hintView, belowSubview: statusLabel)
            hintView.snp.makeConstraints { make in
                make.bottom.equalTo(statusLabel)
                make.centerX.equalTo(statusLabel)
                make.size.equalTo(CGSize(width: 48, height: 18))
            }
            hintView.backgroundColor = .kthemeColor
        case .pendingReview:
            statusLabel.text = "待审核"
            statusDescLabel.text = ""
        }
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom).offset(9)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        contentView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let cardView = UIView()
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(102)
        }
        
        let cover = UIImageView()
        cardView.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.size.equalTo(CGSize(width: 74, height: 74))
        }
        cover.kf.setImage(with: URL(subPath: order.cover))
        cover.backgroundColor = .kExLightGray
        
        let titleLabel = UILabel()
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cover)
            make.left.equalTo(cover.snp.right).offset(17)
            make.right.equalTo(-14)
        }
        titleLabel.chain.font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack).numberOfLines(0).text(order.title)
        
        let feeLabel = UILabel()
        cardView.addSubview(feeLabel)
        feeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cover)
            make.left.equalTo(cover.snp.right).offset(17)
        }
        
        let raw = String(format:"¥%.2f/天",order.rentalFee)
        let attrText = NSMutableAttributedString(string: raw, attributes: [
            .foregroundColor : UIColor(hexColor: "#111111"),
            .font : UIFont.boldSystemFont(ofSize: 18)
        ])
        
        attrText.setAttributes([
            .foregroundColor : UIColor(hexColor: "#111111"),
            .font : UIFont.boldSystemFont(ofSize: 10)
        ], range: (raw as NSString).range(of: "¥"))
        
        attrText.setAttributes([
            .foregroundColor : UIColor(hexColor: "#585960"),
            .font : UIFont.boldSystemFont(ofSize: 10)
        ], range: (raw as NSString).range(of: "/天"))
        
        feeLabel.attributedText = attrText
        
        cardView.size = CGSize(width: kScreenWidth - 28, height: 102)
        cardView.addBorder(with: .init(hexColor: "dedede"), width: 0.5, borderType: .bottom)
        

        
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            
            make.bottom.equalTo(-14)
        }
        stackView.axis = .vertical
        stackView.spacing = 12

        
        let orderIdItem = ConfirmItemView(title: "订单编号：", value: String(order.id))
        stackView.addArrangedSubview(orderIdItem)
        
        let startTimeItem = ConfirmItemView(title: "起租时间：", value: order.startDate.ymd)
        stackView.addArrangedSubview(startTimeItem)
        
        let durationItem = ConfirmItemView(title: "租赁时长：", value: String(format: "%zd天", order.duration))
        stackView.addArrangedSubview(durationItem)
        
        let endTimeItem = ConfirmItemView(title: "到期时间：", value: order.endDate.ymd)
        stackView.addArrangedSubview(endTimeItem)
        
        let orderAmountItem = ConfirmItemView(title: "订单金额：", value: String(format: "¥%.2f", order.amount))
        
        stackView.addArrangedSubview(orderAmountItem)
        
        let orderTimeItem = ConfirmItemView(title: "下单时间：", value: order.createdDate.ymdhms)
        stackView.addArrangedSubview(orderTimeItem)
        
        let slogan = UIImageView()
        
        view.addSubview(slogan)
        slogan.snp.makeConstraints { make in
            make.bottom.equalTo(-34 - kBottomSafeInset)
            make.centerX.equalToSuperview()
        }
        slogan.image = .init(named: "slogan")
    }
    
    
    

}
