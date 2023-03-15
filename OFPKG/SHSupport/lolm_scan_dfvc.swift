//
//  SWScanCodeController.swift
//  DoFunNew
//
//  Created by mac on 2021/3/31.
//

import UIKit
import AVFoundation
import AEAlertView

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


/**
 扫码登录
 */
@available(iOS 11.0, *)
@objcMembers class lolm_scan_dfvc: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var lolp_session:AVCaptureSession! //输入输出的中间桥梁
    
    var device:AVCaptureDevice! //获取摄像设备
    
    var lolp_input:AVCaptureDeviceInput! //创建输入流
    
    var output:AVCaptureMetadataOutput! ///创建输出流
    
    var layer:AVCaptureVideoPreviewLayer! //扫描窗口
    
    var lolp_qrcodeOutBlock:((String?)->())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionStartRunning(notificaiton: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configSubViews()
        setBackTitle("",withBg: false)
    }

    
    
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //代理 AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            lolp_session.stopRunning()
            //执行扫码登录官网操作
            let metadataObject:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            guard let value = metadataObject.stringValue else { return }
            if  !value.isEmpty {
                lolp_qrcodeOutBlock?(value)
            }
            
        }
    }
    
    
    //从蒙版中抠出扫描框那一块，这块的大小尺寸将来也是扫描输出的作用域大小
    private func bezierPathForScan() {
    
        let maskPath:UIBezierPath = UIBezierPath(rect: lolp_scanView.bounds)
        maskPath.append(UIBezierPath(rect: CGRect(x: (SCREEN_WIDTH - SCALE_WIDTHS(value: 233.0)) * 0.5, y: (SCREEN_HEIGHT - SCALE_WIDTHS(value: 233.0)) * 0.5, width: SCALE_WIDTHS(value: 233.0), height: SCALE_WIDTHS(value: 233.0))))
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillColor = UIColor.red.cgColor
        lolp_scanView.layer.mask = maskLayer
    }
    
    //判断相机权限
    private func checkCaptureStatus(With:@escaping (Bool)->()) {
        
        let authorizationStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .authorized {
            
            With(true)

        }else if authorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if !granted {
                    With(false)
                }else{
                    
                    With(true)
                }
            }
        }else {
            //没有权限提示去设置相机权限
            AEAlertView.show(title: "相机访问受限", message: "请在iPhone的\"设置-隐私-相机\"选项中, 允许访问你的相机", actions: ["退出页面","我知道了"]) { action in
                if (action.title == "我知道了"){
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //初始化扫描需要用的相关实例变量
    private func initScanningContent() {
        //获取摄像设备
        guard let dev = AVCaptureDevice.default(for: .video) else { return }
        
        device = dev
        
        //创建输入流
        do{
            lolp_input = try AVCaptureDeviceInput(device: device)
        } catch {
            //LolmDFLog(msg: error)
        }
        
        //创建输出流
        output = AVCaptureMetadataOutput()
        //设置代理 在主线程里刷新
        output.setMetadataObjectsDelegate((self as AVCaptureMetadataOutputObjectsDelegate), queue: DispatchQueue.main)
        //初始化链接对象
        lolp_session = AVCaptureSession()
        //高质量采集率
        if lolp_session.canSetSessionPreset(.high) {
            lolp_session.sessionPreset = .high
        }
        //添加输入输出流
        lolp_session.addInput(lolp_input)
        lolp_session.addOutput(output)
        
        //设置扫码支持的编码格式(条形码和二维码兼容)
        output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
        
        layer = AVCaptureVideoPreviewLayer(session: lolp_session)
        layer.videoGravity = .resizeAspectFill
        
        //设置相机可视范围 -- 全屏
        layer.frame = view.bounds
        lolp_scanView.layer.insertSublayer(layer, at: 0)
        
        //开始捕获
        lolp_session.startRunning()
        
        //设置扫描作用范围(中间透明层的扫描框)
        output.rectOfInterest = layer.metadataOutputRectConverted(fromLayerRect: CGRect(x: (SCREEN_WIDTH - SCALE_WIDTHS(value: 233.0)) * 0.5, y: (SCREEN_HEIGHT - SCALE_WIDTHS(value: 233.0)) * 0.5, width: SCALE_WIDTHS(value: 233.0), height: SCALE_WIDTHS(value: 233.0)))
        
    }
    
    
    /**
     扫描动画
     */
    @objc private func timerFired() {
        //吃出key不能为空，否则不执行动画
        lolp_activeImageView.layer.add(moveY(time: 2.5, y: SCALE_WIDTHS(value: 233.0 - 20.0)), forKey: "active-scan")
    }
    
    
    /**
     *  扫描线动画
     *
     *  @param time 单次滑动完成时间
     *  @param y    滑动距离
     *
     *  @return 返回动画
     */
    private func moveY(time:CFTimeInterval, y:CGFloat) -> CABasicAnimation { //核心动画
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y") // .y向下移动
        animation.toValue = y
        animation.duration = time
        animation.isRemovedOnCompletion = true //结束返回原来位置
        animation.repeatCount = MAXFLOAT
        animation.fillMode = .forwards
        return animation
    }
    
    @objc private func sessionStartRunning(notificaiton:NSNotification?) {
        if lolp_session != nil {
            lolp_session.startRunning()
            //开始动画
            self.performSelector(onMainThread: #selector(timerFired), with: nil, waitUntilDone: false)
        }
    }
    
    
    
    func configSubViews() {
        
//        navLine.backgroundColor = .clear
//        navBgView.backgroundColor = UIColor(white: 0, alpha: 0)
//        navLeftItemBtnImageName = "nav_back_white"
        
        view.insertSubview(lolp_scanView, at: 0)
        
        view.addSubview(lolp_scanImageView)
        view.addSubview(lolp_activeImageView)
        
        //抠图
        bezierPathForScan()
        
        //监听 app 从后台返回前台，重新扫描
        NotificationCenter.default.addObserver(self, selector: #selector(sessionStartRunning(notificaiton:)), name: NSNotification.Name(rawValue: UIApplication.didBecomeActiveNotification.rawValue), object: nil)
        //开始动画
        self.performSelector(onMainThread: #selector(timerFired), with: nil, waitUntilDone: false)
            //判断相机权限
        checkCaptureStatus { result in
            guard result else {
                DispatchQueue.main.async {
                    self.pop()
                }
                return
            }
            //初始化扫描相关变量
            DispatchQueue.main.async {
                self.initScanningContent()
            }
        }
    }
    

    lazy var lolp_scanView:UIView = {
        let scanView = UIView()
        scanView.frame = view.frame
        scanView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.49)
        return scanView
    }()
    
    //扫描框的四个边角背景图
    lazy var lolp_scanImageView:UIImageView = {
        let scanImageView = UIImageView()
        scanImageView.frame  = CGRect(x: (SCREEN_WIDTH - SCALE_WIDTHS(value: 233.0)) * 0.5, y: (SCREEN_HEIGHT - SCALE_WIDTHS(value: 233.0)) * 0.5, width: SCALE_WIDTHS(value: 233.0), height: SCALE_WIDTHS(value: 233.0))
        scanImageView.image = .init(named: "scan_bg_icon")
        return scanImageView
    }()
    
    //扫描中间横线
    lazy var lolp_activeImageView:UIImageView = {
        let activeImageView = UIImageView()
        activeImageView.frame = CGRect(x: (SCREEN_WIDTH - SCALE_WIDTHS(value: 273.0)) * 0.5, y: (SCREEN_HEIGHT - SCALE_WIDTHS(value: 233.0)) * 0.5, width: SCALE_WIDTHS(value: 273.0), height: SCALE_HEIGTHS(value: 20.0))
        activeImageView.image = .init(named: "active_line_icon")
        return activeImageView
    }()
    
    
    deinit {
        if lolp_session != nil {
            lolp_session.stopRunning()
            lolp_session = nil
        }
    }
}
