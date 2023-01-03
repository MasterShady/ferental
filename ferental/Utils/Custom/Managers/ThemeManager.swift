//
//  ThemeManager.swift
//  Dylan.Lee
//
//  Created by Dylan on 2017/9/21.
//  Copyright © 2017年 Dylan.Lee. All rights reserved.
//  全局样式设置

import UIKit

class ThemeManager {
	class func setupMainTheme() {
		
		/// the style for navigationBar
		let navAppearance = UINavigationBar.appearance()
		navAppearance.isTranslucent = false
		navAppearance.setBackgroundImage(UIImage(color: UIColor(hexColor: "#1EB3FF")), for: .any, barMetrics: .default)
        navAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0),
                                             NSAttributedString.Key.foregroundColor: UIColor.white]
		
		/// hide the title for backButton
		let barBtnItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
		
        barBtnItem.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -300, vertical: 0), for: .default)
		
		/// the style for tabbar
		let tabBarAppearance = UITabBarItem.appearance()
        tabBarAppearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0),
                                                 NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .selected)
		
        tabBarAppearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0),
                                                 NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
		tabBarAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
		
		let tabBar = UITabBar.appearance()
		tabBar.isTranslucent = false
		tabBar.shadowImage = UIImage()
		tabBar.backgroundImage = UIImage(color: .white)
	
	}
}
