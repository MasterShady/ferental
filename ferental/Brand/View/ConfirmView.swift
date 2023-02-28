//
//  ConfirmView.swift
//  ferental
//
//  Created by 刘思源 on 2022/12/28.
//

import Foundation

class ConfirmView: BaseView{
    
    var confirmHandler: Block?
    var didUpdateRental: ((Rental)->())?
    var selectStartTimeHandler: Block?
    var selectDurationHandler: Block?
    
    var device: Device
    var rental: Rental{
        didSet{
            updateUI()
        }
    }
    
    init(device: Device, rental: Rental) {
        self.device = device
        self.rental = rental
        defer{
            self.rental = rental
        }
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configSubviews() {
        backgroundColor = .white
        let header = UILabel()
        addSubview(header)
        header.snp.makeConstraints { make in
            make.height.equalTo(53)
            make.left.right.top.equalToSuperview()
        }
        header.size = CGSize(width: kScreenWidth, height: 53)
        header.chain.font(.systemFont(ofSize: 16)).text(color: .kTextBlack).text("确认订单").textAlignment(.center).userInteractionEnabled(true)
        header.addCornerRect(with: [.topLeft, .topRight], radius: 12)
        header.addBorder(with: .kSepLineColor, width: 1, borderType: .bottom)
        
        let cancelBtn = UIButton()
        header.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(22)
        }
        cancelBtn.chain.font(.systemFont(ofSize: 14)).normalTitleColor(color: .kTextBlack).normalTitle(text: "取消")
        cancelBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.popDismiss()
        }
        
        let content = UIView()
        addSubview(content)
        content.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            //make.height.equalTo(341 + kBottomSafeInset)
        }
        
        let deviceCard = DeviceCard(frame: .zero)
        deviceCard.backgroundColor = .init(hexColor: "#F5F6F8")
        content.addSubview(deviceCard)
    
        deviceCard.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(content)
            make.height.equalTo(133)
        }
        deviceCard.device = device

        let sheetView = ModuleContainer(layoutConstraintAxis: .vertical, aligment: .fill)
        content.addSubview(sheetView)
        sheetView.snp.makeConstraints { make in
            make.top.equalTo(deviceCard.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }

        sheetView.addModule(startTimeItem)
        sheetView.addModule(durationItem,beforeSpacing: 18)
        sheetView.addModule(endTimeItem,beforeSpacing: 18)
        sheetView.addModule(amountItem,beforeSpacing: 18)

        let confirmBtn = UIButton()
        content.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 347, height: 44))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10 - kBottomSafeInset)
        }
        confirmBtn.chain.normalTitleColor(color: .kTextBlack).normalTitle(text: "提交申请").font(.boldSystemFont(ofSize: 16)).backgroundColor(.kthemeColor).corner(radius: 3).clipsToBounds(true)
        confirmBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.confirmHandler?()
        }
        
        
    }
    
    func updateUI(){
        self.startTimeItem.value = rental.fromDate.ymd
        if (rental.duration > 0) {
            self.durationItem.value = String(rental.duration) + "天"
        }else{
            self.durationItem.value = nil
        }
        self.endTimeItem.value = rental.toDate.ymd
        self.amountItem.value = String(format: "¥%.2f", device.price * rental.duration)
        //self.durationPicker.setSelectedData(rental.duration)
    }
    
    
    
    private lazy var startTimeItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "起租时间")
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        item.selectHandler = { [weak self] in
            if let self = self{
                //self.datePicker?.popFromBottom()
                self.selectStartTimeHandler?()
            }
        }
        return item
    }()
    
    
    private lazy var durationItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "租赁时长")
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        item.selectHandler = { [weak self] in
            self?.selectDurationHandler?()
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
    
    private lazy var amountItem: ConfirmItemView = {
        let item = ConfirmItemView(title: "订单金额")
        item.arrowBtn.chain.normalTitleColor(color: .init(hexString: "#FF7871"))
        item.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        return item
    }()
    
}

class ConfirmItemView : BaseView{
    var value: String? {
        didSet{
            if let value = value{
                arrowBtn.chain.normalTitle(text: value).normalImage(nil)
            }else{
                arrowBtn.chain.normalTitle(text: nil).normalImage(.init(named: "arrow_right"))
            }
        }
    }
    
    var valueColor: UIColor?{
      didSet {
          arrowBtn.chain.normalTitleColor(color: valueColor)
      }
    }
    
    var selectHandler: Block?
    
    let title: String
    let arrowBtn = UIButton()
    
    init(title: String, value: String? = nil) {
        self.title = title
        defer{
            self.value = value
        }
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configSubviews() {
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        titleLabel.chain.font(.systemFont(ofSize: 14)).text(color: .init(hexColor: "#999999")).text(title)
        
        addSubview(arrowBtn)
        arrowBtn.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
        arrowBtn.chain.font(.boldSystemFont(ofSize: 14)).normalTitleColor(color: .init(hexString: "#111111")).userInteractionEnabled(false)
        
        let tap = UITapGestureRecognizer {[weak self] _ in
            self?.selectHandler?()
        }
        addGestureRecognizer(tap)
    }
    
}
