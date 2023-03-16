//
//  FeedbackVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

class FeedbackVC: BaseVC, UITextViewDelegate{
    
    let placeholder = UILabel()

    override func configSubViews() {
        self.navBarBgAlpha = 0
        self.edgesForExtendedLayout = .top
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        setBackTitle("意见反馈")
       
        
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: kNavBarMaxY + 4, left: 14, bottom: 14, right: 14))
        }
        container.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let smileIcon = UIImageView()
        container.addSubview(smileIcon)
        smileIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(19)
        }
        smileIcon.image = .init(named: "feedback_smile")
        
        let helloLabel = UILabel()
        container.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(smileIcon.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        helloLabel.chain.text("亲爱的用户您好").font(.boldSystemFont(ofSize: 14)).text(color: .kDeepBlack)
        
        let adLabel = UILabel()
        container.addSubview(adLabel)
        adLabel.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        adLabel.chain.text("期待您的宝贵意见").font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "#999999"))
        
        
        
        let textView = UITextView()
        container.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(130)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(220)
        }
        
        textView.chain.backgroundColor(.kExLightGray).corner(radius: 3).clipsToBounds(true)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 13, bottom: 15, right: 13)
        textView.font = .systemFont(ofSize: 15)
        
        textView.addSubview(placeholder)
        placeholder.snp.makeConstraints { make in
            make.top.left.equalTo(15)
        }
        
        placeholder.chain.text(color: .init(hexColor: "#999999")).font(.systemFont(ofSize: 15)).text("在这里写下您想说的吧")
        
        
        let poster = Poster(layoutWidth: kScreenWidth - 56, itemSize: 60)
        container.addSubview(poster)
        poster.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(textView.snp.bottom).offset(20)
        }
        
        
        let commitBtn = UIButton()
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width:204, height:48))
        }
        commitBtn.chain.font(.boldSystemFont(ofSize: 16)).normalTitle(text: "提交").normalTitleColor(color: .kDeepBlack).backgroundColor(.kthemeColor).corner(radius: 6).clipsToBounds(true)
        
        commitBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            if textView.text.count < 10{
                AutoProgressHUD.showAutoHud("请至少输入10个字符.")
                return
            }
            AutoProgressHUD.showHud {[weak self] hide in
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    hide()
                    self?.navigationController?.popViewController(animated: true)
                    AutoProgressHUD.showAutoHud("感谢您的反馈, 我们会进行改进!")
                }
            }
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = !textView.text.isEmpty
    }
}
