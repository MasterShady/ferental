//
//  DeviceListVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit
import EmptyDataSet_Swift


enum OrderType {
    case defaultOrder
    case priceAscend
    case priceDescend
}

class DeviceListVC: BaseVC {
    

    
    var descendImage : UIImage = {
        let width = 10
        let height = 13
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let image1 = UIImage.init(named: "tri_up")!
        let image2 = UIImage.init(named: "tri_down")!
        let image = renderer.image { context in
            let rect1 = CGRect(x: 0, y: 0, width: 10, height: 10)
            image1.draw(in: rect1, blendMode: .normal, alpha: 0.5)
            let rect2 = CGRect(x: 0, y: 3, width: 10, height: 10)
            image2.draw(in: rect2)
        }
        return image
    }()
    
    var ascendImage : UIImage = {
        let width = 10
        let height = 13
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let image1 = UIImage.init(named: "tri_up")!
        let image2 = UIImage.init(named: "tri_down")!
        let image = renderer.image { context in
            let rect1 = CGRect(x: 0, y: 0, width: 10, height: 10)
            image1.draw(in: rect1)
            let rect2 = CGRect(x: 0, y: 3, width: 10, height: 10)
            image2.draw(in: rect2, blendMode: .normal, alpha: 0.5)
        }
        return image
    }()
    
    var priceNormalImage : UIImage = {
        let width = 10
        let height = 13
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let image1 = UIImage.init(named: "tri_up")!.withTintColor(.kLightGray, renderingMode: .automatic)
        let image2 = UIImage.init(named: "tri_down")!.withTintColor(.kLightGray, renderingMode: .automatic)
        let image = renderer.image { context in
            let rect1 = CGRect(x: 0, y: 0, width: 10, height: 10)
            image1.draw(in: rect1)
            let rect2 = CGRect(x: 0, y: 3, width: 10, height: 10)
            image2.draw(in: rect2)
        }
        return image
    }()
    
    
    var orderType = OrderType.defaultOrder {
        didSet{
           updateSort()
        }
    }
    
    var allDevices = [Device]()
    
    var devicesToShow : [Device]!
    
    var refreshHandler : ((Block) -> ())? {
        didSet{
            if refreshHandler != nil{
                self.tableView.es.addPullToRefresh(animator: esHeader) { [weak self] in
                    self?.refreshHandler?({})
                }
            }else{
                self.tableView.es.removeRefreshHeader()
            }
        }
    }
    
    //就是传个值
    var rental : Rental?
    
    
    var backTitle = ""
    
    private var comOrderBtn = UIButton()
    private var priceOrderBtn = UIButton()
    
    deinit {
        print("dead")
    }
    
