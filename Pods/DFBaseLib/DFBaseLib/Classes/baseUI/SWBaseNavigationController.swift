//
//  BaseNavigationController.swift
//  DoFunNew
//
//  Created by mac on 2020/12/23.
//

import UIKit

open class  SWBaseNavigationController: UINavigationController, UINavigationControllerDelegate {

    var popDelegate:UIGestureRecognizerDelegate?
    
   public  override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /*
     改变导航栏的颜色
     */
    private var navColor:UIColor?
    var tempColor:UIColor {
        set{
            navColor = newValue
            if navColor != nil {
                self.navigationBar.barTintColor = navColor
            }else {
                self.navigationBar.barTintColor = .red
            }
        }
        get{
            return (self.navColor)!
        }
    }
    
    public func changerNavBarColor(navColor:UIColor) {
        
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBar的背景,字体，字体颜色设置
//        self.navigationBar.barTintColor = .red
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor:UIColor.white]
        
        //返回手势
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // UIGestureRecognizerDelegate代理
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            //实现滑动返回的功能
            //清空滑动返回手势的代理就可以实现
            if viewController == self.viewControllers[0]{
                self.interactivePopGestureRecognizer?.delegate = self.popDelegate
            }else{
                self.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        
    //    拦截跳转事件
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0{
                viewController.hidesBottomBarWhenPushed = true
            }
            super.pushViewController(viewController, animated: true)
        }
        /// 返回上一控制器
        @objc private func navigationBack() {
            popViewController(animated: true)
        }
    public override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
