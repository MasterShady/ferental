//
//  NavVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit

class NavVC: UINavigationController, UINavigationControllerDelegate {
    private static let initializer: Void = {
        
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(hexColor: "#111111"),
                                          .font: UIFont.boldSystemFont(ofSize: 18)]
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = .init(hexColor: "#C1F00C")
        UINavigationBar.appearance().tintColor = .init(hexColor: "#111111")
        
//        //
//        let backButtonImage = UIImage(named: "back")
//        //自定义返回icon
//        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
//        //隐藏返回按钮文字
//        appearance.backButtonAppearance.normal.titleTextAttributes = [
//            .foregroundColor : UIColor.clear]
        
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }()
    
    private let initializer: Void = NavVC.initializer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = self

    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0){
            viewController.hidesBottomBarWhenPushed = true;
        }
        if let viewController = viewController as? BaseVC{
            viewController.setBackTitle("")
        }
        super.pushViewController(viewController, animated: animated)
    }

    

}
