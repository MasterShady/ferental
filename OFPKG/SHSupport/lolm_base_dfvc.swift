//
//  lolm_base_dfvc.swift
//  lolmTool
//
//  Created by mac on 2022/3/2.
//


import UIKit
//import ThinkingSDK


public func SCALE_WIDTHS_NEW(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let doubleValue = Double(String(format:"%.2f",width)) ?? 0
    return CGFloat(doubleValue)
}

public func SCALE_HEIGTHS_NEW(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let doubleValue = Double(String(format:"%.2f",width)) ?? 0
    return CGFloat(doubleValue)
}


//TDScreenAutoTracker

open class  lolm_base_navVC: UINavigationController, UINavigationControllerDelegate {
    
    public func getTrackProperties() -> [AnyHashable : Any] {
        return ["#title":""]
    }
    public func getScreenUrl() -> String {
        return ""
    }
    
    var lolmp_isDDok:Bool = false
    var lolmp_sdWWsd = ""
    var lolmp_chAFin:String = "ok"
    
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
                
                self.interactivePopGestureRecognizer?.delegate = nil
            }else{
                
                if viewController is UIGestureRecognizerDelegate {
                    
                    self.interactivePopGestureRecognizer?.delegate = viewController as! UIGestureRecognizerDelegate
                }else{
                    
                    self.interactivePopGestureRecognizer?.delegate = self.popDelegate
                }
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


//TDScreenAutoTracker, PublicMethod,DFAppFeatureUserProtocol

open class lolm_base_dfvc: UIViewController ,UIGestureRecognizerDelegate{
    
    public func getTrackProperties() -> [AnyHashable : Any] {
        return ["#title":""]
    }
    public func getScreenUrl() -> String {
        return ""
    }
    deinit {
        
        #if DEBUG
        
        print("\(type(of: self)) -> \(self) deinit")
        
        #endif
    }
    
    //需要 @objc 修饰 才可以赋值
   @objc open var params:Dictionary<String, Any> = [:]
    
    var lolmp_isok:Bool = false
    var lolmp_sdsd = ""
    var lolmp_chin:String = "ok"
    
//    if ([nowClass isEqualToString:@"DFOrderDetailController"] || [nowClass isEqualToString:@"DFFreePlayController"] || [nowClass isEqualToString:@"DFMineController"]
//        ) {
//        return NO;
//    }else{
//        return YES;
//    }
    
    //订单详情 免费玩  我的页面 隐藏
     func appFeatures() -> [String:Any] {
        
        return ["DFRandomRedPacketFeature":true]
    }
    
    
    
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
        
        
        
        //DFAPPFeatureManager.dealFeatureList(with: appFeatures())
        
        
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
        label.frame = CGRect(x: 44.0*2, y: STATUSBAR_HEIGHT, width: SCREEN_WIDTH - 44.0*4, height: 44)
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
        button.frame = CGRect(x: 3, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
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
                navleftItemBtn.frame = CGRect(x: 3, y: STATUSBAR_HEIGHT, width: navleftItemBtn.width + 34, height: 44)
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
                navleftItemBtn.frame = CGRect(x: 3, y: STATUSBAR_HEIGHT, width: 44, height: 44)
            }
        }
    }
    
    open lazy var navRightItemBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH - 44 - 3, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(rightItemAction(button:)), for: .touchUpInside)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 14, weight: .regular);
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
                navRightItemBtn.frame = CGRect(x: SCREEN_WIDTH - navRightItemBtn.width - 34 - 3, y: STATUSBAR_HEIGHT, width: navRightItemBtn.width + 34, height: 44)
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
                navRightItemBtn.frame = CGRect(x: SCREEN_WIDTH - 44-3, y: STATUSBAR_HEIGHT, width: 44, height: 44)
            }
        }
    }
    
    open lazy var navRightItemBtn2: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH - 88-3, y: STATUSBAR_HEIGHT, width: 44, height: 44)//STATUSBAR_HEIGHT
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

