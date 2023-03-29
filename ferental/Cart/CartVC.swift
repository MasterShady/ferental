//
//  CartController.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/27.
//

import UIKit
import AEAlertView

class CartManager{
    static var cartItems : [CartItem] = {
        if let items = UserDefaults.standard.value(forKey: "cartStore") as? NSArray, let objs = [CartItem].deserialize(from: items){
            return objs.compactMap({$0})
        }
        return [CartItem]()
    }()
    
    static func isAllSelected() -> Bool{
        let anyDeselected = cartItems.any { item in
            item.selected == false
        }
        return !anyDeselected
    }
    
    static func selectAll(){
        cartItems.forEach {$0.selected = true}
    }
    
    static func deselectAll(){
        cartItems.forEach {$0.selected = false}
    }
    
    static func selectedCount() -> Int{
        cartItems.filter { $0.selected }.reduce(0) { partialResult, item in
            partialResult + item.count
        }
    }
    
    static func totolPrice() -> Double{
        cartItems.filter{ $0.selected }.reduce(0.0) { partialResult, item in
            partialResult + item.device.price * item.count
        }
    }
    
    static func addDevice(_ device: Device){
        if let item = cartItems.first(where: { $0.device == device}){
            item.count += 1
        }else{
            let item = CartItem()
            item.device = device
            cartItems.append(item)
        }
        updateStore()
    }
    
    static func countForDevice(_ device: Device) -> Int{
        if let item = cartItems.first(where: { $0.device == device}){
           return item.count
        }
        return 0
    }
    
    static func minusDevice(_ device: Device){
        if let item = cartItems.first(where: { $0.device == device}){
            if item.count  == 1{
                cartItems.remove(item)
                updateStore()
            }else{
                item.count = item.count - 1
            }
        }
    }
    
    static func allSelectedItems() -> [CartItem]{
        cartItems.filter {$0.selected}
    }
    
    
    
    static func updateStore(){
        let json = cartItems.toJSON()
        UserDefaults.standard.set(json, forKey: "cartStore")
        UserDefaults.standard.synchronize()
    }
}

class CartSumView : BaseView {
    let totalLabel = UILabel()
    let payBtn = UIButton()
    let checkbox = UIButton()
    
    
    override func configSubviews() {
        let cart_checkbox_normal = UIImage.init(named: "cart_checkbox_normal")?.resizeImageToSize(size: CGSize(width: 20, height: 20))
        let cart_checkbox_selected = UIImage.init(named: "cart_checkbox_selected")?.resizeImageToSize(size: CGSize(width: 20, height: 20))
        checkbox.chain.normalTitle(text: "全选").normalTitleColor(color: .kTextBlack).font(.systemFont(ofSize: 14)).normalImage(cart_checkbox_normal).selectedImage(cart_checkbox_selected)
        checkbox.setImagePosition(.left, spacing: 5)
        
        addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        addSubview(totalLabel)
        totalLabel.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 14))
        
        totalLabel.snp.makeConstraints { make in
            make.left.equalTo(checkbox.snp.right).offset(14)
            make.centerY.equalToSuperview()
        }
        
        addSubview(payBtn)
        payBtn.chain.normalTitleColor(color: .kTextBlack).font(.boldSystemFont(ofSize: 14)).corner(radius: 6).clipsToBounds(true).backgroundColor(.kthemeColor)
        payBtn.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height:40))
        }
    }
    
    func updateUI(){
        totalLabel.text = String(format: "¥%.2f", CartManager.totolPrice())
        payBtn.chain.normalTitle(text: String(format: "去结算(%zd)",CartManager.selectedCount()))
        checkbox.isSelected = CartManager.isAllSelected()
    }
}


class CartVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    let sumView = CartSumView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
        checkSumStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let pageNameLabel = UILabel()
        view.addSubview(pageNameLabel)
        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(3 + kStatusBarHeight)
            make.left.equalTo(14)
        }
        pageNameLabel.font = .boldSystemFont(ofSize: 20)
        pageNameLabel.text = "购物车"
        pageNameLabel.textColor = .kTextBlack
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(pageNameLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(sumView)
        sumView.checkbox.addBlock(for: .touchUpInside) {[weak self] _ in
            if CartManager.isAllSelected(){
                CartManager.deselectAll()
            }else {
                CartManager.selectAll()
            }
            self?.tableView.reloadData()
            self?.checkSumStatus()
        }
        
        sumView.payBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            
            self?.navigationController?.pushViewController(CartComfirmVC(cartItems: CartManager.allSelectedItems()), animated: true)
        }
        
        sumView.snp.makeConstraints {make in
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
            make.bottom.equalToSuperview().offset(50)
            make.top.equalTo(tableView.bottom)
        }
        
        
    }
    
    
    func checkSumStatus(){
        if CartManager.selectedCount() > 0{
            sumView.snp.remakeConstraints {make in
                make.height.equalTo(50)
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
            }
        }else{
            sumView.snp.remakeConstraints {make in
                make.height.equalTo(50)
                make.bottom.equalToSuperview().offset(50)
                make.left.right.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
            }
        }
        sumView.updateUI()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CartItemCell
        let item = CartManager.cartItems[indexPath.row]
        cell.item = item
        cell.addHandler = {[weak self] in
            guard let self = self else {return}
            CartManager.addDevice(item.device)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.checkSumStatus()
        }
        cell.minusHandler = { [weak self] in
            guard let self = self else {return}
            let count = CartManager.countForDevice(item.device)
            if count == 1{
                AEAlertView.show(title: "确定要删除该商品吗?", message: "", actions: ["取消","确定"]) { action in
                    if action.title == "确定"{
                        CartManager
                            .minusDevice(item.device)
                        self.tableView.reloadData()
                        self.checkSumStatus()
                    }
                }
            }else{
                CartManager
                    .minusDevice(item.device)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.checkSumStatus()
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = CartManager.cartItems[indexPath.row]
        item.selected = !item.selected
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.checkSumStatus()
    }
}
