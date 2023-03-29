//
//  PKGUIConfig.swift
//  EmotionDiary
//
//  Created by 刘思源 on 2023/3/20.
//

import Foundation
public class PKGUICinfig: NSObject{
    public static let bundle = Bundle(bundleName: "PKGModule", podName: "PKGModule")
    public static var kNavBarThemeColor = UIColor.black
    public static var kNavBackImage = UIImage(named: "left_back", in: bundle, with: nil)
    public static var kNavBarBackgroundColor = UIColor.white
    public static var kNavBarTitleFont = UIFont.boldSystemFont(ofSize: 18)
}


