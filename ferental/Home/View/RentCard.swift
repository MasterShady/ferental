//
//  RentCard.swift
//  ferental
//
//  Created by 刘思源 on 2022/12/29.
//

import Foundation

class RentCard: BaseView{
    
    enum RentType {
        case computer
        case phone
    }
    
    private var computerBtn = UIButton()
    private var phoneBtn = UIButton()
    
    //var selectRentTypeHandler : ((RentType) -> ())?
    
    func setRentType(_ type: RentType, animated: Bool){
        rentType = type
        if animated{
            self.layoutIfNeeded()
            self.updateIndicator()
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }else{
            self.updateIndicator()
        }
        
    }
    
    var rentType : RentType = .computer{
        didSet{
            self.gamePicker.setSelectedData(self.rental.games)
            self.durationPicker.setSelectedData(self.rental.duration)
            self.datePicker.setSelectedData(self.rental.fromDate)
            
            updateUI()
        }
    }
    
    private var computerRental = Rental()
    private var phoneRental = Rental()
    
    var rental : Rental {
        if rentType == .computer{
            return computerRental
        }
        return phoneRental
    }
    
    override var expectHeight: CGFloat{
        kBottomSafeInset + 330
    }
    
    override func configSubviews() {
        backgroundColor = .white
        self.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(expectHeight)
        }
        self.chain.backgroundColor(.white).corner(radius: 3).clipsToBounds(true)
        
        let moduleContainer = ModuleContainer(layoutConstraintAxis: .vertical)
        addSubview(moduleContainer)
        moduleContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        // 选项卡头部
        moduleContainer.addModule(header)
        moduleContainer.addModule(gameItem)
        moduleContainer.addModule(startDateItem)
        moduleContainer.addModule(durationItem)
        
        let searchBtn = UIButton()
        searchBtn.chain.backgroundColor(.kthemeColor).normalTitle(text: "查询").font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .kDeepBlack).corner(radius: 6).clipsToBounds(true)
        searchBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 180, height: 44))
        }
        
        searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        moduleContainer.addModule(searchBtn,beforeSpacing: 8)
        
        let privilegeView = UIImageView()
        privilegeView.image = .init(named: "search_ privilege")
