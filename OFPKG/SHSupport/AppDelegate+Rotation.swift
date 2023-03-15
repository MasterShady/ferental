//
//  AppDelegate+Rotation.swift
//  gerental
//
//  Created by 刘思源 on 2023/3/3.
//

import Foundation


//private var kOrientationKey =  "kOrientationKey"
//
//extension AppDelegate{
////    private struct AssociatedKeys {
////        static var orientationKey = "orientation"
////    }
//
//    static var shareDelegate: AppDelegate{
//        UIApplication.shared.delegate as! AppDelegate
//    }
//
//    var orientation: UIInterfaceOrientationMask {
//        get {
//            if let value = objc_getAssociatedObject(self, &kOrientationKey) as? UIInterfaceOrientationMask{
//                return value
//            }
//            return .portrait
//
//            //objc_getAssociatedObject(self, &kOrientationKey) as? UIInterfaceOrientationMask ?? .portrait
//        }
//        set {
//            objc_setAssociatedObject(self, &kOrientationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
//        }
//    }
//
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return self.orientation
//    }
//}
