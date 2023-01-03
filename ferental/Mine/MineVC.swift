//
//  MineVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import Kingfisher
import AEAlertView

class MineVC: BaseVC{
    
    private var orderView = MyOrderView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func configSubViews() {
        let order = AppData.orders[Int.random(in: 0...2)]
        
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth,height: kX(198)))
            make.top.left.equalToSuperview()
        }
        
        
        view.addSubview(orderView)
        
        orderView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(-25)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        orderView.order = order
        orderView.tapMoreHandler = { [weak self] in
            self?.tabBarController?.selectedIndex = 2
        }
        
        let itemsView = UIView()
        view.addSubview(itemsView)
        itemsView.snp.makeConstraints { make in
            make.top.equalTo(orderView.snp.bottom).offset(8)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        itemsView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let itemStackView = UIStackView()
        itemsView.addSubview(itemStackView)
        itemStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        itemStackView.axis = .vertical
        itemStackView.spacing = 0
    
        let list = [
            ("意见反馈", "feedback", { [weak self] in
                let vc = FeedbackVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
            ("清除缓存", "clear_cache", {
                AEAlertView.show(title: nil, message: "确定清除所有缓存吗?", actions: ["取消","确定"]) { action in
                    if action.title == "确定"{
                        ImageCache.default.clearMemoryCache()
                        ImageCache.default.clearDiskCache()
                        AutoProgressHUD.showAutoHud("清除缓存成功!")
                    }
                }
            }),
            ("关于我们", "about_us", { [weak self] in
                let vc = AboutUsVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
        ]
        
        for (title,icon,block) in list{
            let item = UIView()
            item.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            
            let iconView = UIImageView()
            item.addSubview(iconView)
            iconView.snp.makeConstraints { make in
                make.left.equalTo(14)
                make.centerY.equalToSuperview()
            }
            iconView.image = .init(named: icon)
            
            let titleLabel = UILabel()
            item.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(9)
                make.centerY.equalToSuperview()
            }
            titleLabel.chain.font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack).text(title)
            
            let rightIconView = UIImageView()
            item.addSubview(rightIconView)
            rightIconView.snp.makeConstraints { make in
                make.right.equalTo(-14)
                make.centerY.equalToSuperview()
            }
            rightIconView.image = .init(named: "arrow_right")
            
            item.chain.tap {
                block()
            }
            itemStackView.addArrangedSubview(item)
            
        }
        
        let slogan = UIImageView()
        view.addSubview(slogan)
        slogan.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.centerX.equalToSuperview()
        }
        slogan.image = .init(named: "slogan")
        
    }
    
    override func configData() {
        updateUserInfo()
    }
    
    func updateUserInfo(){
        userNameLabel.text = "userName"
        userIconView.kf.setImage(with: URL(string: ""))
    }
    
    
    var userIconView = UIImageView()
    
    var userNameLabel = UILabel()
    
    lazy var header: UIView = {
        let header = UIImageView()
        header.image = UIImage(named: "mine_header")
        header.isUserInteractionEnabled = true
        
        header.addSubview(userIconView)
        userIconView.snp.makeConstraints { make in
            make.top.equalTo(kX(88))
            make.left.equalTo(14)
            make.width.height.equalTo(62)
        }
        userIconView.chain.corner(radius: 31).clipsToBounds(true).image(.init(named: "user_icon"))
        
        
        
        header.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userIconView.snp.right).offset(10)
            make.centerY.equalTo(userIconView)
        }
        userNameLabel.chain.text(color: .kTextBlack).font(.boldSystemFont(ofSize: 20)).text("租小易")
        
        let headsetBtn = UIButton()
        headsetBtn.sy_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        header.addSubview(headsetBtn)
        headsetBtn.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight + 4)
            make.right.equalTo(-14)
        }
        headsetBtn.chain.normalImage(.init(named: "headset")).tap {
            let phoneNumber = "1234567890"
            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }

        return header
    }()
    
}

