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
        self.view.backgroundColor = .init(hexString: "#F4F6F9")
        edgesForExtendedLayout = []
        configData()
        configSubViews()
        DispatchQueue.main.async { [weak self] in
            self?.decorate()
        }
    }
    
    
    func configData(){
        
    }
    
    func configSubViews(){
        
    }
    
    func decorate(){
        
    }
    
    
    func setBackTitle(_ title: String){
        let backBtn = UIButton()
        backBtn.chain.normalTitle(text: title).font(.boldSystemFont(ofSize: 18)).normalTitleColor(color: .init(hexColor: "#111111")).normalImage(.init(named: "back"))
        if title.count > 0{
            backBtn.setImagePosition(.left, spacing: 4)
        }else{
            backBtn.sy_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            backBtn.size = CGSize(width: 20, height: 20)
        }
        
        backBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    func setBackTitle(_ title: String, action: @escaping Block){
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
