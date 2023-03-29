//
//  TabbarVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit


class TabbarVC : UITabBarController, UITabBarControllerDelegate{
    
    
    override func viewDidLoad() {
        
        UITabBarItem.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(hexString: "#333333")!,
            .font : UIFont.boldSystemFont(ofSize: 10)
        ], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(hexString: "#808080")!,
            .font : UIFont.systemFont(ofSize: 10)
        ], for: .normal)
        
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage(color: .white)
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(hexString: "#333333")
        self.delegate = self
        addChilds()
    }
    
    
    func addChilds(){
        let childs : [(String,String,BaseVC)] = [
            ("home","首页",HomeVC()),
            ("brand","购物车",CartVC()),
            ("order","订单",OrderPageVC()),
            ("mine", "我的",MineVC()),
        ];
        
        for child in childs {
            let imageName = child.0
            let selectedImageName = imageName + "_selected"
            let navVC = NavVC(rootViewController: child.2)
            let normalImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
            navVC.tabBarItem.image = normalImage ?? selectedImage
            navVC.tabBarItem.selectedImage = selectedImage
            navVC.tabBarItem.title = child.1
            navVC.tabBarItem.setTitleTextAttributes([
                .foregroundColor: UIColor(hexString: "#333333")!,
                .font : UIFont.boldSystemFont(ofSize: 10)
            ], for: .selected)
            
            navVC.tabBarItem.setTitleTextAttributes([
                .foregroundColor: UIColor(hexString: "#808080")!,
                .font : UIFont.systemFont(ofSize: 10)
            ], for: .normal)
            
            navVC.hidesBottomBarWhenPushed = true
            
            self.addChild(navVC)
            
        }
        
    }
}
