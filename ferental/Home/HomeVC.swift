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
import AEAlertView


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
    
    private var computerBtn: UIButton?
    private var phoneBtn: UIButton?
    private var selectedIndex = 0
    private var indicator: UIImageView?
    private var gameItem: SelectItemView?
    private var startTimeItem: SelectItemView?
    private var durationItem: SelectItemView?
    private var scrollView = UIScrollView()
    
    lazy var hotContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        return container
    }()
    
    var allDevices = [Device?](){
        didSet{
            updateHotDeviceView()
        }
    }
    
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
        
        
        
        
        scrollView.es.addPullToRefresh(animator: esHeader) { [weak self] in
            //self?.pullHandler?()
            self?.loadAllDevices()
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
        
        showPolicyIfNeeded()
        
    }
    
    func showPolicyIfNeeded(){
        if(!AppData.policyAgreed){
            let view = PolicyView()
            view.popFromBottom()
            view.resultHandler = { result in
                AppData.policyAgreed = result
                if !result{
                    AEAlertView.show(title: "不同意将无法使用应用功能， 确认退出应用吗？", message: nil, actions: ["直接退出","继续使用"]) { action in
                        if action.title == "直接退出"{
                            exit(0)
                        }
                    }
                }
            }
        }
    }
    
    
    override func configData() {
        loadAllDevices()
    }
    
    override func onReconnet() {
        loadAllDevices()
    }
    
    func loadAllDevices(){
        CommonService.getAllDevices(ignoreCache:true) {[weak self] devices, error in
            self?.scrollView.es.stopPullToRefresh()
            if let error = error {
                //AutoProgressHUD.showAutoHud(error.localizedDescription)
            }else{
                self?.allDevices = devices
            }
        }
    }
    
    
    func updateHotDeviceView(){
        hotContainer.removeAllSubviews()
        allDevices.reversed()[0..<min(10,allDevices.count)].forEach { device in
            if let device = device{
                let cell = DeviceCard(frame: .zero)
                hotContainer.addArrangedSubview(cell)
                cell.device = device
                cell.chain.tap { [weak self] in
                    let des = DeviceDetailVC(device: device)
                    self?.navigationController?.pushViewController(des, animated: true)
                }
            }
        }
    }
    
    
    
    func createSelectedItem(config:(title:String,defaultValue:String?), clickHandler:(()->Void)) -> UIView{
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        let label = UILabel()
        view.addSubview(label)
        label.chain.text(config.title).font(.systemFont(ofSize: 15)).text(color: UIColor(hexColor: "333333"))
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
            valueLabel.chain.text(defaultValue).font(.systemFont(ofSize: 15)).text(color: UIColor(hexColor: "333333"))
        }else{
            let selectBtn = UIButton()
            view.addSubview(selectBtn)
            selectBtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            }
            selectBtn.chain.image(UIImage(safeNamed: "arrow_right"), for: .normal).title(text: "请选择", for: .normal).titleColor(color: UIColor(hexColor: "#D4D5DB"), for: .normal)
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
            make.height.equalTo(topRightView.snp.width).multipliedBy(75/170.0)
            make.width.equalTo(topLeftView.snp.width)
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
            make.top.equalTo(kX(57))
            make.left.equalTo(kX(14))
        }
        titleImageView.image = .init(named: "home_title")
        
        let stepView = UIImageView()
        header.addSubview(stepView)
        stepView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(kX(18))
            make.size.equalTo(CGSize(width: kX(347), height: kX(32)))
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
        
        moreBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
//                let vc = DeviceListVC(deviceList:self.allDevices.compactMap {$0})
//                vc.refreshHandler = {[weak self, weak vc] completedHandler in
//                    CommonService.getAllDevices(ignoreCache:true) {[weak self] devices, error in
//                        if (error == nil){
//                            vc?.reloadDevices(devices: devices.reversed())
//                        }else{
//                            vc?.reloadFailed()
//                        }
//                    }
//                }
            let vc = DeviceListVC2(deviceList: [])
            
                self.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(hotContainer)
        hotContainer.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(400)
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalToSuperview()

        }

        return view
    }()
    
}
