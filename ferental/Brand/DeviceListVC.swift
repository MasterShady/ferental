//
//  DeviceListVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit
import EmptyDataSet_Swift

class DeviceListVC: BaseVC {
    
    
    var data = [Device]()
    var brand: Brand
    
    private var comOrderBtn = UIButton()
    private var priceOrderBtn = UIButton()
    
    deinit {
        print("dead")
    }
    
    init(brand:Brand) {
        self.brand = brand
        self.data = AppData.mockDevices
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func configSubViews() {
        view.backgroundColor = UIColor(hexString: "#F4F6F9")
        setBackTitle(brand.name)
        
        
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
        
        let sortOrder: BoolBlock = {[weak self] byPrice in
            if byPrice{
                self?.data = AppData.mockDevices.sorted(by: { l, r in
                    return l.rentalFee < r.rentalFee
                })
            }else{
                self?.data = []
                //AppData.mockDevices
            }
            self?.tableView.reloadData()
        }
        
        let normalImage = UIImage(named: "drop_down")
        let selectedImage = normalImage?.withTintColor(.kthemeColor)
        comOrderBtn.chain.normalTitle(text: "综合排序").normalTitleColor(string: "#111111").selectedTitleColor(color: .kthemeColor).font(.systemFont(ofSize: 13)).normalImage(normalImage).selectedImage(selectedImage)
        comOrderBtn.setImagePosition(.right, spacing: 3)
        
        
        comOrderBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.comOrderBtn.isSelected = true
            self?.priceOrderBtn.isSelected = false
            sortOrder(false)
        }
        comOrderBtn.isSelected = true
        

        searchBgView.addSubview(priceOrderBtn)
        priceOrderBtn.snp.makeConstraints { make in
            make.left.equalTo(comOrderBtn.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
        priceOrderBtn.chain.normalTitle(text: "价格排序").normalTitleColor(string: "#111111").selectedTitleColor(color: .kthemeColor).font(.systemFont(ofSize: 13)).normalImage(normalImage).selectedImage(selectedImage)
        priceOrderBtn.setImagePosition(.right, spacing: 3)
        priceOrderBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.priceOrderBtn.isSelected = true
            self?.comOrderBtn.isSelected = false
            sortOrder(true)
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
        if (data.count == 0){
            self.tableView.tableHeaderView?.isHidden = true
        }
        return data.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DeviceCell
        cell.device = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let des = DeviceDetailVC(device:data[indexPath.row])
        navigationController?.pushViewController(des, animated: true)
    }
}



