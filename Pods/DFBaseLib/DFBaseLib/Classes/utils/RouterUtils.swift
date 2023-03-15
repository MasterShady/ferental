//
//  RouterUtils.swift
//  DoFunNew
//
//  Created by mac on 2021/3/17.
//

import UIKit

 @objc public protocol DFRouterUtilsProtocol:NSObjectProtocol {
     
      func APPDelegateMainWindow() -> UIWindow
}

public class RouterUtils {
    //获取当前控制器
    public class func currentTopViewController() -> UIViewController? {
        
        var window:UIWindow?
        
        if let delegate = UIApplication.shared.delegate as? DFRouterUtilsProtocol {
            
            window =  delegate.APPDelegateMainWindow()
            
        }else{
            
            window = UIApplication.shared.keyWindow
        }
        
        
        let rootController = window?.rootViewController
        if let tabController = rootController as? UITabBarController   {
            if let navController = tabController.selectedViewController as? UINavigationController{
                return navController.children.last
            }else{
                return tabController
            }
        }else if let navController = rootController as? UINavigationController {
            return navController.children.last
        }else{
            return rootController
        }
    }
    
    
    /**
     根据类名获取类控制器
     */
    public class func classFromString(_ vcname:String,moduleName:String) -> UIViewController.Type {
        
        var clsName = ""
        
        if moduleName == "" {
            
            clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String//这是获取项目的名称，
            
        }else{
            
            clsName = moduleName
        }
        
        
        let className = clsName + "." + vcname
        let viewC = NSClassFromString(className)! as! UIViewController.Type //这里需要指定类的类型XX.Type
        return viewC
    }
    
}

public typealias RouterParameter = [String:Any]
public protocol Routable {
    /**
     初始化方法
     params 传参字典
     */
    static func initWithParams(params:RouterParameter?) -> UIViewController
}

public protocol RouterPathable {
    var any:AnyClass { get }
    var params:RouterParameter? { get }
}

open class Router {
    open class func openTel(_ phone:String) {
        if let url = URL(string: "tel://\(phone)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //页面跳转
    open class func open(_ vcname:String, moduleName:String = "",params:Dictionary<String, Any> = [:], present:Bool = false, animated:Bool = true, presentComplete:(()->Void)? = nil) {
        
        let temp = RouterUtils.classFromString(vcname,moduleName: moduleName)
        let vc = temp.init()
        
        SWGLog(msg: "vc ==== \(vc)")
        
        let topViewController = RouterUtils.currentTopViewController()
        SWGLog(msg: "topViewController ==== \(topViewController!)")
        vc.hidesBottomBarWhenPushed = true
        
        //传参数
        if !params.isEmpty {
            //swift 使用kvc赋值的变量必须有 @objc 修饰
            vc.setValue(params, forKey: "params")
        }
        
        if topViewController?.navigationController != nil && !present {
            topViewController?.navigationController?.pushViewController(vc, animated: animated)
        }else {
            topViewController?.present(vc, animated: animated, completion: presentComplete)
        }
    }
    
    //页面返回
    open class func pop(_ vcname:String? = nil, moduleName:String = "", params:Dictionary<String, Any> = [:], present:Bool = false, animated:Bool = true, presentComplete:(()->Void)? = nil) {
        
        //传参数 -- 需要传参数时，必须传vcname
        if !params.isEmpty && vcname != nil {
            
            //要返回界面vc
            let temp = RouterUtils.classFromString(vcname!,moduleName: moduleName)
            let vc = temp.init()
            
            //swift 使用kvc赋值的变量必须有 @objc 修饰
            vc.setValue(params, forKey: "params")
        }
        
        let topViewController = RouterUtils.currentTopViewController()
        if topViewController?.navigationController != nil && !present {
            topViewController?.navigationController?.popViewController(animated: animated)
        }else {
            topViewController?.dismiss(animated: animated, completion: presentComplete)
        }
    }
    
}
