//
//  lolm_actDetail_share_alert_view.swift
//  lolmTool
//
//  Created by cc苹果盒子 on 2022/6/21.
//

import UIKit

class lolm_actDetail_share_alert_view: lolm_base_widget {
    var showPoster: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(showPoster:Bool){
        self.showPoster = showPoster
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
    }
    
    
    func viewforHeight() ->(CGFloat){
        //temp
        return shareDataSource.count > 4 ? SCALE_WIDTHS(value: 238) + SCALE_WIDTHS(value: 54) + BOTTOM_HEIGHT :  SCALE_WIDTHS(value: 151) + SCALE_WIDTHS(value: 54) + BOTTOM_HEIGHT
    }
    
    
    //展示
    func show() {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: TimeInterval(0.35)) {
            self.backgroundColor = UIColor.init(hexString: "#000000").withAlphaComponent(0.6)
            self.bgView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(0)
            }
            self.layoutIfNeeded()
        }
    }
    //显示
    func dismiss() {
        UIView.animate(withDuration: TimeInterval(0.35)) {
            self.backgroundColor = .clear
            self.bgView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(self.viewforHeight())
            }
            self.layoutIfNeeded()
        } completion: { result in
            self.removeFromSuperview()
        }
    }
    
    //点击取消
    @objc open func cancelBtnAction(button:UIButton){
        dismiss();
    }
    
    var itemBtnClickedBlock:((Int)->())?
    @objc func itemClicked(with:UIControl)  {
        itemBtnClickedBlock?(with.tag)
        self.dismiss()
    }
    
    func updataContentBgView() {
        contentBgView.subviews.forEach{$0.removeFromSuperview()}
        
        let width:CGFloat = SCALE_WIDTHS(value: 50)
        let height:CGFloat = SCALE_WIDTHS(value: 72)
        
        let padding = SCALE_WIDTHS(value: 40)
        
        let space = (SCREEN_WIDTH - padding * 2 - width * 4)/3
        
        for (index,item) in shareDataSource.enumerated() {
            
            let btn = UIControl.init(frame: CGRect.zero)
            btn.tag = index
#if MJ_EmotionDiary
             if index > 1 {
                 btn.tag = index + 2
             }
#endif
            let  column = index/4
            let  row = index%4
            
            contentBgView.addSubview(btn)
            
            btn.snp.makeConstraints { make in
                
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.left.equalTo(padding + CGFloat(row)*(width + space))
                make.top.equalTo(CGFloat(column) * (height + SCALE_WIDTHS(value: 15)))
            }
            
            btn.addTarget(self, action: #selector(itemClicked(with: )), for: .touchUpInside)
            
            let img = UIImageView.init(image: .init(named: item.1))
            btn.addSubview(img)
            img.snp.makeConstraints { make in
                make.width.height.equalTo(width)
                make.top.equalTo(0)
                make.left.equalTo(0)
            }
            
            let label = UILabel.lol_getLaberl(content: item.0, fontsize: 14, color: .hexColor("#A1A0AB"), isbold: false)
            btn.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalTo(btn)
                make.top.equalTo(img.snp.bottom).offset(SCALE_WIDTHS(value: 7))
            }
        }
        
    }
    
    override func uiConfigure() {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLabel)
        self.bgView.addSubview(self.contentBgView)
        self.bgView.addSubview(self.line1)
        self.bgView.addSubview(self.cancelBtn)
        self.bgView.addSubview(self.line2)
    }
    override func myAutoLayout() {
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(viewforHeight())
            make.bottom.equalTo(self.snp.bottom).offset(viewforHeight())
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        bgView.layer.cornerRadius = SCALE_WIDTHS(value: 20)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp.top).offset(SCALE_WIDTHS(value: 18))
            make.height.equalTo(SCALE_WIDTHS(value: 18))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
        }
        
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(SCALE_WIDTHS(value: 18))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.bottom.equalTo(self.cancelBtn.snp.top)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelBtn.snp.top)
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.height.equalTo(1)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-BOTTOM_HEIGHT)
            make.height.equalTo(SCALE_WIDTHS(value: 54))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
        }
        
        line2.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.bottom)
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.height.equalTo(SCALE_WIDTHS(value: 20))
        }
        self.layoutIfNeeded()
        updataContentBgView()
    }
    
    
    
    
    
 
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = SW_FOUNT(size: 18, weight: .semibold)
        label.textColor = UIColor(hexString: "#222222")
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "分享到"
        return label
    }()
    lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#EEEEEE")
        return view
    }()
    lazy var cancelBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("取消分享", for: .normal)
        button.setTitleColor(UIColor(hexString: "#222222"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 16, weight: .regular)
        button.addTarget(self, action: #selector(cancelBtnAction(button:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = false
        return button
    }()
    lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //[("微信","sw_freeplay_share_icon1"),("朋友圈","sw_freeplay_share_icon4"),("QQ","sw_freeplay_share_icon3"),("QQ空间","sw_freeplay_share_icon2"),
    private lazy var shareDataSource:[(String,String)] = {
        var btnsdata:[(String,String)]!
        if (showPoster){
            btnsdata = [("复制链接","sw_actdetail_share_copyLink"),("生成海报","sw_actdetail_share_haibao")]
        }else{
            btnsdata = [("复制链接","sw_actdetail_share_copyLink")]
        }
        return btnsdata
    }()
}



