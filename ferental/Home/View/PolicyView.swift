//
//  PolicyView.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit
import YYKit

class PolicyView: BaseView {
    
    var resultHandler: BoolBlock?
    
    //var contentLabel: UILabel!
    
    
    override func configSubviews() {
        self.backgroundColor = .white
        self.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(330 + kBottomSafeInset)
        }
        self.size = CGSize(width: kScreenWidth, height: 332 + kBottomSafeInset)
        self.addCornerRect(with: [.topLeft, .topRight], radius: 12)
        
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
        }
        titleLabel.chain.font(.boldSystemFont(ofSize: 18)).text("服务协议与隐私政策提示").text(color: .kDeepBlack)
        
        let contentLabel = YYLabel()
        self.addSubview(contentLabel)
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - 16 * 2
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        contentLabel.numberOfLines = 0
        
        
        let p1 = "欢迎使用游易租APP!我们非常重视您的个人信息和隐私保护。为了更好的保障您的个人权益，在您使用我们的产品前，请您认真阅读 《服务隐私政策服务协议与隐私政策》的全部内容，以便我们向您提供更优质的服务!!\n\n我们承诺将尽全力保护您的个人信息及合法权益，感谢你的信任\n\n*根据法律规定，若您不同意，将无法使用账号相关功能"
        let p2 = "《服务隐私政策服务协议与隐私政策》"
        let p3 = "*根据法律规定，若您不同意，将无法使用账号相关功能"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
        
        let attrString = NSMutableAttributedString(string: p1, attributes: [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor(hexColor: "#585960"),
            .paragraphStyle : paragraphStyle
        ])
        
        
        attrString.setTextHighlight((p1 as NSString).range(of: p2), color: UIColor(hexColor: "#3A5692"), backgroundColor: .yellow) { view, attrText, range, rect in
            UIApplication.shared.open(URL(string:"http://app.cywj.info/static/privacies.html")!)
        }
        
        
        attrString.setAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.init(hexColor: "#999999"),
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ], range: (p1 as NSString).range(of: p3))
        
        contentLabel.attributedText = attrString
        contentLabel.isUserInteractionEnabled = true
//        contentLabel.addGestureRecognizer(tapGesture)
        
        
        
        
        let agreeBtn = UIButton()
        addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 44))
            make.centerX.equalToSuperview().offset(60 + 9)
            make.bottom.equalTo(-kBottomSafeInset)
        }
        agreeBtn.chain.normalTitle(text: "同意").normalTitleColor(color: .kDeepBlack).font(.boldSystemFont(ofSize: 14)).backgroundColor(.kthemeColor).corner(radius: 4).clipsToBounds(true)
        agreeBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            
            self?.popDismiss()
            self?.resultHandler?(true)
        }
        
        let disagreeBtn = UIButton()
        addSubview(disagreeBtn)
        disagreeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 44))
            make.centerX.equalToSuperview().offset(-60 - 9)
            make.bottom.equalTo(-kBottomSafeInset)
        }
        disagreeBtn.chain.normalTitle(text: "不同意").normalTitleColor(color: .kDeepBlack).font(.boldSystemFont(ofSize: 14)).border(color:.kDeepBlack).border(width: 1).corner(radius: 4).clipsToBounds(true)
        
        disagreeBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.resultHandler?(false)
        }
    }
}
