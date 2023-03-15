//
//  BaseViewController.swift
//  DoFunNew
//
//  Created by mac on 2021/2/25.
//

import UIKit

open class SWBaseViewController: UIViewController ,PublicMethod{
    
    //需要 @objc 修饰 才可以赋值
   @objc open var params:Dictionary<String, Any> = [:]
    
    // MARK: - 生命函数
    open   override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(navBgView)
        navBgView.addSubview(navTitleLabel)
        navBgView.addSubview(navleftItemBtn)
        navBgView.addSubview(navLine)
        navBgView.addSubview(navRightItemBtn)
        navBgView.addSubview(navRightItemBtn2)
        
        uiConfigure();
        myAutoLayout()
        dataRequest()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - PublicMethod
    open   func uiConfigure() {
        
    }
    
    open   func myAutoLayout() {
        
    }
    
    open   func dataRequest() {
        
    }

    
    // MARK: - LAZY
    open lazy var navBgView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: NAV_HEIGHT)
        view.backgroundColor = UIColor.white
        return view
    }()
    open lazy var navTitleLabel: UILabel = {
        let label = UILabel();
        label.frame = CGRect(x: 44*2, y: STATUSBAR_HEIGHT, width: SCREEN_WIDTH - 44*4, height: 44)
        label.backgroundColor = UIColor.clear
        label.font = SW_FOUNT(size: 18, weight: .medium);
        label.textColor = UIColor(hexString: "#222222")
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    open var navTitleString: String?{
        didSet{
            guard let navTitleString = navTitleString else { return }
            navTitleLabel.text = navTitleString;
        }

    }
    
    open  lazy var navleftItemBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.setImage(UIImage(named: "nav_back_black"), for: .normal)
        button.addTarget(self, action: #selector(leftItemAction(button:)), for: .touchUpInside)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 16, weight: .regular);
        return button
    }()
    open var navLeftItemBtnTitle: String?{
        didSet{
            guard let navLeftItemBtnTitle = navLeftItemBtnTitle else { return }
            if navLeftItemBtnTitle.isEmpty {
                navleftItemBtn.isHidden = true
            }else{
                navleftItemBtn.isHidden = false
                navleftItemBtn.setImage(nil, for: .normal)
                navleftItemBtn.setTitle(navLeftItemBtnTitle, for: .normal)
                navleftItemBtn.sizeToFit();
                navleftItemBtn.frame = CGRect(x: 0, y: STATUSBAR_HEIGHT, width: navleftItemBtn.width + 34, height: 44)
            }
        }
    }
    open var navLeftItemBtnImageName: String?{
        didSet{
            guard let navLeftItemBtnImageName = navLeftItemBtnImageName else { return }
            if navLeftItemBtnImageName.isEmpty {
                navleftItemBtn.isHidden = true
            }else{
                navleftItemBtn.isHidden = false
                navleftItemBtn.setImage(UIImage(named: navLeftItemBtnImageName), for: .normal)
                navleftItemBtn.setTitle("", for: .normal)
                navleftItemBtn.frame = CGRect(x: 0, y: STATUSBAR_HEIGHT, width: 44, height: 44)
            }
        }
    }
    
    open lazy var navRightItemBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH - 44, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(rightItemAction(button:)), for: .touchUpInside)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 16, weight: .regular);
        button.isHidden = true
        return button
    }()
    open var navRightItemBtnTitle: String?{
        didSet{
            guard let navRightItemBtnTitle = navRightItemBtnTitle else { return }
            if navRightItemBtnTitle.isEmpty {
                navRightItemBtn.isHidden = true
            }else{
                navRightItemBtn.isHidden = false
                navRightItemBtn.setImage(nil, for: .normal)
                navRightItemBtn.setTitle(navRightItemBtnTitle, for: .normal)
                navRightItemBtn.sizeToFit();
                navRightItemBtn.frame = CGRect(x: SCREEN_WIDTH - navRightItemBtn.width - 34, y: STATUSBAR_HEIGHT, width: navRightItemBtn.width + 34, height: 44)
            }
            
        }
    }
    open  var navRightItemBtnImageName: String?{
        didSet{
            guard let navRightItemBtnImageName = navRightItemBtnImageName else { return }
            if navRightItemBtnImageName.isEmpty {
                navRightItemBtn.isHidden = true
            }else{
                navRightItemBtn.isHidden = false
                navRightItemBtn.setImage(UIImage(named: navRightItemBtnImageName), for: .normal)
                navRightItemBtn.setTitle("", for: .normal)
                navRightItemBtn.frame = CGRect(x: SCREEN_WIDTH - 44, y: STATUSBAR_HEIGHT, width: 44, height: 44)
            }
        }
    }
    
    open lazy var navRightItemBtn2: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH - 88, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(rightItem2Action(button:)), for: .touchUpInside)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 16, weight: .regular);
        button.isHidden = true
        return button
    }()
    open  var navRightItemBtn2Title: String?{
        didSet{
            guard let navRightItemBtn2Title = navRightItemBtn2Title else { return }
            if navRightItemBtn2Title.isEmpty {
                navRightItemBtn2.isHidden = true
            }else{
                navRightItemBtn2.isHidden = false
                navRightItemBtn2.setImage(nil, for: .normal)
                navRightItemBtn2.setTitle(navRightItemBtnTitle, for: .normal)
                navRightItemBtn2.sizeToFit();
                navRightItemBtn2.frame = CGRect(x: navRightItemBtn.left - navRightItemBtn2.width - 34, y: STATUSBAR_HEIGHT, width: navRightItemBtn2.width + 34, height: 44)
            }
            
        }
    }
    open var navRightItemBtn2ImageName: String?{
        didSet{
            guard let navRightItemBtn2ImageName = navRightItemBtn2ImageName else { return }
            if navRightItemBtn2ImageName.isEmpty {
                navRightItemBtn2.isHidden = true
            }else{
                navRightItemBtn2.isHidden = false
                navRightItemBtn2.setImage(UIImage(named: navRightItemBtn2ImageName), for: .normal)
                navRightItemBtn2.setTitle("", for: .normal)
                navRightItemBtn2.frame = CGRect(x: navRightItemBtn.left - 44, y: STATUSBAR_HEIGHT, width: 44, height: 44)
            }
        }
    }
    
    open lazy var navLine: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: NAV_HEIGHT-1, width: SCREEN_WIDTH, height: 1)
        view.backgroundColor = UIColor(hexString: "#EEEEEE")
        return view
    }()
    
    
    
    
    // MARK: - 点击事件
    //左按钮
    @objc open func leftItemAction(button:UIButton){
        navigationController?.popViewController(animated: true)
//        navigationBarLeftBtnPressed(button: button)
    }
//    func navigationBarLeftBtnPressed(button:UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
    @objc open func rightItemAction(button:UIButton){
//        navigationBarRightBtnPressed(button: button)
    }
//    func navigationBarRightBtnPressed(button:UIButton) {
//    }
    @objc open func rightItem2Action(button:UIButton){
//        navigationBarRightBtn2Pressed(button: button)
    }
//    func navigationBarRightBtn2Pressed(button:UIButton) {
//    }
    
    
    
    
    
    /**
     获取当前导航控制器
     */
    open  func currentNavViewController() -> UINavigationController? {
            var n = next
            while n != nil {
                if n is UINavigationController {
                    return n as? UINavigationController
                }
                n = n?.next
            }
            return nil
    }
    
    
    //普通二级界面导航栏设置
   open  func navigationBarConfigureNormal(_ title:String)  {
         
        self.navBgView.backgroundColor = UIColor.white
        self.navLine.isHidden = true
        self.navTitleString = title
        self.navBgView.isHidden = false
    }
    
}

