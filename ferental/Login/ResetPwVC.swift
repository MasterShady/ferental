//
//  ResetPwVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

class ResetPwVC: BaseVC {

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
        loginLabel.chain.font(.boldSystemFont(ofSize: 24)).text(color: .kBlue).text("设置新密码")
        
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
        
        passwdField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(290)
        }
        moduleContainer.addModule(passwdField)
        
        passwdField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(290)
        }
        moduleContainer.addModule(passwdField)
        
        comfirmField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(290)
        }
        moduleContainer.addModule(comfirmField,beforeSpacing: 16)
        
        
        let nextBtn = UIButton()
        nextBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 263, height: 52))
        }
        nextBtn.chain.backgroundColor(.kBlue).normalTitle(text: "确定").normalTitleColor(color: .white).font(.boldSystemFont(ofSize: 16)).corner(radius: 2).clipsToBounds(true)
        nextBtn.addTarget(self, action: #selector(commit), for: .touchUpInside)
        
        moduleContainer.addModule(nextBtn,beforeSpacing: 28)
        
    }
    
    @objc func commit(){
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private lazy var passwdField: UITextField = {
        let passwdFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        passwdFiled.leftView = leftView
        passwdFiled.leftViewMode = .always
        passwdFiled.isSecureTextEntry = true
        passwdFiled.keyboardType = .alphabet
        
        let rightView : UIView = {
            let view = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 52))
            view.snp.makeConstraints { make in
                make.width.equalTo(38)
                make.height.equalTo(52)
            }
            
            let eyeView = UIImageView()
            view.addSubview(eyeView)
            eyeView.frame = CGRect(x: 0, y: 14, width: 24, height: 24)
            eyeView.image = .init(named: "eye_open")
            view.addBlock(for: .touchUpInside) { [weak self] _ in
                if let self = self{
                    self.passwdField.isSecureTextEntry = !self.passwdField.isSecureTextEntry
                    eyeView.image = .init(named: self.passwdField.isSecureTextEntry ? "eye_open" : "eye_close" )
                }
            }
            return view
        }()
        
        passwdFiled.rightView = rightView
        passwdFiled.rightViewMode = .always
        
        passwdFiled.backgroundColor = .init(hexColor: "#F9F9F9")
        let placeholder = NSAttributedString(string: "请输入新密码", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "#CACACF")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ])
        passwdFiled.attributedPlaceholder = placeholder
        passwdFiled.font = .boldSystemFont(ofSize: 16)
        passwdFiled.textColor = .black
        return passwdFiled
    }()
    
    private lazy var comfirmField: UITextField = {
        let passwdFiled = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        passwdFiled.leftView = leftView
        passwdFiled.leftViewMode = .always
        passwdFiled.isSecureTextEntry = true
        passwdFiled.keyboardType = .alphabet
        
        let rightView : UIView = {
            let view = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 52))
            view.snp.makeConstraints { make in
                make.width.equalTo(38)
                make.height.equalTo(52)
            }
            
            let eyeView = UIImageView()
            view.addSubview(eyeView)
            eyeView.frame = CGRect(x: 0, y: 14, width: 24, height: 24)
            eyeView.image = .init(named: "eye_open")
            view.addBlock(for: .touchUpInside) { [weak self] _ in
                if let self = self{
                    self.comfirmField.isSecureTextEntry = !self.comfirmField.isSecureTextEntry
                    eyeView.image = .init(named: self.comfirmField.isSecureTextEntry ? "eye_open" : "eye_close" )
                }
            }
            return view
        }()
        
        passwdFiled.rightView = rightView
        passwdFiled.rightViewMode = .always
        
        passwdFiled.backgroundColor = .init(hexColor: "#F9F9F9")
        let placeholder = NSAttributedString(string: "确认新密码", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "#CACACF")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ])
        passwdFiled.attributedPlaceholder = placeholder
        passwdFiled.font = .boldSystemFont(ofSize: 16)
        passwdFiled.textColor = .black
        return passwdFiled
    }()

}
