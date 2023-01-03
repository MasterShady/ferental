//
//  ForgetPwVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

class ForgetPwVC: BaseVC {
    
    var phone: String?
    var countdown = 60

    override func configSubViews() {
        self.edgesForExtendedLayout = [.top]
        let headerBgView = UIImageView()
        view.addSubview(headerBgView)
        headerBgView.snp.makeConstraints { make in
            make.height.equalTo(184)
            make.left.right.top.equalToSuperview()
        }
        headerBgView.image = .init(named: "login_header_bg")
        
        let leftItem = UIBarButtonItem(image: .init(named: "back"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(112)
            make.left.right.bottom.equalToSuperview()
        }
        contentView.backgroundColor = .white
        contentView.size = CGSize(width: kScreenWidth, height: kScreenHeight - 112)
        contentView.addCornerRect(with: [.topLeft], radius: 40)
        
        let cycleView = UIImageView()
        contentView.addSubview(cycleView)
        cycleView.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.left.equalTo(43)
        }
        cycleView.image = .init(named: "login_header_cycle")
        
        let loginLabel = UILabel()
        contentView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(cycleView)
            make.left.equalTo(cycleView)
        }
        loginLabel.chain.font(.boldSystemFont(ofSize: 24)).text(color: .kBlue).text("忘记密码")
        
        let helloLabel = UILabel()
        contentView.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(10)
            make.left.equalTo(loginLabel)
        }
        helloLabel.chain.font(.systemFont(ofSize: 13)).text(color: .kBlue).text("Hello")
        
        let moduleContainer = ModuleContainer()
        contentView.addSubview(moduleContainer)
        moduleContainer.snp.makeConstraints { make in
            make.top.equalTo(98)
            make.width.equalTo(290)
            make.centerX.equalToSuperview()
        }
        
        
        self.phoneFiled.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(290)
        }
        moduleContainer.addModule(self.phoneFiled)
        
        moduleContainer.addSpacer(spacing: 16)
        
        self.smsCodeFiled.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(290)
        }
        moduleContainer.addModule(self.smsCodeFiled)
        
        let nextBtn = UIButton()
        nextBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 263, height: 52))
        }
        nextBtn.chain.backgroundColor(.kBlue).normalTitle(text: "下一步").normalTitleColor(color: .white).font(.boldSystemFont(ofSize: 16)).corner(radius: 2).clipsToBounds(true)
        nextBtn.addTarget(self, action: #selector(nextHandler), for: .touchUpInside)
        
        moduleContainer.addModule(nextBtn,beforeSpacing: 28)
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getSmsCode(){
        codeBtn.isEnabled = false
        timer.start(withInterval: 1)
        AutoProgressHUD.showAutoHud("验证码已经发送")
    }
    
    @objc func tik(){
        print("tik")
        codeBtn.isEnabled = false
        countdown -= 1
        codeBtn.setTitle(String(format:"%zd s",countdown), for: .disabled)
        if (countdown == 0) {
            timer.cancel()
            countdown = 60
            codeBtn.isEnabled = true
        }
    }
    
    @objc func nextHandler(){
        let vc = ResetPwVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        phoneFiled.leftView = leftView
        phoneFiled.leftViewMode = .always
        phoneFiled.backgroundColor = .init(hexColor: "#F9F9F9")
        phoneFiled.keyboardType = .phonePad
        
        let placeholder = NSAttributedString(string: "输入手机号", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "#CACACF")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ])
        phoneFiled.attributedPlaceholder = placeholder
        phoneFiled.font = .boldSystemFont(ofSize: 16)
        phoneFiled.textColor = .black
        if let phone = phone{
            phoneFiled.text = phone
        }
        return phoneFiled
    }()
    

    private lazy var smsCodeFiled: UITextField = {
        let smsCodeFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        smsCodeFiled.leftView = leftView
        smsCodeFiled.leftViewMode = .always
        smsCodeFiled.keyboardType = .numberPad
        
        let rightView : UIView = {
            codeBtn.snp.makeConstraints { make in
                make.width.equalTo(93)
                make.height.equalTo(52)
            }
            codeBtn.addTarget(self, action: #selector(getSmsCode), for: .touchUpInside)
            return codeBtn
        }()
        
        smsCodeFiled.rightView = rightView
        smsCodeFiled.rightViewMode = .always
        
        smsCodeFiled.backgroundColor = .init(hexColor: "#F9F9F9")
        let placeholder = NSAttributedString(string: "请输入短信验证码", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "#CACACF")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ])
        smsCodeFiled.attributedPlaceholder = placeholder
        smsCodeFiled.font = .boldSystemFont(ofSize: 16)
        smsCodeFiled.textColor = .black
        return smsCodeFiled
    }()
    
    lazy var codeBtn : UIButton = {
        let codeBtn = UIButton()
        codeBtn.chain.normalTitle(text: "获取验证码").normalTitleColor(color: .kBlue).font(.systemFont(ofSize: 16))
            .titleColor(color: .kLightGray, for: .disabled)
        return codeBtn
    }()
    
    lazy var timer: CancelableTimer = {
        let timer = CancelableTimer(once: false) { [weak self] in
            DispatchQueue.main.async {
                self?.tik()
            }
        }
        return timer
    }()

}
