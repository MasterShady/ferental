//
//  CartComfirmVC.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/29.
//

import Foundation


class CartComfirmVC: BaseVC{
    
    let totolPriceLabel = UILabel()
    
    let cartItems : [CartItem]
    
    var fromDate = Date()
    var duration = 7
    
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configSubViews() {
        self.title = "立即下单"
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            //make.edges.equalToSuperview()
            make.left.right.top.equalToSuperview()
//            make.bottom.equalTo(-60)
        }
        
        let container = ModuleContainer(layoutConstraintAxis: .vertical, aligment: .fill)
        scrollView.addSubview(container)
        container.snp.makeConstraints { make in
            //make.edges.equalToSuperview()
            make.top.bottom.equalTo(0)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.width.equalTo(kScreenWidth - 28)
        }
        
        cartItems.forEach { item in
            let itemView = UIView()
            itemView.backgroundColor = .white
            let card = DeviceCard()
            card.device = item.device
            itemView.addSubview(card)
            card.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            
            let countTitleLabel = UILabel()
            itemView.addSubview(countTitleLabel)
            countTitleLabel.snp.makeConstraints { make in
                make.left.equalTo(14)
                make.top.equalTo(card.snp.bottom).offset(5)
                make.bottom.equalTo(-12)
            }
            countTitleLabel.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14)).text("租赁数量")
            
            
            let countValueLabel = UILabel()
            itemView.addSubview(countValueLabel)
            countValueLabel.snp.makeConstraints { make in
                make.right.equalTo(-14)
                make.top.equalTo(countTitleLabel)
            }
            countValueLabel.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14)).text(String(item.count))
            
            itemView.chain.corner(radius: 6).shadow(color: .kLightGray).shadow(offset: .init(width: 0, height: 0)).shadow(opacity: 0.5)
            
            container.addModule(itemView,beforeSpacing: 12)
            
        }
        
        container.addModule(startTimeItem, beforeSpacing: 20)
        container.addModule(durationItem, beforeSpacing: 20)
        container.addModule(endTimeItem, beforeSpacing: 20)
        
        let rentInfoLabel = UILabel()
        container.addModule(rentInfoLabel, beforeSpacing: 40)
        
        let rentInfo = "租赁流程\n1、线上选购心仪商品\n2、选择合适的租赁时间\n3、提交租赁预约，等待客服联系（48小时内会跟您联系）\n4、线下提货or线上物流发货\n5、确认到货后开始计算租期（已签收时间开始计算）\n如有任何问题请随时拨打客服热线：17735625896"
        rentInfoLabel.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14)).numberOfLines(0)
        let attrInfo = NSMutableAttributedString(rentInfo, color: .kTextBlack, font: .systemFont(ofSize: 14))
        let range = (rentInfo as NSString).range(of: "租赁流程")
//        attrInfo.setAttributes([
//            .font: UIFont.boldSystemFont(ofSize: 16),
//        ], range: range)
        attrInfo.alignment = .center
        attrInfo.setAlignment(.center, range: range)
        attrInfo.setFont(.boldSystemFont(ofSize: 14), range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        attrInfo.paragraphStyle = paragraphStyle
        rentInfoLabel.attributedText = attrInfo
        
        let confirmView = UIView()
        confirmView.backgroundColor = .white
        view.addSubview(confirmView)
        confirmView.snp.makeConstraints { make in
            make.height.equalTo(60 + kBottomSafeInset)
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        
        confirmView.addSubview(totolPriceLabel)
        totolPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(30)
            make.left.equalTo(14)
        }
        totolPriceLabel.chain.font(.boldSystemFont(ofSize: 16)).text(color: .kTextBlack)
        
        let confirmBtn = UIButton()
        confirmView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 44))
            make.right.equalTo(-14)
            make.centerY.equalTo(30)
        }
        confirmBtn.chain.normalTitle(text: "确认下单").font(.boldSystemFont(ofSize: 14)).normalTitleColor(color: .kTextBlack).backgroundColor(.kthemeColor).corner(radius: 8).clipsToBounds(true)
        
        confirmBtn.addTarget(self, action: #selector(confirmOrder), for: .touchUpInside)
        
        updateUI()
    }
    
    
    @objc func confirmOrder(){
        if !UserStore.isLogin{
            let vc = LoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        AutoProgressHUD.showHud("订单处理中...")
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let group = DispatchGroup()
            var orders = [Order]()
            self.cartItems.forEach { item in
                CartManager.cartItems.remove(item)
                for _ in 0 ..< item.count{
                    group.enter()
                    orderService.request(.makeOrder(deviceId: item.device.id, dayCount: self.duration, totalPrice: item.device.price * self.duration)) { result in
                        result.hj_map2(Order.self) { response, error in
                            if let response = response{
                                let order = response.decodedObj!
                                orders.append(order)
                            }
                        }
                        
                        result.hj_map(Order.self, atKeyPath: "data") { result in
                            group.leave()
                        }
                    }
                }
            }
            
            group.notify(queue: .main) {
                AutoProgressHUD.hideHud()
                if orders.count == 1{
                    let vc = OrderCompletedVC(order:orders[0])
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = OrderCompletedVC(order:nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
                
            }
        }
        
        
    }
    
    
    func updateUI(){
        self.startTimeItem.value = fromDate.ymd
        self.durationItem.value = String(duration) + "天"
        self.endTimeItem.value = (fromDate as NSDate).addingDays(duration)!.ymd
        
        let total = cartItems.reduce(0.0) { partialResult, item in
            partialResult + item.device.price * item.count * duration
        }
        
        totolPriceLabel.text = String(format: "总计: ¥%.2f", total)
    }
    
    
    private lazy var startTimeItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "起租时间")
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        item.selectHandler = { [weak self] in
            self?.datePicker.popFromBottom()
        }
        return item
    }()
    
    
    private lazy var durationItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "租赁时长")
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        item.selectHandler = { [weak self] in
            self?.durationPicker.popFromBottom()
        }
        return item
    }()
    
    private lazy var endTimeItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "到期时间")
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        return item
    }()
    
    
    
    lazy var datePicker: DatePicker = {
        let title = NSMutableAttributedString(string:"选择起租时间")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
        
        
        let fromDate = Date()
        let toDate = fromDate.addingTimeInterval(86400 * 60.0)
        let picker = DatePicker(title: title, fromDate: fromDate, toDate: toDate) { [weak self] date in
            GEPopTool.dimssPopView()
            self?.fromDate = date
//            self?.rental.fromDate = date
            self?.updateUI()
        }
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 280))
        };

        return picker
    }()
    
    
    lazy var durationPicker: SinglePicker<Int> = {
        let title = NSMutableAttributedString(string:"选择租赁时常")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
    
        
        let picker = SinglePicker<Int>(title: title, data: AppData.rentDuration) { [weak self ] duration in
            GEPopTool.dimssPopView()
            self?.duration = duration
//            self?.rental.duration = duration
            self?.updateUI()
        } titleForDatum: { duration in
            return String(duration) + "天"
        }
        
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 280))
        };

        return picker

    }()
    
}
