//
//  ZAlertView
//
//  SWAlertView.swift
//  DoFunNew
//
//  Created by macCC on 2021/3/11.
//



import DFBaseLib

class SWAlertView: UIViewController {
    
    public static var duration:CGFloat = 0.3
    public static var statusBarStyle: UIStatusBarStyle?
    var alertWindow: UIWindow!
    public var backgroundView: UIView!
    open var alertView: UIView!
    
    
    
    
    
    
    var lbTitle: UILabel!
    var lbMessage: UILabel!
    var line: UIView!
    var line2: UIView!
    var btnOk: UIButton!
    var btnCancel: UIButton!
    
    open var alertTitle: String?
    open var message: String?
   
    open var okTitle: String? {
        didSet {
            btnOk.setTitle(okTitle, for: .normal)
        }
    }
    open var cancelTitle: String? {
        didSet {
            btnCancel.setTitle(cancelTitle, for: .normal)
        }
    }
    
    var cancelActionBlock:(()->Void)?//取消按钮回调
    var okActionBlock:(()->Void)?//确定按钮回调

    
    
    //是否允许背景点击 消失
    public var allowTouchOutsideToDismiss: Bool = false {
        didSet {
            weak var weakSelf = self
            if weakSelf != nil {
                if allowTouchOutsideToDismiss == false {
                    weakSelf!.tapOutsideTouchGestureRecognizer.removeTarget(weakSelf!, action: #selector(dismissAlertView))
                }
                else {
                    weakSelf!.tapOutsideTouchGestureRecognizer.addTarget(weakSelf!, action: #selector(dismissAlertView))
                }
            }
        }
    }
    fileprivate var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let statusBarStyle = SWAlertView.statusBarStyle {
            return statusBarStyle
        }
        return UIApplication.shared.statusBarStyle
    }
    
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
    }
    public init(title: String?, message: String?, okButtonText: String? = "确定", cancelButtonText: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
        self.alertTitle = title
        self.message = message
       
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: .normal)
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: .normal)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWindow() {
        if viewNotReady() {
            return
        }
        let window = UIWindow(frame: (UIApplication.shared.keyWindow?.bounds)!)
        self.alertWindow = window
        
        self.alertWindow.backgroundColor = UIColor.clear
        self.alertWindow.rootViewController = self
//        self.previousWindow = UIApplication.shared.keyWindow
    }
    func setupViews() {
        if viewNotReady() {
            return
        }
        self.view = UIView(frame: (UIApplication.shared.keyWindow?.bounds)!)
        
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        
        // Gesture for background
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(SWAlertView.dismissAlertView))
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        self.view.addSubview(backgroundView)
        
        // Setup alert view
        self.alertView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - SCALE_WIDTHS(value: 100), height: 0))
        self.alertView.backgroundColor = UIColor.white
        self.alertView.layer.cornerRadius = SCALE_WIDTHS(value: 15)
        self.alertView.layer.masksToBounds = true
        self.alertView.clipsToBounds = true
        self.view.addSubview(alertView)
        
        // Setup title
        self.lbTitle = UILabel()
        self.lbTitle.backgroundColor = .clear
        self.lbTitle.textAlignment = .center
        self.lbTitle.textColor = UIColor(hexString: "#333333")
        self.lbTitle.font = SW_FOUNT(size: 18, weight: .semibold)
        self.alertView.addSubview(lbTitle)
        
        // Setup message
        self.lbMessage = UILabel()
        self.lbMessage.backgroundColor = .clear
        self.lbMessage.textAlignment = NSTextAlignment.left
        self.lbMessage.numberOfLines = 0
        self.lbMessage.textColor = UIColor(hexString: "#333333")
        self.lbMessage.font = SW_FOUNT(size: 14, weight: .regular)
        self.alertView.addSubview(lbMessage)
        
        self.line = UIView()
        self.line.backgroundColor = UIColor(hexString: "#D8D8D8")
        self.alertView.addSubview(line)
        
        
        // Setup Cancel Button
        self.btnCancel = UIButton()
        self.btnCancel.backgroundColor = .clear
//        self.btnCancel.addTarget(self, action: #selector(leftItemAction(button:)), for: .touchUpInside)
        self.btnCancel.setTitleColor(UIColor(hexString: "#A1A0AB"), for: .normal)
        self.btnCancel.titleLabel?.font = SW_FOUNT(size: 15, weight: .regular);
//        self.btnCancel.setTitle("asdasd", for: .normal)
        self.btnCancel.showsTouchWhenHighlighted = false
        self.alertView.addSubview(btnCancel)
        
        self.line2 = UIView()
        self.line2.backgroundColor = UIColor(hexString: "#D8D8D8")
        self.alertView.addSubview(line2)
        
        
        // Setup OK Button
        self.btnOk = UIButton()
        self.btnOk.backgroundColor = .clear
