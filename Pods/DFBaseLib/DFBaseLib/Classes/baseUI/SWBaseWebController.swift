//
//  SWBaseWebController.swift
//  DoFunNew
//
//  Created by mac on 2021/3/4.
//

import UIKit
import WebKit
import SnapKit


open class SWBaseWebController: SWBaseViewController, WKNavigationDelegate, WKUIDelegate {

    private var requestUrl:String?
    public  var _requestUrl:String {
        set{
            requestUrl = newValue
            
        }
        get{
            requestUrl!
        }
    }
    
    private var navTitle:String?
    public var _navTitle:String {
        set{
            navTitle = newValue
        }
        get{
            navTitle!
        }
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navLine.backgroundColor = .white
        navLeftItemBtnImageName = "nav_back_black"
        
        if let dic = params as? [String:String]  {
           
            
            if let _url = dic["url"] {
               
                requestUrl = _url
            }
           
            if let _title = dic["nav"]{
                
                navTitle = _title
            }
        }
        
        navTitleString = navTitle
        
        guard let url =  requestUrl, url.count > 0 else {
            
            return
        }
        
        webView.load(URLRequest(url: URL(string: "\(url)")!))
    }
    
    override open func leftItemAction(button: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    open override func uiConfigure() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        //webview添加观察者
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        navBgView.addSubview(progressView)
        
    }
    
    open override func myAutoLayout() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: NAV_HEIGHT, left: 0, bottom: 0, right: 0))
        }
        progressView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(navBgView)
            make.height.equalTo(SCALE_HEIGTHS(value: 2.0))
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    
    
   open  lazy var webView:WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    open lazy var progressView:UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .white
        progressView.progressTintColor = .green
        return progressView
    }()
    
    deinit {
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
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
