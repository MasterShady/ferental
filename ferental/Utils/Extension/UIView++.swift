//
//  UIView++.swift
//  ferental
//
//  Created by 刘思源 on 2022/12/27.
//

import Foundation

extension UIView{
    func encapsulateWithInsets(_ insets: UIEdgeInsets, color: UIColor = .clear) -> UIView{
        let container = UIView()
        container.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
        container.backgroundColor = color
        return container
    }
}


//private var kTouchInsetsStoreKey: Void?
//
//extension UIView {
////    @objc class func swift_load() {
////        swizzlePointInside()
////    }
//    
//    
//    class func swizzlePointInside() {
//        let originSelector = #selector(UIView.point(inside:with:))
//        let newSelector = #selector(UIView.myPoint(inside:with:))
//
//
//        let originalMethod = class_getInstanceMethod(self, originSelector)!
//        let swizzledMethod = class_getInstanceMethod(self, newSelector)!
//        method_exchangeImplementations(originalMethod, swizzledMethod)
//    }
//
//    
//
//    var sy_touchExtendInsets: UIEdgeInsets {
//        get {
//            guard let value = objc_getAssociatedObject(self, &kTouchInsetsStoreKey) else{
//                return .zero
//            }
//            
//            if let u = value as? UIEdgeInsets {
//                return u
//            }else{
//                return .zero
//            }
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &kTouchInsetsStoreKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    @objc func myPoint(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let touchInsets = self.sy_touchAreaInsets
//        if touchInsets == UIEdgeInsets.zero || isHidden || ((self is UIControl) && !((self as? UIControl)?.isEnabled ?? false)) {
//            return myPoint(inside: point, with: event) // original implementation
//        }
//        var bounds = self.bounds
//        
//        bounds = CGRect(
//            x: bounds.origin.x - touchInsets.left,
//            y: bounds.origin.y - touchInsets.top,
//            width: bounds.size.width + touchInsets.left + touchInsets.right,
//            height: bounds.size.height + touchInsets.top + touchInsets.bottom)
//        return bounds.contains(point)
//    }
//}