//        privilegeView.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 238, height: 16))
//        }
        
        moduleContainer.addModule(privilegeView, beforeSpacing: 29)
        updateUI()
    }
    
    
    func updateUI(){
        let rental = self.rental
        
        let value = rental.games.enumerated().reduce("") { partialResult, element in
            let (index, game) = element
            if(index == 0){
                return game.title
            }
            if partialResult.count < 10 {
                return partialResult + "," + game.title
            }else if index == rental.games.count - 1{
                return partialResult + "等"
            }
            return partialResult
        }
        
        
        gameItem.value = value
        startDateItem.value = rental.fromDate.ymd
        durationItem.value = String(rental.duration) + "天"
        
        if rentType == .computer{
            computerBtn.isSelected = true
            phoneBtn.isSelected = false
        }else{
            computerBtn.isSelected = false
            phoneBtn.isSelected = true
        }
        
    }
    
    @objc func search(){
        
        if(!AppData.policyAgreed){
            let view = PolicyView()
            view.popFromBottom()
            view.agreedHandler = { [weak self] in
                self?.search()
            }
            return
        }
        
        if self.rental.games.count == 0{
            AutoProgressHUD.showAutoHud("请至少选择一款游戏")
            return
        }
        
    }
    
    func updateIndicator(){
        indicator.snp.remakeConstraints { make in
            if rentType == .computer{
                make.left.equalTo(computerBtn)
                make.bottom.equalTo(computerBtn).offset(-5)
                make.size.equalTo(CGSize(width: 34, height: 11))
            }else{
                make.left.equalTo(phoneBtn)
                make.bottom.equalTo(phoneBtn).offset(-5)
                make.size.equalTo(CGSize(width: 34, height: 11))
            }
            
        }
    }
    
    
    lazy var header: UIView = {
        let segmentView = UIView()
        segmentView.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(kScreenWidth)
        }
        
        segmentView.addSubview(indicator)


        
        let normalAttr: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColorFromHex("878787")
        ]
        
        let selectedAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.kDeepBlack
        ]
    
        
        segmentView.addSubview(computerBtn)
        computerBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
        }
        
        let computeNormalTitle = NSAttributedString(string:"租游戏本", attributes:normalAttr)
        let computeSeletedTitle = NSAttributedString(string:"租游戏本", attributes:selectedAttr)
        computerBtn.chain.attributedTitle(computeNormalTitle, for: .normal)
            .attributedTitle(computeSeletedTitle, for: .selected).isSelected(true)
        computerBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            if let self = self{
                self.rentType = .computer
                self.layoutIfNeeded()
                self.updateIndicator()
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
                self.computerBtn.isSelected = true
                self.phoneBtn.isSelected = false
            }
        }
        

        segmentView.addSubview(phoneBtn)
        phoneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(computerBtn.snp.right).offset(24)
        }
        
        let phoneNormalTitle = NSAttributedString(string:"租游戏手机", attributes:normalAttr)
        let phoneSeletedTitle = NSAttributedString(string:"租游戏手机", attributes:selectedAttr)
        phoneBtn.chain.attributedTitle(phoneNormalTitle, for: .normal)
            .attributedTitle(phoneSeletedTitle, for: .selected).isSelected(true)
        
        
        phoneBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            if let self = self{
                self.rentType = .phone
                self.layoutIfNeeded()
                self.updateIndicator()
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
                self.computerBtn.isSelected = false
                self.phoneBtn.isSelected = true
            }
        }
        
        indicator.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 11))
            make.left.equalTo(computerBtn)
            make.bottom.equalTo(computerBtn).offset(-5)
        }

        return segmentView
    }()
    
    lazy var indicator: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = .kthemeColor
        return indicator
    }()
    
    
    lazy var gameItem: SelectItemView = {
        let gameItem = SelectItemView(config: (title:"想玩的游戏", defaultValue: nil)) {
            [weak self] in
            self?.gamePicker.popFromBottom()
        }
        gameItem.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 55))
        }
        return gameItem
    }()
    
    
    
    lazy var gamePicker: MultiplePicker<Game> = {
        let rawTitle = "选择想玩的游戏（可多选）"
        let rawPart = "（可多选）"
        let range = (rawTitle as NSString).range(of: rawPart)
        let title = NSMutableAttributedString(string: rawTitle)
        
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
        title.setAttributes([
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.kTextBlack,
        ], range: range)
        
        let gamePicker = MultiplePicker(title: title, data: AppData.games) {[weak self] games in
            self?.gamePicker.popDismiss()
            self?.rental.games = games
            self?.updateUI()
        } titleForDatum: { game in
            return game.title
        }
        
        gamePicker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: expectHeight))
        }
        
        return gamePicker
    }()
    
    lazy var startDateItem: SelectItemView = {
        let startDateItem = SelectItemView(config: ("起租时间",nil)) { [weak self] in
            self?.datePicker.popFromBottom()
        }
        startDateItem.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 55))
        }
        return startDateItem
    }()
    
    lazy var datePicker: DatePicker = {
        let title = NSMutableAttributedString(string:"选择起租时间")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
        
        
        let fromDate = Date()
        let toDate = fromDate.addingTimeInterval(86400 * 60.0)
        let datePicker = DatePicker(title: title, fromDate: fromDate, toDate: toDate) {[weak self] date in
            self?.datePicker.popDismiss()
            self?.rental.fromDate = date
            self?.updateUI()
        }
        datePicker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: expectHeight))
        }
        return datePicker
    }()
    
    private lazy var durationItem: SelectItemView = {
        let durationItem = SelectItemView(config: ("租赁时长",nil)) { [weak self] in
            self?.durationPicker.popFromBottom()
        }
        durationItem.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 55))
        }
        return durationItem
    }()
    
    lazy var durationPicker: SinglePicker<Int> = {
        let title = NSMutableAttributedString(string:"选择租赁时常")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
    
        let picker = SinglePicker<Int>(title: title, data: AppData.rentDuration) { [weak self ] duration in
            self?.durationPicker.popDismiss()
            self?.rental.duration = duration
            self?.updateUI()
        } titleForDatum: { duration in
            return String(duration) + "天"
        }
        
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: expectHeight))
        }

        return picker

    }()
}
