//
//  LolmDF_RealNameLotterySuccAlertView.swift
//  lolmTool
//
//  Created by coconut on 2022/5/30.
//

import UIKit
import DFBaseLib

class LolmDF_RealNameLotterySuccAlertView: lolm_base_widget {
    
    
    override func uiConfigure() {
        addSubview(bgImageView)
        addSubview(closeBtn)
        addSubview(titleLabel)
        addSubview(lotteryButton)
        addSubview(contentLabel)
    }
    
    override func myAutoLayout() {
        bgImageView.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 266.5))
            make.width.equalTo(SCALE_WIDTHS(value: 326.0))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-SCALE_HEIGTHS(value: 50.0))

        }
        closeBtn.snp.makeConstraints { make in
            make.centerX.equalTo(bgImageView)
            make.top.equalTo(bgImageView.snp.bottom).offset(SCALE_HEIGTHS(value: 44.0))
            make.width.height.equalTo(SCALE_WIDTHS(value: 34.0))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView).offset(SCALE_HEIGTHS(value: 37.5))
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(28.0)
        }
        lotteryButton.snp.makeConstraints { make in
            make.bottom.equalTo(bgImageView).offset(-SCALE_HEIGTHS(value: 48.5))
            make.centerX.equalTo(bgImageView)
            make.width.equalTo(SCALE_WIDTHS(value: 215.0))
            make.height.equalTo(SCALE_HEIGTHS(value: 40.0))
        }
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lotteryButton.snp.top).offset(-SCALE_HEIGTHS(value: 27.0))
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(22.0)
        }
    }
    
    //MARK: Action
    @objc var btnActionClourse:((Int)->())?
    
    @objc private func closeBtnClickAction() {
        //Close
        if btnActionClourse != nil {
            btnActionClourse!(1)
        }
    }
    
    @objc private func lotteryBtnClickAction() {
        //跳转抽奖页面
        if btnActionClourse != nil {
            btnActionClourse!(2)
        }
    }
    
    //MARK: Lazy Vars
    private lazy var bgImageView:UIImageView = {
        let bgImg = UIImageView.init(image: UIImage(named: "sw_realnamealert_succ_bg"))
        return bgImg
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "lolm_maintain_alertclose"), for: .normal)
        button.addTarget(self, action: #selector(closeBtnClickAction), for: .touchUpInside)
        button.showsTouchWhenHighlighted = false
        return button
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "完成认证抽大奖"
        label.font = SW_FOUNT(size: 20.0, weight: .semibold)
        label.textColor = .hexColor("#C93151")
        return label
    }()
    
    private lazy var lotteryButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage(named: "sw_realnamealert_succ_btn"), for: .normal)
        button.addTarget(self, action: #selector(lotteryBtnClickAction), for: .touchUpInside)
        button.showsTouchWhenHighlighted = false
        button.setTitle("前往抽奖", for: .normal)
        button.setTitleColor(.hexColor("#B1192F"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 15, weight: .medium)
        return button
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.text = "恭喜您，实名认证成功"
        label.textColor = .hexColor("#FFFFFF")
        label.font = SW_FOUNT(size: 15.0, weight: .regular)
        return label
    }()

}