    init(deviceList:[Device],backTitle:String = "") {
        self.backTitle = backTitle
        self.allDevices = deviceList
        self.devicesToShow = deviceList
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateSort(){
        switch orderType {
        case .defaultOrder:
            comOrderBtn.isSelected = true
            priceOrderBtn.isSelected = false
            //奇怪的很, 用户按下不松手时显示的是normal状态的颜色. 为了防止颜色跳变只能加上这些代码
            priceOrderBtn.chain.normalTitleColor(color: .init(hexColor: "111111")).normalImage(priceNormalImage)
            devicesToShow = allDevices
            tableView.reloadData()
        case .priceAscend:
            comOrderBtn.isSelected = false
            priceOrderBtn.chain.selectedTitle(text: "价格升序").selectedImage(ascendImage).isSelected(true)
            //奇怪的很, 用户按下不松手时显示的是normal状态的颜色. 为了防止颜色跳变只能加上这些代码
            priceOrderBtn.chain.normalTitleColor(color: .kthemeColor).normalImage(priceNormalImage.colored(.kthemeColor))
            devicesToShow = allDevices.sorted(by: { l, r in
                return l.price > r.price
            })
            tableView.reloadData()
        case .priceDescend:
            comOrderBtn.isSelected = false
            
            priceOrderBtn.chain.selectedTitle(text: "价格降序").selectedImage(descendImage).isSelected(true)
            //奇怪的很, 用户按下不松手时显示的是normal状态的颜色. 为了防止颜色跳变只能加上这些代码
            priceOrderBtn.chain.normalTitleColor(color: .kthemeColor).normalImage(priceNormalImage.colored(.kthemeColor))
            devicesToShow = allDevices.sorted(by: { l, r in
                return l.price < r.price
            })
            tableView.reloadData()
            
        }
    }
    
    func reloadDevices(devices: [Device]){
        self.allDevices = devices
        self.tableView.es.stopPullToRefresh()
        updateSort()
    }
    
    func reloadFailed(){
        self.tableView.es.stopPullToRefresh()
    }
    
    
    override func configSubViews() {
        view.backgroundColor = UIColor(hexString: "#F4F6F9")
        setBackTitle(self.backTitle)
        
        self.view.addSubview(searchHeader)
        searchHeader.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        let tableViewMaskView = UIView()
        self.view.addSubview(tableViewMaskView)
        tableViewMaskView.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp_bottomMargin).offset(-12)
            make.bottom.equalToSuperview()
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        DispatchQueue.main.async {
            tableViewMaskView.addCornerRect(with: [.topLeft,.topRight], radius: 7)
        }

        tableViewMaskView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var searchHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .kthemeColor
        let searchBgView = UIView()
        view.addSubview(searchBgView)
        searchBgView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(0)
            make.height.equalTo(36)
        }
        searchBgView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        searchBgView.addSubview(comOrderBtn)
        comOrderBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
        }
        
        let normalImage = UIImage(named: "drop_down")
        let selectedImage = normalImage?.withTintColor(.kthemeColor)
        comOrderBtn.chain.normalTitle(text: "综合排序").normalTitleColor(string: "#111111").selectedTitleColor(color: .kthemeColor).font(.systemFont(ofSize: 13)).normalImage(normalImage).selectedImage(selectedImage)
        comOrderBtn.setImagePosition(.right, spacing: 3)
        
        
        comOrderBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.orderType = .defaultOrder
        }
        comOrderBtn.isSelected = true
        

        searchBgView.addSubview(priceOrderBtn)
        priceOrderBtn.snp.makeConstraints { make in
            make.left.equalTo(comOrderBtn.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
        priceOrderBtn.chain.normalTitle(text: "价格排序").normalTitleColor(string: "#111111").selectedTitleColor(color: .kthemeColor).font(.systemFont(ofSize: 13)).normalImage(priceNormalImage)
            .titleColor(color: .kthemeColor, for: .highlighted).image(priceNormalImage.colored(.kthemeColor), for: .highlighted).adjustsImageWhenHighlighted(false)
        priceOrderBtn.setImagePosition(.right, spacing: 3)
        priceOrderBtn.addBlock(for: .touchDown) { [weak self] _ in
            if self?.orderType == .defaultOrder{
                self?.orderType = .priceDescend
            }else if self?.orderType == .priceAscend{
                self?.orderType = .priceDescend
            }else if self?.orderType == .priceDescend{
                self?.orderType = .priceAscend
            }
        }
        
        return view
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.emptyDataSetView { view in
            view.image(.init(named: "no_device")).titleLabelString(.init(string: "设备都被租出去了", attributes: [
                .foregroundColor : UIColor(hexString: "#999999")!,
                .font: UIFont.systemFont(ofSize: 16)
            ]))
        }
        

        
        return tableView
    }()
}




extension DeviceListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (devicesToShow.count == 0){
            self.tableView.tableHeaderView?.isHidden = true
        }
        return devicesToShow.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DeviceCell
        cell.device = devicesToShow[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let des = DeviceDetailVC(device:devicesToShow[indexPath.row])
        if let rental = rental{
            des.rental = rental
        }
        navigationController?.pushViewController(des, animated: true)
    }
}



