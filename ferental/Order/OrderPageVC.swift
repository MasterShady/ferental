//
//  OrderVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import Parchment
import UIKit



class HeaderPagingView: PagingView {
    var headerHeightConstraint: NSLayoutConstraint?
    static let HeaderHeight: CGFloat = kNavBarMaxY
    
    lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .init(hexColor: "#F4F6F9")
        let appNameLabel = UILabel()
        header.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(3 + kStatusBarHeight)
            make.left.equalTo(14)
        }
        appNameLabel.font = .boldSystemFont(ofSize: 20)
        appNameLabel.text = "订单"
        appNameLabel.textColor = .kTextBlack
        
        return header
    }()

    override func setupConstraints() {
        addSubview(self.header)
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false

        headerHeightConstraint = header.heightAnchor.constraint(
            equalToConstant: HeaderPagingView.HeaderHeight
        )
        headerHeightConstraint?.isActive = true
        

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight),
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            

            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            

            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}

class HeaderPagingViewController: PagingViewController {
    override func loadView() {
        view = HeaderPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }
}



class OrderPageVC : BaseVC{
    
    var allOrders = [Order]()
    
    private lazy var viewControllers: [OrderListVC] = {
        (0...3).map { [weak self] _ in
            let vc = OrderListVC()
            vc.pullHandler = self?.getOrders
            return vc
        }
    }()

    private lazy var pagingViewController :HeaderPagingViewController = {
        var options = PagingOptions()
        options.selectedFont = .boldSystemFont(ofSize: 17)
        options.selectedTextColor = .init(hexColor: "#1D1E21")
        options.font = .systemFont(ofSize: 14)
        options.textColor = .init(hexColor: "#878787")
        options.menuItemSize = .selfSizing(estimatedWidth: 42, height: 30)
        options.menuItemLabelSpacing = 14
        options.pagingContentBackgroundColor = .init(hexColor: "#F4F6F9")
        options.menuBackgroundColor = .init(hexColor: "#F4F6F9")
        //options.menuInteraction = .none
        
        return HeaderPagingViewController(options: options)
    }()
    
    private var headerConstraint: NSLayoutConstraint {
        let pagingView = pagingViewController.view as! HeaderPagingView
        return pagingView.headerHeightConstraint!
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        
        pagingViewController.indicatorColor = .init(hexColor: "#C1F00C")
        pagingViewController.indicatorOptions = .visible(
            height: 11,
            zIndex: -1, // 这样在tag下发
            spacing: .init(top: 0, left: 15, bottom: 0, right: 15),
            insets: .init(top: 0, left: 0, bottom: 7, right: 0)
        )
        
        
        pagingViewController.borderOptions = .hidden
        
        
        pagingViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pagingViewController.dataSource = self
        pagingViewController.delegate = self

        NotificationCenter.default.addObserver(forName: kUserChanged.name, object: nil, queue: .main) { _ in
            self.getOrders()
        }
        
        NotificationCenter.default.addObserver(forName: kUserMakeOrder.name, object: nil, queue: .main) { _ in
            self.getOrders()
        }
        
    }
    
    
    override func configData() {
        if UserStore.isLogin{
            getOrders()
        }else{
            //未登录
        }
        
    }
    
    
    func getOrders(){
        if !UserStore.isLogin {
            self.allOrders = []
            self.handleData()
            return
        }
        orderService.request(.getAllOrders) { result in
            result.hj_mapArray(Order.self, atKeyPath: "data") {[weak self] result in
                guard let self = self else {return}
                switch result {
                case .success((let orders,_)):
                    self.allOrders = orders
                    self.handleData()
                case .failure(let error):
                    self.handleData()
                    AutoProgressHUD.showAutoHud(error.localizedDescription)
                }
            }
        }
    }
    
    func handleData(){
        viewControllers[0].data = self.allOrders
        viewControllers[1].data = self.allOrders.filter({$0.status == .pendingReview})
        viewControllers[2].data = self.allOrders.filter({$0.status == .pendingPickup})
        viewControllers[3].data = self.allOrders.filter({$0.status == .completed})
    }
    
}

extension OrderPageVC: PagingViewControllerDataSource {
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let viewController = viewControllers[index]
        let height = pagingViewController.options.menuHeight + HeaderPagingView.HeaderHeight
        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        viewController.tableView.contentInset = insets
        viewController.tableView.scrollIndicatorInsets = insets

        return viewController
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let titles = ["全部","待审核","待提货","已完成"]
        return PagingIndexItem(index: index, title: titles[index])
    }

    func numberOfViewControllers(in _: PagingViewController) -> Int {
        return viewControllers.count
    }
}

extension OrderPageVC: PagingViewControllerDelegate {
    func pagingViewController(_: PagingViewController, willScrollToItem _: PagingItem, startingViewController _: UIViewController, destinationViewController: UIViewController) {
        guard let destinationViewController = destinationViewController as? OrderListVC else { return }
        let scrollView = destinationViewController.tableView
        let offset = headerConstraint.constant + pagingViewController.options.menuHeight
        scrollView.contentOffset = CGPoint(x: 0, y: -offset)
        updateScrollIndicatorInsets(in: scrollView)
    }
}

extension OrderPageVC: UITableViewDelegate {
    func updateScrollIndicatorInsets(in scrollView: UIScrollView) {
        let offset = min(0, scrollView.contentOffset.y) * -1
        let insetTop = max(pagingViewController.options.menuHeight, offset)
        let insets = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)
        scrollView.scrollIndicatorInsets = insets
    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView.contentOffset.y < 0 else {
//            return
//        }
//        updateScrollIndicatorInsets(in: scrollView)
//    }
}
