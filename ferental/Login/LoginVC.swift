//
//  LoginVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/19.
//

import UIKit


class LoginVC: BaseVC {

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
        
        contentView.addSubview(passwdFiled)
        passwdFiled.snp.makeConstraints { make in
            make.top.equalTo(phoneFiled.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kX(347), height: 48))
        }
        passwdFiled.size = CGSize(width:kX(347), height: 48)
        passwdFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
        
        
        let loginBtn = UIButton()
        contentView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwdFiled.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kX(347), height: 48))
        }
        loginBtn.chain.font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .kTextBlack).normalTitle(text: "登录")
            .corner(radius: 6).clipsToBounds(true).backgroundColor(.kthemeColor)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let registerBtn = UIButton()
        contentView.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let raw = "还没有账号？去注册"
        let attrTitle = NSMutableAttributedString(string: raw, attributes: [
            .font : UIFont.systemFont(ofSize: 11),
            .foregroundColor : UIColor(hexColor: "#AAB0C0")
        ])
        
        registerBtn.chain.normalAttributedTitle(attrTitle)
        
        registerBtn.addBlock(for: .touchUpInside) { [weak self] _ in
            let des = RegisterVC()
            self?.navigationController?.pushViewController(des, animated: true)
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func login(){
        guard let phone = phoneFiled.text else {
            AutoProgressHUD.showAutoHud("请输入手机号")
            return
        }
        
        guard let passwd = passwdFiled.text else{
            AutoProgressHUD.showAutoHud("请输入登录密码")
            return
        }
        
        if(!phone.isPhone){
            AutoProgressHUD.showAutoHud("请输入正确的手机号")
            return
        }
        
        if (passwd.count < 6 || passwd.count > 16){
            AutoProgressHUD.showAutoHud("密码错误")
        }
        
        userService.request(.login(mobile:phone, passwd: passwd)) { result in
            switch result{
            case .failure(let error): AutoProgressHUD.showAutoHud(error.localizedDescription)
            case .success(let response): print("~~22")
            }
        }
        
    }

}
