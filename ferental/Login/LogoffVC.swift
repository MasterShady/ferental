//
//  LogoffVC.swift
//  ferental
//
//  Created by 刘思源 on 2023/1/19.
//

import Foundation


class LogoffVC: BaseVC {
    
    var countdown = 60
    
//    deinit {
//        self.timer?.cancel()
//        self.timer = nil
//    }


    override func configSubViews() {
        self.navBarBgAlpha = 0
        self.edgesForExtendedLayout = [.top]
        view.backgroundColor = .init(hexColor: "#F4F6F9")
        
        setBackTitle("")
        
        let logoView = UIImageView()
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarMaxY + 4)
            make.centerX.equalToSuperview()
        }
        logoView.image = .init(named: "login_logo")
        
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(108 + kNavBarMaxY)
            make.left.right.bottom.equalToSuperview()
        }
        contentView.backgroundColor = .white
        contentView.size = CGSize(width: kScreenWidth, height: kScreenHeight - 108 - kNavBarHeight)
        contentView.addCornerRect(with: [.topLeft, .topRight], radius: 8)
        
        
        contentView.addSubview(phoneFiled)
        phoneFiled.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kX(347), height: 48))
        }
        phoneFiled.size = CGSize(width:kX(347), height: 48)
        phoneFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
        
        
//        contentView.addSubview(smsCodeFiled)
//        smsCodeFiled.snp.makeConstraints { make in
//            make.top.equalTo(phoneFiled.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width:kX(347), height: 48))
//        }
//        smsCodeFiled.size = CGSize(width:kX(347), height: 48)
//        smsCodeFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
        
        contentView.addSubview(passwdFiled)
        passwdFiled.snp.makeConstraints { make in
            make.top.equalTo(phoneFiled.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kX(347), height: 48))
        }
        passwdFiled.size = CGSize(width:kX(347), height: 48)
        passwdFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
        
        
        let registerBtn = UIButton()
        registerBtn.chain.font(.boldSystemFont(ofSize: 16)).normalTitle(text: "注销").normalTitleColor(color: .kTextBlack).corner(radius: 6).clipsToBounds(true).backgroundColor(.kthemeColor)
        contentView.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kX(347), height: 48))
            make.centerX.equalToSuperview()
            make.top.equalTo(passwdFiled.snp.bottom).offset(32)
        }
        registerBtn.addTarget(self, action: #selector(registerHandler), for: .touchUpInside)
        
        let comfirmBtn = UIButton()
        contentView.addSubview(comfirmBtn)
        comfirmBtn.snp.makeConstraints { make in
            make.top.equalTo(registerBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc func registerHandler(){
        
        guard let mobile = phoneFiled.text else{
            AutoProgressHUD.showAutoHud("请输入用户名")
            return
        }
        
        if !mobile.isPhone{
            AutoProgressHUD.showAutoHud("请输入正确的手机号")
            return
        }
        
        guard let passwd = passwdFiled.text else{
            AutoProgressHUD.showAutoHud("请输入密码")
            return
        }
        
        if passwd.count < 6 || passwd.count > 16{
            AutoProgressHUD.showAutoHud("密码位数在6-16之间")
            return
        }
        
        
        userService.request(.logoff(mobile: mobile, passwd: passwd)) {[weak self] result in
            
            switch result{
            case .success(let response):
                if let data = try? response.mapJSON() as? Dictionary<String, Any>{
                    if let success = data["success"] as? Bool{
                        if success{
                            AutoProgressHUD.showAutoHud("注销成功")
                            UserStore.currentUser = nil
                            self?.navigationController?.popViewController(animated: true)
                        }else{
                            AutoProgressHUD.showAutoHud(data["msg"] as! String)
                        }
                    }else{
                        AutoProgressHUD.showAutoHud("注销失败")
                    }
                }
            case .failure(let _):
                AutoProgressHUD.showAutoHud("注销失败")
            }
        }
        
        
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    private lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 43))
        let leftIcon = UIImageView()
        leftView.addSubview(leftIcon)
        
        leftIcon.size = CGSize(width: 23, height: 23)
        leftIcon.centerY = leftView.centerY
        leftIcon.left = 11
        leftIcon.image = .init(named: "login_phone")
        
        phoneFiled.leftView = leftView
        phoneFiled.leftViewMode = .always

        
//        phoneFiled.rightView = codeBtn
//        phoneFiled.rightViewMode = .always
        
        phoneFiled.keyboardType = .phonePad
        
        let placeholder = NSAttributedString(string: "请输入手机号", attributes: [
            .foregroundColor : UIColor(hexColor:"#AAB0C0"),
            .font : UIFont.systemFont(ofSize: 16)
        ])
        phoneFiled.attributedPlaceholder = placeholder
        phoneFiled.font = .boldSystemFont(ofSize: 16)
        phoneFiled.textColor = .kTextBlack
        phoneFiled.tintColor = .kthemeColor
        
        return phoneFiled
    }()
    

    private lazy var smsCodeFiled: UITextField = {
        let smsCodeFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 43))
        let leftIcon = UIImageView()
        leftView.addSubview(leftIcon)
        
        leftIcon.size = CGSize(width: 23, height: 23)
        leftIcon.centerY = leftView.centerY
        leftIcon.left = 11
        leftIcon.image = .init(named: "login_smscode")
        
        smsCodeFiled.leftView = leftView
        smsCodeFiled.leftViewMode = .always
        smsCodeFiled.keyboardType = .numberPad
        
        let placeholder = NSAttributedString(string: "请输入验证码", attributes: [
            .foregroundColor : UIColor(hexString: "#AAB0C0")!,
            .font : UIFont.systemFont(ofSize: 14)
        ])
        smsCodeFiled.attributedPlaceholder = placeholder
        smsCodeFiled.font = .boldSystemFont(ofSize: 16)
        smsCodeFiled.textColor = .kTextBlack
        smsCodeFiled.tintColor = .kthemeColor
        return smsCodeFiled
    }()
    
    
    private lazy var passwdFiled: UITextField = {
        let passwdFiled = UITextField()
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 43))
        let leftIcon = UIImageView()
        leftView.addSubview(leftIcon)
        
        leftIcon.size = CGSize(width: 23, height: 23)
        leftIcon.centerY = leftView.centerY
        leftIcon.left = 11
        leftIcon.image = .init(named: "login_password")
        
        passwdFiled.leftView = leftView
        passwdFiled.leftViewMode = .always
        passwdFiled.isSecureTextEntry = true
        passwdFiled.keyboardType = .alphabet
        
        let placeholder = NSAttributedString(string: "请输入登录密码", attributes: [
            .foregroundColor : UIColor(hexColor:"#AAB0C0"),
            .font : UIFont.systemFont(ofSize: 16)
        ])
        passwdFiled.attributedPlaceholder = placeholder
        passwdFiled.font = .boldSystemFont(ofSize: 16)
        passwdFiled.textColor = .kTextBlack
        passwdFiled.tintColor = .kthemeColor
        return passwdFiled
    }()


}
