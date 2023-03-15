//
//  SWLoginGameLoadingView.swift
//  DoFunNew
//
//  Created by mac on 2021/7/12.
//

import Foundation
import Lottie
import DFToGameLib

class lolm_shanghao_loading_dfview: UIView {
    /** 上号提示信息5秒更换一次 */
    
    
    var lolmp_currentTimer:DispatchSourceTimer?
    
    weak  var targetView:UIView!
    
    var lolmp_msgArray:[String] = [] {
        
        didSet{
            
            guard lolmp_msgArray.count > 0 else {
                
                return
            }
            msgLabel.text = lolmp_msgArray[0]
            
            lolmp_currentTimer =  DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
            
            lolmp_currentTimer?.schedule(deadline: DispatchTime.now(), repeating: 5)
            
            var index = 1
            
            lolmp_currentTimer?.setEventHandler {
                 
                if index >= self.lolmp_msgArray.count{
                    
                    index = 0
                }
                
                self.msgLabel.text = self.lolmp_msgArray[index]
                
                index += 1
            }
            
            lolmp_currentTimer?.resume()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                
                self.progress.progress = 0.2
                self.lolmp_progressNumLabel.text = "20%"
                self.lolmp_progressMsgLabel.text = "正在检测本地环境中..."
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(80)) {
                self.progress.progress = 0.45
                self.lolmp_progressNumLabel.text = "45%"
                self.lolmp_progressMsgLabel.text = "正在校验..."
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(100)) {
                self.progress.progress = 0.6
                self.lolmp_progressNumLabel.text = "60%"
                self.lolmp_progressMsgLabel.text = "正在获取数据..."
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(300)) {
                self.progress.progress = 0.9
                self.lolmp_progressNumLabel.text = "90%"
                self.lolmp_progressMsgLabel.text = "准备就绪，正在启动游戏..."
            }
            
        }
    }
    
    /// 加载时显示文字 *
    var lolmp_show_text:String = "" {
        
        
        didSet{
            
            msgLabel.textAlignment = .center
            
            msgLabel.text = lolmp_show_text
            
            self.lolmp_progressMsgLabel.isHidden = true
            
            self.progress.isHidden = true
            
            self.lolmp_progressNumLabel.isHidden = true
        }
    }
    
    var closeBlock:(()->())?
    
    
    deinit {
        
        self.lolmp_currentTimer?.cancel()
        self.lolmp_currentTimer = nil
    }
    
    
    lazy var lolmp_animationView:AnimationView = {
        
        let view = AnimationView.init(name: "lolm_tb_game")
        
        view.contentMode = .scaleAspectFill
        
        view.loopMode = .loop
        
        return view
    }()
    
    lazy var lolmp_progressBackView:UIView = {
        
        let view = UIView()
        
        return view
    }()
    
    lazy var lolmp_progressNumLabel:UILabel = {
        
        let label = UILabel.lol_getLaberl(content: "0%", fontsize: 12,color: UIColor.init(hexString: "#FF6080"))
        
        return label
    }()
    
    
    lazy var progress:UIProgressView = {
        
        let view = UIProgressView.init(progressViewStyle: .default)
        
        view.trackTintColor = UIColor.init(hexString: "#FFDCE3")
        
        view.progressTintColor = UIColor.init(hexString: "#FF6080")
        
        view.progress = 0
        
        view.layer.cornerRadius = 3
        
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var lolmp_progressMsgLabel:UILabel = {
        
        let label = UILabel.lol_getLaberl(content: "正在检测本地环境中...", fontsize: 14,color: UIColor.init(hexString: "#333333"))
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var msgLabel:UILabel = {
        
        let label = UILabel.lol_getLaberl(content: "", fontsize: 12,color: UIColor.init(hexString: "#A1A0AB"))
        
        return label
    }()
    
    
    lazy var closeBtn:UIButton = {
        
        let btn = UIButton.init(type: .custom)
        
        btn.setImage(UIImage.init(named: "left_back"), for: .normal)
        
        btn.addTarget(self, action: #selector(loldf_closeBtnClicked), for: .touchUpInside)
        
        return btn
    }()
    
   
    
   static  func lolmp_loadingView() -> lolm_shanghao_loading_dfview {
        
        let view = lolm_shanghao_loading_dfview.init(frame: UIScreen.main.bounds)
        
        view.uiConfigure()
        
        
        return view
    }
    
    func uiConfigure()  {
        
        addSubview(lolmp_animationView)
        addSubview(lolmp_progressBackView)
        lolmp_progressBackView.addSubview(lolmp_progressNumLabel)
        lolmp_progressBackView.addSubview(progress)
        addSubview(lolmp_progressMsgLabel)
        addSubview(msgLabel)
        addSubview(closeBtn)
        
        
        lolmp_animationView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(SCALE_HEIGTHS(value: 105) + STATUSBAR_HEIGHT)
            make.size.equalTo(CGSize(width: SCALE_WIDTHS(value: 208), height: SCALE_WIDTHS(value: 208)))
        }
        
        lolmp_progressBackView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self)
            make.top.equalTo(lolmp_animationView.snp.bottom)
            make.height.equalTo(SCALE_HEIGTHS(value: 44))
        }
        
        lolmp_progressNumLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(lolmp_progressBackView)
            make.left.equalTo(lolmp_progressBackView).offset(SCALE_WIDTHS(value: 90))
            make.height.equalTo(SCALE_HEIGTHS(value: 13))
        }
        
        progress.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(lolmp_progressBackView)
            make.left.equalTo(lolmp_progressNumLabel.snp.right).offset(SCALE_WIDTHS(value: 6))
            make.size.equalTo(CGSize(width: SCALE_WIDTHS(value: 164), height: SCALE_HEIGTHS(value: 6)))
        }
        
        lolmp_progressMsgLabel.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self)
            make.top.equalTo(lolmp_progressBackView.snp.bottom)
        }
        
        msgLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(lolmp_progressMsgLabel.snp.bottom).offset(SCALE_HEIGTHS(value: 8))
            make.left.equalTo(self).offset(SCALE_WIDTHS(value: 80))
            make.right.equalTo(self).offset(SCALE_WIDTHS(value: -80))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(SCALE_WIDTHS(value: 15))
            make.top.equalTo(self).offset(SCALE_HEIGTHS(value: 8 ) + STATUSBAR_HEIGHT)
            make.width.height.equalTo(32)
        }
    }
    
    
    func lottie_play()  {
        
        lolmp_animationView.play()
    }
    
    
    func lottie_pause()  {
        
        lolmp_animationView.pause()
    }
    
    @objc func loldf_closeBtnClicked()  {
        
        
        self.closeBlock?()
    }
}


extension lolm_shanghao_loading_dfview:SWLoginGameLoadingViewProtocol{
    
    
    func play() {
        
        lottie_play()
    }
    
    func suspend() {
        
        lottie_pause()
    }
    
    func hidden() {
        lottie_pause()
        self.removeFromSuperview()
        
    }
    
    func show() {
       
        targetView.addSubview(self)
        
        lottie_play()
        
    }
    
    
    
}
