//
//  DFPublicPCH.swift
//  DoFunNew
//
//  Created by mac on 2020/12/23.
//

import UIKit
/*
 ///MARK:TODO 定义常用的类库信息, 使用@_exported关键字，就可以全局引入对应的包
 */

//@_exported import Chrysan
//@_exported import WisdomHUD

//@_exported import ZKProgressHUD


public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height

/*
 屏幕宽度
 */
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

/*
 屏幕高度
 */
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/*
 状态栏高度
 */
public let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
/*
 导航栏高度
 */
public let NAV_HEIGHT = UIApplication.shared.statusBarFrame.height + 44.0
/*
 底部TableBar高度
 */
public let TABLEBAR_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 83.0 : 49.0
/*
 底部下巴高度
 */
public let BOTTOM_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 34.0 : 0.0

public let BASE_HEIGHT_SCALE = (SCREEN_HEIGHT / 667.0)
 
public let BASE_WIDTH_SCALE = (SCREEN_WIDTH / 375.0)

/*
 导航栏基础高度
 */
public let NAVBAR_BASE_HEIGHT = CGFloat(44.0)

/*
 比例计算高度(宽度)
 */
public func SCALE_WIDTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}

/*
 比例计算高度(高度)
 */
public func SCALE_HEIGTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}

public func SW_FOUNT(size:CGFloat, weight:UIFont.Weight) -> UIFont {
    return UIFont.systemFont(ofSize: size * BASE_WIDTH_SCALE , weight: weight)
}


func SWGLog<T>(msg : T, file : String = #file, lineNum : Int = #line) {
    #if DEBUG
     let fileName = (file as NSString).lastPathComponent
     print("\(fileName):[\(lineNum)]-\(msg)")
    #endif
}

