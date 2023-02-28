//
//  OrderListVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/19.
//

import UIKit
import ESPullToRefresh

class OrderCell : UITableViewCell{
    
    var order: Order?{
        didSet{
            if let order = order {
                switch order.status {
                case .pendingReview:
                    orderStatusLabel.text = "待审核"
                    orderStatusLabel.textColor = .init(hexColor: "#585960")
                    pickUpIconView.isHidden = true
                    orderStatusLabel.snp.updateConstraints { make in
                        make.right.equalTo(-14)
                    }
                case .completed:
                    orderStatusLabel.text = "已完成"
                    orderStatusLabel.textColor = .init(hexColor: "#585960")
                    pickUpIconView.isHidden = true
                    orderStatusLabel.snp.updateConstraints { make in
                        make.right.equalTo(-14)
                    }
                case .pendingPickup:
                    orderStatusLabel.text = "待提货"
                    orderStatusLabel.textColor = .kTextBlack
                    pickUpIconView.isHidden = false
                    orderStatusLabel.snp.updateConstraints { make in
                        make.right.equalTo(-19)
                    }
                }
                coverView.kf.setImage(with: URL(subPath: order.cover), placeholder: nil)
                orderTitleLabel.text = order.title
                orderTimeLabel.text =  String(format: "下单时间: %@", order.createdDate.ymdhms)
                orderIdLabel.text = String(format: "订单编号 %@", order.orderId)
                
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
                
                orderPriceLabel.attributedText = attrText
            }
        }
    }
    
    private var coverView = UIImageView()
    private var orderTitleLabel = UILabel()
    private var orderTimeLabel = UILabel()
    private var orderIdLabel = UILabel()
    private var orderStatusLabel = UILabel()
    private var orderPriceLabel = UILabel()
    private var pickUpIconView = UIImageView()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews(){
        selectionStyle = .none
        backgroundColor = .clear
        
        let container = UIView()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.height.equalTo(172)
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 14, bottom: 0, right: 14))
        }
        container.chain.corner(radius: 6).clipsToBounds(true).backgroundColor(.white)
        
        
        let header = UIView()
        container.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        header.addSubview(orderIdLabel)
        orderIdLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
        }
        orderIdLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "#878787")).numberOfLines(0)
        
        header.addSubview(orderStatusLabel)
        orderStatusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-19)
        }
        orderStatusLabel.chain.font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack)
        
        header.addSubview(pickUpIconView)
        pickUpIconView.snp.makeConstraints { make in
            make.left.equalTo(orderStatusLabel.snp.right).offset(-2)
            make.bottom.equalTo(orderStatusLabel.snp.top).offset(5)
        }
        pickUpIconView.image = .init(named: "star")
        pickUpIconView.isHidden = true
        
        
        let sep = UIView()
        header.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        sep.backgroundColor = .init(hexColor: "#EDEDED")
        
        container.addSubview(coverView)
        coverView.chain.corner(radius: 3).clipsToBounds(true)
        coverView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(17)
            make.left.equalTo(14)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        coverView.chain.corner(radius: 3).clipsToBounds(true).contentMode(.scaleAspectFill)
        
        header.addSubview(orderTitleLabel)
        orderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverView)
            make.left.equalTo(coverView.snp.right).offset(17)
            make.right.equalTo(-12)
        }
        orderTitleLabel.chain.font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack).numberOfLines(2)
        
        container.addSubview(orderPriceLabel)
        orderPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(66)
            make.left.equalTo(orderTitleLabel)
        }
        
        
        container.addSubview(orderTimeLabel)
        orderTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.bottom.equalTo(-12)
        }
        orderTimeLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "878787"))
    }
}

class OrderListVC: BaseVC, UITableViewDelegate, UITableViewDataSource{
    
    let tableView = UITableView()
    var scrollViewDidScrollHandler: ((UIScrollView)->())?
    var pullHandler : Block?
    var data: [Order] = [] {
        didSet{
            self.tableView.reloadData()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.emptyDataSetView { view in
            
            view.image(.init(named: "no_order")).titleLabelString(NSAttributedString(string: "一个订单都没有", attributes: [
                .foregroundColor : UIColor(hexColor: "#999999"),
                .font : UIFont.systemFont(ofSize: 16)
            ]))
            view.verticalOffset(-100)
            if !UserStore.isLogin{
                view.buttonTitle(.init("去登录", color: .kDeepBlack, font: .boldSystemFont(ofSize: 16)), for: .normal)
                view.didTapDataButton { [weak self] in
                    self?.navigationController?.pushViewController(LoginVC(), animated: true)
                }
            }
        }
        tableView.es.addPullToRefresh { [weak self] in
            self?.pullHandler?()
        }
    }
    
    override func configData() {
        NotificationCenter.default.addObserver(forName: kUserChanged.name, object: nil, queue: OperationQueue.main) { _ in
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! OrderCell
        cell.order = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = data[indexPath.row];
        let vc = OrderStatusVC(order: order)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollHandler?(scrollView)
    }
}