//        self.btnOk.addTarget(self, action: #selector(leftItemAction(button:)), for: .touchUpInside)
        self.btnOk.setTitleColor(UIColor(hexString: "#FE3F6D"), for: .normal)
        self.btnOk.titleLabel?.font = SW_FOUNT(size: 15, weight: .regular);
//        self.btnOk.setTitle("asdasd", for: .normal)
        self.btnOk.showsTouchWhenHighlighted = false
        self.alertView.addSubview(btnOk)
    }
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        var hasContent = false
        
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.6
        
        if let title = self.alertTitle {
//            hasContent = true
            lbTitle.text = title
            lbTitle.width = self.alertView.width - SCALE_WIDTHS(value: 60)
            lbTitle.sizeToFit()
            lbTitle.frame = CGRect(x: SCALE_WIDTHS(value: 30), y: SCALE_WIDTHS(value: 22), width: self.alertView.width - SCALE_WIDTHS(value: 60), height: lbTitle.height)
        } else {
            lbTitle.frame = CGRect(x: SCALE_WIDTHS(value: 30), y: 0, width: self.alertView.width - SCALE_WIDTHS(value: 60), height: 0)
        }
        
        if let message = self.message {
//            hasContent = true
            lbMessage.text = message
            lbMessage.width = self.alertView.width - SCALE_WIDTHS(value: 60)
            lbMessage.sizeToFit()
            lbMessage.frame = CGRect(x: (self.alertView.width - lbMessage.width)/2, y:lbTitle.bottom + SCALE_WIDTHS(value: 16), width: lbMessage.width, height: lbMessage.height)
        } 
        
        self.line.frame = CGRect(x: 0, y: lbMessage.bottom + SCALE_WIDTHS(value: 27), width: self.alertView.width, height: 0.5)
        
        
        let okTitle = self.okTitle
        let cancelTitle = self.cancelTitle
        if (okTitle != nil) && (cancelTitle != nil){
            
            btnCancel.setTitle(cancelTitle, for: .normal)
            btnCancel.frame = CGRect(x: 0, y: self.line.bottom, width: self.alertView.width/2, height: SCALE_WIDTHS(value: 45))
            btnCancel.addTarget(self, action: #selector(cancelButtonDidTouch(_:)), for: .touchUpInside)
            
            self.line2.frame = CGRect(x: btnCancel.right, y: self.line.bottom, width: 0.5, height: SCALE_WIDTHS(value: 45))
            
            btnOk.setTitle(okTitle, for: .normal)
            btnOk.frame = CGRect(x: btnCancel.right, y: self.line.bottom, width: self.alertView.width/2, height: SCALE_WIDTHS(value: 45))
            btnOk.addTarget(self, action: #selector(okButtonDidTouch(_:)), for: .touchUpInside)
        }else{
            
            btnCancel.isHidden = true
            self.line2.isHidden = true
            
            btnOk.setTitle(okTitle, for: .normal)
            btnOk.frame = CGRect(x: 0, y: self.line.bottom, width: self.alertView.width, height: SCALE_WIDTHS(value: 45))
            btnOk.addTarget(self, action: #selector(okButtonDidTouch(_:)), for: .touchUpInside)
        }
        
        

        let bounds = UIScreen.main.bounds
        self.alertView.width = bounds.width - SCALE_WIDTHS(value: 100)
        self.alertView.height = btnOk.bottom
        self.alertView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
    }
    public func show() {
        if SWAlertView.duration < 0.1
        {
            SWAlertView.duration = 0.3
        }
        
        showWithDuration(Double(SWAlertView.duration))
    }
    public func showWithDuration(_ duration: Double) {
        if viewNotReady() {
            return
        }

        
        self.alertWindow.addSubview(self.view)
        self.alertWindow.makeKeyAndVisible()
        
        self.view.alpha = 0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.alpha = 1
        })
        
    }
    @objc public func dismissAlertView() {
        
        if SWAlertView.duration < 0.1
        {
            SWAlertView.duration = 0.3
        }
        
        dismissWithDuration(0.3)
    }
    public func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.view.removeFromSuperview()
                self.alertWindow.isHidden = true
                self.alertWindow = nil
                
            }
        }
        
        self.view.alpha = 1
        UIView.animate(withDuration: duration,
            animations: { () -> Void in
                self.view.alpha = 0
        }, completion: completion)
    }
    
    func viewNotReady() -> Bool {
        return UIApplication.shared.keyWindow == nil
    }
    
    @objc func cancelButtonDidTouch(_ sender: UIButton) {
        self.dismissAlertView()
        if cancelActionBlock != nil {
            self.cancelActionBlock!()
        }
    }
    
    @objc func okButtonDidTouch(_ sender: UIButton) {
        if okActionBlock != nil {
            self.okActionBlock!()
        }
    }
    
 
}
