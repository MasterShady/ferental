//
//  MineVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import Kingfisher
import AEAlertView
import UIKit

class MineVC: BaseVC{
    
    private var orderView = MyOrderView()
    
    private var logoffBtn : UIButton!
    
    private var logoutItem : UIView = {
        let item = UIView()
        item.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        item.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        let iconView = UIImageView()
        item.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        iconView.image = .init(named: "exit")
        
        let titleLabel = UILabel()
        item.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(9)
            make.centerY.equalToSuperview()
        }
        titleLabel.chain.font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack).text("退出登录")
        item.chain.tap {
            AEAlertView.show(title: nil, message: "确定要退出登录吗?", actions: ["取消","确定"]) { action in
                if action.title == "确定"{
                    UserStore.currentUser = nil
                }
            }
        }
        
        return item
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getNewestOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func configSubViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: kUserChanged.name, object: nil)
        
        
        
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

        orderView.tapMoreHandler = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
        orderView.chain.tap { [weak self] in
            if let self = self, let order = self.orderView.order{
                let vc = OrderStatusVC(order: order)
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        
        view.addSubview(logoutItem)
        logoutItem.snp.makeConstraints { make in
            make.top.equalTo(itemsView.snp.bottom).offset(8)
            make.left.right.equalTo(itemsView)
        }
        
        let bottomView = UIStackView()
        bottomView.axis = .vertical
        bottomView.spacing = 10
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.centerX.equalToSuperview()

        }
        
        
        let slogan = UIImageView()
        slogan.image = .init(named: "slogan")
        bottomView.addArrangedSubview(slogan)
        
        logoffBtn = UIButton()
        logoffBtn.chain.font(.systemFont(ofSize: 12)).normalTitleColor(color: .kLightGray).normalTitle(text:"注 销").addAction { [weak self] _ in
            let vc = LogoffVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        bottomView.addArrangedSubview(logoffBtn)

        
        updateUserInfo()
    }
    

    
    
    
    
    @objc func updateUserInfo(){
        //getNewestOrder()
        
        if UserStore.isLogin{
            getNewestOrder()
            userNameLabel.text = UserStore.currentUser!.name!
            logoutItem.isHidden = false
            userNameLabel.isUserInteractionEnabled = false
            logoffBtn.isHidden = false
            
        }else{
            userNameLabel.text = "请登录/注册"
            userNameLabel.isUserInteractionEnabled = true
            logoutItem.isHidden = true
            logoffBtn.isHidden = true
        }
    }
    
    
    func getNewestOrder(){
        if UserStore.isLogin{
            orderService.request(.getAllOrders) { result in
                result.hj_mapArray(Order.self, atKeyPath: "data") {[weak self] result in
                    switch result{
                    case .success((let orders, _)):
                        self?.orderView.order = orders.last
                    case .failure(let error):
                        AutoProgressHUD.showError(error)
                    }
                }
            }
        }else{
            self.orderView.order = nil
        }
    }
    
    var userIconView = UIImageView()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.chain.tap { [weak self] in
            let vc = LoginVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return userNameLabel
    }()
    
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
        userNameLabel.chain.text(color: .kTextBlack).font(.boldSystemFont(ofSize: 20))
        
        let headsetBtn = UIButton()
        headsetBtn.sy_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        header.addSubview(headsetBtn)
        headsetBtn.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight + 4)
            make.right.equalTo(-14)
        }
        headsetBtn.chain.normalImage(.init(named: "headset")).tap {
            let phoneNumber = "17735625896"
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

