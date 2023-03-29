//
//  NavVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit

extension UIViewController{
    @objc func setBackTitle(_ title: String, withBg:Bool = false){
        let backBtn = UIButton()
        backBtn.setTitle(title, for: .normal)
        backBtn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        backBtn.setTitleColor(PKGUICinfig.kNavBarThemeColor, for: .normal)
        backBtn.setImage(PKGUICinfig.kNavBackImage, for: .normal)
        if title.count > 0{
            backBtn.pkg_setImagePosition(.left, spacing: 4)
        }else{
            backBtn.pkg_touchAreaInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            backBtn.size = CGSize(width: 22, height: 22)
        }
        if withBg{
            backBtn.backgroundColor = .white.withAlphaComponent(0.5)
            backBtn.layer.cornerRadius = 11
            backBtn.layer.masksToBounds = true
        }
        
        backBtn.addTarget(self, action: #selector(pop), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
}

@objcMembers public class NavVC: UINavigationController, UINavigationControllerDelegate {
    private static let initializer: Void = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor:PKGUICinfig.kNavBarThemeColor,
                                          .font: PKGUICinfig.kNavBarTitleFont]
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = PKGUICinfig.kNavBarBackgroundColor
        UINavigationBar.appearance().tintColor = PKGUICinfig.kNavBarThemeColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }()
    
    private let initializer: Void = NavVC.initializer
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0){
            viewController.hidesBottomBarWhenPushed = true;
        }
        if viewController.responds(to: #selector(UIViewController.setBackTitle(_:withBg:))){
            viewController.setBackTitle("")
        }
        super.pushViewController(viewController, animated: animated)
    }
}
