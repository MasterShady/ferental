//
//  HomeVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit
import YYKit
import Kingfisher


class Rental{
    enum DeviceType {
        case phone
        case computer
    }
    var toDate:Date{
        return (fromDate as NSDate).addingDays(duration)!
    }
    
    var games = [Game]()
    var fromDate = Date()
    var duration = 7 // day count
}


class HomeVC: BaseVC{
    
    var computerBtn: UIButton?
    var phoneBtn: UIButton?
    var selectedIndex = 0
    var indicator: UIImageView?
    var gameItem: SelectItemView?
    var startTimeItem: SelectItemView?
    var durationItem: SelectItemView?
    
    lazy var rentCard = RentCard()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func configSubViews() {
        view.backgroundColor = .init(hexString: "#F4F6F9")
        
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never

        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kX(375))

        }
        
        
        contentView.addSubview(self.header)
        header.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        
        contentView.addSubview(moduleContainer)
        moduleContainer.stackView.alignment = .fill
        moduleContainer.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(-3)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview()
        }
        
        moduleContainer.addModule(bannerView)
        moduleContainer.addSpacer(spacing: 10)
        moduleContainer.addModule(hotView)
        
        //self.updateUI()
    }
    
    
    // MARK: data update
    
    
    
    
    
    
    func createSelectedItem(config:(title:String,defaultValue:String?), clickHandler:(()->Void)) -> UIView{
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        let label = UILabel()
        view.addSubview(label)
        label.chain.text(config.title).font(.systemFont(ofSize: 15)).text(color: UIColorFromHex("333333"))
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        
        if let defaultValue = config.defaultValue {
            let valueLabel = UILabel()
            view.addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            }
            valueLabel.chain.text(defaultValue).font(.systemFont(ofSize: 15)).text(color: UIColorFromHex("333333"))
        }else{
            let selectBtn = UIButton()
            view.addSubview(selectBtn)
            selectBtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            }
            selectBtn.chain.image(UIImage(safeNamed: "arrow_right"), for: .normal).title(text: "请选择", for: .normal).titleColor(color: UIColorFromHex("#D4D5DB"), for: .normal)
            selectBtn.setImagePosition(.right, spacing: 4)
        }
        return view
    }
    
    
   
    
    
    lazy var bannerView: UIView = {
        let bannerView = UIView()
        let topLeftView = UIButton()
        bannerView.addSubview(topLeftView)
        topLeftView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.equalTo(topLeftView.snp.width).multipliedBy(75/170.0)
        }
        topLeftView.chain.normalBackgroundImage(.init(named: "rent_gamebook"))
        topLeftView.chain.addAction { [weak self] _ in
            self?.rentCard.setRentType(.computer, animated: false)
            self?.rentCard.popFromBottom(tapToDismiss: true)
        }
        
        
        let topRightView = UIButton()
        bannerView.addSubview(topRightView)
        topRightView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(topLeftView.snp.right).offset(7)
            make.height.equalTo(topLeftView.snp.width).multipliedBy(75/170.0)
        }
        topRightView.chain.normalBackgroundImage(.init(named: "rent_phone"))
        topRightView.chain.addAction { [weak self] _ in
            self?.rentCard.setRentType(.phone, animated: false)
            self?.rentCard.popFromBottom(tapToDismiss: true)
        }
        
        
        let bottomView = UIButton()
        bannerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topLeftView.snp.bottom).offset(7)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(bottomView.snp.width).multipliedBy(66/347.0)
            
        }
        bottomView.chain.normalBackgroundImage(.init(named: "no_lag")).addAction { [weak self ] _ in
            let loginVc = LoginVC()
            self?.navigationController?.pushViewController(loginVc, animated: true)
        }
        
        
        return bannerView
    }()
    

    lazy var moduleContainer: ModuleContainer = {
        let container = ModuleContainer(layoutConstraintAxis: .vertical, aligment: .fill)
        return container
    }()
    
    lazy var header: UIView = {
        let header = UIView()
        header.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth,height: kX(160)))
        }
        
        let gradientColor = UIColor.gradient(colors: [.white,.white.alpha(0)], from:CGPoint(x: kScreenWidth/2, y: 0), to:CGPoint(x: kScreenWidth/2, y: kX(160)), size: CGSize(width: kScreenWidth, height: kX(160)))
        header.backgroundColor = gradientColor
        
        let titleImageView = UIImageView()
        header.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(57)
            make.left.equalTo(14)
        }
        titleImageView.image = .init(named: "home_title")
        
        let stepView = UIImageView()
        header.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        stepView.image = .init(named: "home_step")
        
        return header
    }()
    
    
    lazy var hotView: UIView = {
        let view = UIView()
        let header = UIView()
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        let titleBtn = UIButton()
        titleBtn.chain.normalTitleColor(color: .black).normalTitle(text: "时下热门").font(.boldSystemFont(ofSize: 18)).normalImage(.init(named: "hot_star"))
        titleBtn.setImagePosition(.left, spacing: 3)
        header.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let moreBtn = UIButton()
        moreBtn.chain.image(.init(named: "arrow_right"), for: .normal).title(text: "查看更多", for: .normal).titleColor(color: .kTextGray, for: .normal).font(.systemFont(ofSize: 12))
        moreBtn.setImagePosition(.right, spacing: 0)
        header.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        moreBtn.addBlock(for: .touchUpInside) { _ in
            //
        }
        
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalToSuperview()

        }
        
        
        
        AppData.mockDevices.forEach { device in
            let cell = DeviceCard(frame: .zero)
            container.addArrangedSubview(cell)
            cell.device = device
            cell.chain.tap { [weak self] in
                let des = DeviceDetailVC(device: device)
                self?.navigationController?.pushViewController(des, animated: true)
            }
        }
        
        
        
        return view
    }()
    
}
