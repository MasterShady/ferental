//
//  MBProgressHUD+View.swift
//  DoFunNew
//
//  Created by mac on 2021/3/11.
//

import UIKit
import MBProgressHUD

public extension MBProgressHUD {
    static func showCustomToast(message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = 2.0,isTranslucent: Bool = false, customView:UIView? = nil) {
        

        if customView != nil {
            let hud = MBProgressHUD.showAdded(to: view!, animated: true)
            hud.backgroundColor = .clear
            hud.tintColor = .clear
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0)
            hud.mode = .customView
            hud.customView = customView!
            hud.animationType = .zoom
            hud.isSquare = true
            hud.removeFromSuperViewOnHide = true
            
            hud.hide(animated: true, afterDelay: afterDelay)
            
        }else {
            let HUD = createHud(view: view, isMask: isMask, isTranslucent: isTranslucent)
            HUD?.mode = .text
            HUD?.detailsLabel.font = SW_FOUNT(size: 14.0, weight: .regular)
            HUD?.detailsLabel.text = message
            HUD?.detailsLabel.textColor = UIColor(hexString: "#FFFFFF")
            
            HUD?.hide(animated: true, afterDelay: afterDelay)
            
           
        }
    }
    
   
        /// 创建Hud
       ///
       /// - Parameters:
       ///   - view: 加载到哪个View展示.
       ///   - isMask: 是否是蒙层形式,背景半透明.
       ///   - isTranslucent: 项目中navigationBar是否计算frame,默认是false,如果项目中有调用self.navigationController?.navigationBar.isTranslucent = true则传入true
       private static func createHud(view : UIView? = UIApplication.shared.keyWindow, isMask : Bool = false ,isTranslucent: Bool = false) -> MBProgressHUD? {
           guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
           let HUD = MBProgressHUD.showAdded(to: supview
               , animated: true)
           HUD.animationType = .zoom
           if isMask {
               /// 蒙层type,背景半透明.
               HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
           } else {
               /// 非蒙层type,没有背景.
               HUD.backgroundView.color = UIColor.clear
               HUD.bezelView.style = .solidColor
               HUD.bezelView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
               HUD.bezelView.layer.cornerRadius = SCALE_HEIGTHS(value: 25.0)
               HUD.contentColor = UIColor.white
           }
           HUD.removeFromSuperViewOnHide = true
           HUD.show(animated: true)
           return HUD
       }
}


public extension MBProgressHUD {
    
    
     enum HUDPostion: Int {
        case top, center, bottom
    }
    
    /// toast提示
    /// - Parameter text: 提示文本
     class func show(text: String) {
        show(text: text, postion: .center, to: UIApplication.shared.delegate!.window!)
    }
    
    
    /// toast提示
    /// - Parameter text: 提示文本
    ///   - view: 父视图
     class func show(text: String, to view: UIView?) {
        show(text: text, postion: .center, to: view)
    }
    
    
    /// toast提示
    /// - Parameter text: 提示文本
    ///   - view: 父视图
    ///   - view: 位置
     class func show(text: String, postion: HUDPostion, to view: UIView?) {
        let hud = MBProgressHUD.showAdded(to: (view ?? UIApplication.shared.delegate!.window!)!, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .init(white: 0, alpha: 0)
        hud.bezelView.layer.masksToBounds = false
        hud.isUserInteractionEnabled = false
        hud.mode = .customView
        
        let size = CGSize(width: UIScreen.main.bounds.width - 2*16 - 36, height: CGFloat(MAXFLOAT))
        let font = UIFont(name: "PingFangSC-Regular", size: 14 * (UIScreen.main.bounds.width/375.0))
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: [.font: font!] , context:nil)
        hud.minSize = CGSize(width: rect.width + 36, height: 40)
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width + 36, height: rect.height > 40 ? rect.height + 20 : 40))
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = font
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = textLabel.bounds.height*0.5
        hud.bezelView.addSubview(textLabel)
        
        hud.margin = 20
        hud.set(postion: postion)
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.2)
    }
    
    
    /// 设置hud位置
    /// - Parameter postion: 位置枚举
    private func set(postion: HUDPostion) {
        switch postion {
        case .top: offset = CGPoint(x: 0, y: -MBProgressMaxOffset)
        case .center: offset = .zero
        case .bottom: offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        }
    }
    
    
}
