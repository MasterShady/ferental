//
//  BaseVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit
import SnapKit
import ETNavBarTransparent
import ESPullToRefresh

extension UIViewController{
    @objc func setBackTitle(_ title: String, withBg:Bool = false){
        let backBtn = UIButton()
        backBtn.chain.normalTitle(text: title).font(.boldSystemFont(ofSize: 18)).normalTitleColor(color: .init(hexColor: "#111111")).normalImage(.init(named: "back"))
        if title.count > 0{
            backBtn.setImagePosition(.left, spacing: 4)
        }else{
            backBtn.sy_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            backBtn.size = CGSize(width: 22, height: 22)
        }
        if withBg{
            backBtn.backgroundColor = .white.withAlphaComponent(0.5)
            backBtn.layer.cornerRadius = 11
            backBtn.layer.masksToBounds = true
        }
        
        backBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    @objc func setBackTitle(_ title: String, action: @escaping Block){
        let backBtn = UIButton()
        backBtn.chain.normalTitle(text: title).font(.boldSystemFont(ofSize: 18)).normalTitleColor(color: .init(hexColor: "#111111")).normalImage(.init(named: "back"))
        if title.count > 0{
            backBtn.setImagePosition(.left, spacing: 4)
        }else{
            backBtn.sy_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            backBtn.size = CGSize(width: 20, height: 20)
        }
        backBtn.addBlock(for: .touchUpInside) { _ in
            action()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
}


class BaseVC : UIViewController{
    
    var popView: UIView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.view.backgroundColor = .init(hexString: "#F4F6F9")
        edgesForExtendedLayout = []
        configData()
        configSubViews()
        DispatchQueue.main.async { [weak self] in
            self?.decorate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReconnet), name: kUserReConnectedNetwork.name, object: nil)
    }
    
    
    func configData(){
        
    }
    
    func configSubViews(){
        
    }
    
    func decorate(){
        
    }
    
    @objc func onReconnet(){
        
    }
    
    
    
    

    
    var esHeader: ESRefreshHeaderAnimator {
        get {
            let h = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
            h.pullToRefreshDescription = "下拉刷新"
            h.releaseToRefreshDescription = "松开获取最新数据"
            h.loadingDescription = "下拉刷新..."
            return h
        }
    }
    
    var esFooter: ESRefreshFooterAnimator {
        get {
            let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            f.loadingMoreDescription = "上拉加载更多"
            f.noMoreDataDescription = "数据已加载完"
            f.loadingDescription = "加载更多..."
            return f
        }
    }
    
    
    
}
