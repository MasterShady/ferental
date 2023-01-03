//
//  Layout.swift
//  BestInsYear
//
//  Created by Mayqiyue on 2019/12/17.
//  Copyright © 2019 mayqiyue. All rights reserved.
//

import UIKit

///**
//notch: 有刘海的手机
//noNoth: 无刘海的手机
//*/
//func kX(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, _ pad: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
//    if UIDevice.current.userInterfaceIdiom == .pad {
//        return (pad == .greatestFiniteMagnitude ? notch : pad) * ( UIScreen.main.bounds.size.width / 375)
//    }
//    if UIDevice.current.hasNotch || noNotch == .greatestFiniteMagnitude {
//        return notch * (UIScreen.main.bounds.size.width / 375)
//    } else {
//        return noNotch * (UIScreen.main.bounds.size.width / 375)
//    }
//}
//
//func kY(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, _ pad: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
//    if UIDevice.current.userInterfaceIdiom == .pad {
//        return (pad == .greatestFiniteMagnitude ? notch : pad) * ( UIScreen.main.bounds.size.height / 812)
//    }
//    if UIDevice.current.hasNotch || noNotch == .greatestFiniteMagnitude {
//        return notch * (UIScreen.main.bounds.size.height / 812)
//    } else {
//        return noNotch * (UIScreen.main.bounds.size.height / 812)
//    }
//}
//
//func kIsIpad() -> Bool {
//    return UIDevice.current.userInterfaceIdiom == .pad
//}
//
//func kHasNotch() -> Bool {
//    return UIDevice.current.hasNotch
//}
//
//func ScreenWidth() -> CGFloat {
//    return UIScreen.main.bounds.size.width
//}
//
//func ScreenHeight() -> CGFloat {
//    return UIScreen.main.bounds.size.height
//}
//
//func StatusBarHeight() -> CGFloat {
//    return UIDevice.current.statusBarHeight
//}
//
//func NaviHeight() -> CGFloat {
//    return StatusBarHeight() + 44
//}
//
//func BottomNotchHeight() -> CGFloat {
//    return UIDevice.current.bottomNotchHeight
//}
//
//extension UIDevice {
//    var hasNotch: Bool {
//        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
//        return bottom > 0
//    }
//    var statusBarHeight: CGFloat {
//        if let top = UIApplication.shared.keyWindow?.safeAreaInsets.top, top > 0 {
//            return top
//        }
//        return 20
//    }
//    var bottomNotchHeight: CGFloat {
//        if let size = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, size > 0 {
//            return size
//        }
//        return 0
//    }
//    var tabbarHeight: CGFloat {
//        return 49
//    }
//}
