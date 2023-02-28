
//
//  DeviceListVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit
import EmptyDataSet_Swift
import RxCocoa
import RxSwift
import RxRelay
import MBProgressHUD

enum Status {
    case idle
    case loading
    case success([Device])
    case error(Error)
}

class DeviceListViewModel{
    let deviceRelay: BehaviorRelay<[Device]>
    var selectedStatus = BehaviorRelay<OrderType>(value: .defaultOrder)
    var networkStatus = BehaviorRelay<Status>(value: .idle)
    let refreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    
    deinit{
        print("released!")
    }
    

    init(devices:[Device]) {
        deviceRelay = .init(value: devices)
        Observable.combineLatest(refreshTrigger.startWith(()), selectedStatus).bind {[weak self] (_, status) in
            guard let self = self else {return}
            print("triggerd!")
            self.networkStatus.accept(.loading)
            let _ = brandService.rx.request(.getAllDevices).subscribe { response in
                do {
                    let list = try response.hj_mapArray(Device.self, atKeyPath: "data")
                    let sortedList = list.sorted(by: { l, r in
                        switch status {
                        case .defaultOrder:
                            return true
                        case .priceAscend:
                            return l.price < r.price
                        case .priceDescend:
                            return l.price > r.price
                        }

                    })

                    self.deviceRelay.accept(sortedList)
                    self.networkStatus.accept(.success(list))
                }
                catch {
                    self.networkStatus.accept(.error(error))
                }
            } onFailure: { error in
                self.networkStatus.accept(.error(error))
            }
        }.disposed(by: disposeBag)
    }
}

class DeviceListVC2: BaseVC {

    let disposeBag = DisposeBag()

    let viewModel: DeviceListViewModel

    var allDevices = [Device]()

    var devicesToShow : [Device]!

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
        self.viewModel = DeviceListViewModel(devices: self.allDevices)
        super.init(nibName:nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


        _ = comOrderBtn.rx.tap.map{
            OrderType.defaultOrder
        }.bind(to: viewModel.selectedStatus)

        _ = priceOrderBtn.rx.tap.map{
            OrderType.priceAscend
        }.bind(to: viewModel.selectedStatus)

        
        self.viewModel.networkStatus.bind {[weak self] status in
            guard let self = self else {return}
            switch status {
            case .loading:
                MBProgressHUD.showAdded(to: self.view, animated: true)
            case .success, .error:
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.es.stopPullToRefresh()
            case .idle:
                break
            }
        }.disposed(by: disposeBag)


        let _ = self.viewModel.deviceRelay.bind(to:tableView.rx.items(cellIdentifier: "cellId",cellType:DeviceCell.self)){ _, device, cell in
            cell.device = device
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Device.self).subscribe {[weak self] element in
            let vc = DeviceDetailVC(device: element)
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        tableView.es.addPullToRefresh(animator: esHeader) { [weak self] in
            self?.viewModel.refreshTrigger.onNext(())
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
            guard let self = self else { return }
            if byPrice{
                self.devicesToShow = self.allDevices.sorted(by: { l, r in
                    return l.price < r.price
                })
            }else{
                self.devicesToShow = self.allDevices
            }
            self.tableView.reloadData()
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
//        tableView.delegate = self
//        tableView.dataSource = self
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




//extension DeviceListVC2 : UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (devicesToShow.count == 0){
//            self.tableView.tableHeaderView?.isHidden = true
//        }
//        return devicesToShow.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DeviceCell
//        cell.device = devicesToShow[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let des = DeviceDetailVC(device:devicesToShow[indexPath.row])
//        if let rental = rental{
//            des.rental = rental
//        }
//        navigationController?.pushViewController(des, animated: true)
//    }
//}



