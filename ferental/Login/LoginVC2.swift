//
//
////
////  LoginVC.swift
////  gerental
////
////  Created by 刘思源 on 2022/12/19.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import Moya
//
//
//typealias MoyaResult<Type> = Result<Type, MoyaError>
//
//func generateRandom11DigitString() -> String {
//    var result = ""
//    for _ in 0..<11 {
//        let randomNumber = Int(arc4random_uniform(10))
//        result += String(randomNumber)
//    }
//    return result
//}
//
//enum ValidationResult {
//    case ok(message: String)
//    case empty
//    case validating
//    case failed(message: String)
//}
//
//extension ValidationResult {
//    var isValid: Bool {
//        switch self {
//        case .ok:
//            return true
//        default:
//            return false
//        }
//    }
//}
//
//
//
//class LoginViewModel{
//
//
//
//    let validatedUsername: Driver<ValidationResult>
//    let validatedPasswd: Driver<ValidationResult>
//    let loginBtnValid: Driver<Bool>
//    let signIn: Observable<Bool>
//
//    init(input: (
//        phone: Driver<String>,
//        passwd: Driver<String>,
//        tap: Observable<Void>
//    )) {
//
//
//
//        /*step2:viewModel的内部需要对传入的信号进行处理和转换, 然后输出一个新的信号供外部使用
//         所以这里要对账号密码进行判断.
//         flatMapLatest 是一种操作符，可以在流式数据编程中使用。它的作用是将一个流映射成另一个流，并且只保留最近的流。
//
//         假设有一个流 A，当你对它执行 flatMapLatest 操作时，它会把 A 流中的每一个元素映射成一个新的流 B。这样，你就得到了一个新的流，这个新流中包含了所有 B 流的元素。
//
//         flatMapLatest 的最重要的特点就是它会抛弃除了最新的流之外的所有流。当一个新的元素进入流 A 时，它会被映射成一个新的流 B'，并且抛弃之前的所有流。这样做的好处是，你可以保证最新的数据始终是最新的。
//
//         它通常用在需要获取最新的数据的场景下。
//
//         例如，假如有一个用户输入的流，它会持续不断地发出新的输入。当用户输入了新的值时，我们希望能够立即发送请求并获取最新的数据。这时我们就可以使用 flatMapLatest 来实现这个需求。
//
//         一般在附加作用为异步的时候可以体现, Demo中对会在服务端判断用户名是否合法, 所以用了flatMapLatest. 我们这里判断在本地是同步的所以不需要
//
//         */
//
//        validatedUsername = input.phone.flatMap{ userName in
//            if userName.isPhone{
//                return .just(ValidationResult.ok(message:"ok"))
//            }
//            return .just(ValidationResult.failed(message:"请输入正确的手机"))
//        }
//
//        validatedPasswd = input.passwd.flatMap { passwd in
//            if passwd.count > 16 || passwd.count < 6{
//                return .just(ValidationResult.failed(message:"请输入正确的密码"))
//            }
//            return .just(ValidationResult.ok(message:"ok"))
//        }
//
//
//        loginBtnValid = Driver.combineLatest(validatedUsername, validatedPasswd) {
//            $0.isValid && $1.isValid
//        }.distinctUntilChanged()
//
//
//        let usernameAndPassword = Driver.combineLatest(input.phone, input.passwd)
//
//
////        let a = input.tap.withLatestFrom(usernameAndPassword).flatMapLatest { (phone,passwd) in
////            print("~~flatMapLatest")
////            return userService.rx.request(.login(mobile:phone , passwd: passwd)).map { response in
////                do {
////                    let user = try response.hj_map(UserAccount.self, atKeyPath: "data")
////                    UserStore.currentUser = user
////                    return Result<UserAccount, MoyaError>.success(user)
////                }
////                catch let error{
////                    return MoyaResult.failure(error as! MoyaError)
////                }
////
////            }
////        }
//
//        signIn = input.tap.withLatestFrom(usernameAndPassword).flatMapLatest { (phone,passwd) in
//            print("~~flatMapLatest")
//            return userService.rx.request(.login(mobile:phone , passwd: passwd)).map { response in
//                do {
//                    let user = try response.hj_map(UserAccount.self, atKeyPath: "data")
//                        UserStore.currentUser = user
//                        return Result<UserAccount, MoyaError>.success(user)
//                }
//                catch let error{
//                    return MoyaResult.failure(error as! MoyaError)
//                }
//
//
//            }.asObservable()
//
//                .map { user in
//                print("~~map bool")
//                return true
//            }
//        }
//
//    }
//}
//
//
//class LoginVC2: BaseVC {
//
//    var disposeBag = DisposeBag()
//
//    private lazy var phoneFiled: UITextField = {
//        let phoneFiled = UITextField()
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 43))
//        let leftIcon = UIImageView()
//        leftView.addSubview(leftIcon)
//
//        leftIcon.size = CGSize(width: 23, height: 23)
//        leftIcon.centerY = leftView.centerY
//        leftIcon.left = 11
//        leftIcon.image = .init(named: "login_phone")
//
//        phoneFiled.leftView = leftView
//        phoneFiled.leftViewMode = .always
//        phoneFiled.keyboardType = .phonePad
//
//        let placeholder = NSAttributedString(string: "请输入手机号", attributes: [
//            .foregroundColor : UIColor(hexColor:"#AAB0C0"),
//            .font : UIFont.systemFont(ofSize: 16)
//        ])
//        phoneFiled.attributedPlaceholder = placeholder
//        phoneFiled.font = .boldSystemFont(ofSize: 16)
//        phoneFiled.textColor = .kTextBlack
//        phoneFiled.tintColor = .kthemeColor
//
//        return phoneFiled
//    }()
//
//    private lazy var passwdFiled: UITextField = {
//        let passwdFiled = UITextField()
//
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 43))
//        let leftIcon = UIImageView()
//        leftView.addSubview(leftIcon)
//
//        leftIcon.size = CGSize(width: 23, height: 23)
//        leftIcon.centerY = leftView.centerY
//        leftIcon.left = 11
//        leftIcon.image = .init(named: "login_password")
//
//        passwdFiled.leftView = leftView
//        passwdFiled.leftViewMode = .always
//        passwdFiled.isSecureTextEntry = true
//        passwdFiled.keyboardType = .alphabet
//
//        let placeholder = NSAttributedString(string: "请输入登录密码", attributes: [
//            .foregroundColor : UIColor(hexColor:"#AAB0C0"),
//            .font : UIFont.systemFont(ofSize: 16)
//        ])
//        passwdFiled.attributedPlaceholder = placeholder
//        passwdFiled.font = .boldSystemFont(ofSize: 16)
//        passwdFiled.textColor = .kTextBlack
//        passwdFiled.tintColor = .kthemeColor
//        return passwdFiled
//    }()
//
//    override func configSubViews() {
//        /**
//                    参考RxSwift Demo 中的代码 进行 rx + mvvm 的改造
//                    Step1. 构建viewModel对象, viewModel 接收 Controller 中所有的输入. 在demo中点击事件 触发的的网络请求 交由了 service 来处理,
//         这里 service 和 viewModel的组合关系 我们可以2种方案都实现一遍.
//
//
//         */
//
//
//
//        self.navBarBgAlpha = 0
//        self.edgesForExtendedLayout = [.top]
//        view.backgroundColor = .init(hexColor: "#F4F6F9")
//
//        setBackTitle("")
//
//        let logoView = UIImageView()
//        view.addSubview(logoView)
//        logoView.snp.makeConstraints { make in
//            make.top.equalTo(kNavBarMaxY + 4)
//            make.centerX.equalToSuperview()
//        }
//        logoView.image = .init(named: "login_logo")
//
//
//        let contentView = UIView()
//        view.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(108 + kNavBarMaxY)
//            make.left.right.bottom.equalToSuperview()
//        }
//        contentView.backgroundColor = .white
//        contentView.size = CGSize(width: kScreenWidth, height: kScreenHeight - 108 - kNavBarHeight)
//        contentView.addCornerRect(with: [.topLeft, .topRight], radius: 8)
//
//
//        contentView.addSubview(phoneFiled)
//        phoneFiled.snp.makeConstraints { make in
//            make.top.equalTo(14)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: kX(347), height: 48))
//        }
//        phoneFiled.size = CGSize(width:kX(347), height: 48)
//        phoneFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
//
//        let phoneHint = UILabel()
//        contentView.addSubview(phoneHint)
//        phoneHint.snp.makeConstraints { make in
//            make.top.equalTo(phoneFiled.snp.bottom).offset(5)
//            make.left.equalTo(phoneFiled).offset(43)
//        }
//        phoneHint.chain.text("请输入正确的手机号").font(.systemFont(ofSize: 11)).text(color: .red)
//
//        contentView.addSubview(passwdFiled)
//        passwdFiled.snp.makeConstraints { make in
//            make.top.equalTo(phoneFiled.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: kX(347), height: 48))
//        }
//        passwdFiled.size = CGSize(width:kX(347), height: 48)
//        passwdFiled.addBorder(with: .kGrayBorderColor, width: 0.5, borderType: .bottom)
//
//
//        let loginBtn = UIButton()
//        contentView.addSubview(loginBtn)
//        loginBtn.snp.makeConstraints { make in
//            make.top.equalTo(passwdFiled.snp.bottom).offset(32)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: kX(347), height: 48))
//        }
//        loginBtn.chain.font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .kTextBlack).disableTitleColor(color: .white).normalTitle(text: "登录")
//            .corner(radius: 6).clipsToBounds(true).normalBackgroundImage(.init(color: .kthemeColor)).disabledBackgroundImage(.init(color: .kExLightGray))
//
//        let registerBtn = UIButton()
//        contentView.addSubview(registerBtn)
//        registerBtn.snp.makeConstraints { make in
//            make.top.equalTo(loginBtn.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//        }
//
//        let raw = "还没有账号？去注册"
//        let attrTitle = NSMutableAttributedString(string: raw, attributes: [
//            .font : UIFont.systemFont(ofSize: 11),
//            .foregroundColor : UIColor(hexColor: "#AAB0C0")
//        ])
//
//
//
//        /*
//         这里的phoneFiled.rx.text 是 ControlProperty. 需要转换成Driver来共享附加作用.
//         所谓的共享附加作用, 简单的理解为 当一个ObsevableType 被多处订阅时 需要通过共享附加作用来进行单次的响应. 最典型的就是网络请求.
//         所以对于text来说,可能被多处共享, 但是对于点击tap来说, 一般一个btn只会添加一个action来进行响应.
//         */
//        let viewModel = LoginViewModel(input: (
//            phone: phoneFiled.rx.text.orEmpty.asDriver(),
//            passwd: passwdFiled.rx.text.orEmpty.asDriver(),
//            tap: loginBtn.rx.tap.asObservable()
//        ))
//
//
//
//        let _ = viewModel.loginBtnValid.drive(loginBtn.rx.isEnabled)
//
//        viewModel.signIn.subscribe {[weak self] result in
//            self?.navigationController?.popViewController(animated: true)
//        } onError: { error in
//            AutoProgressHUD.showError(error)
//        }.disposed(by: disposeBag)
//
//
////        let _ = viewModel.signIn.drive {[weak self] didLogin in
////            if didLogin {
////                self?.navigationController?.popViewController(animated: true)
////            }
////        }
////
//
//
//
//
//       let endEditing =  phoneFiled.rx.controlEvent(.editingDidEnd)
//            .asDriver()
//
//
//        Driver.combineLatest(viewModel.validatedUsername,phoneFiled.rx.text.orEmpty.asDriver()){
//            if $1.count < 11 { return true}
//            if $0.isValid { return true}
//            return false
//        }.drive(phoneHint.rx.isHidden).disposed(by: disposeBag)
//    }
//
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//
//    @objc func login(){
//        guard let phone = phoneFiled.text else {
//            AutoProgressHUD.showAutoHud("请输入手机号")
//            return
//        }
//
//        guard let passwd = passwdFiled.text else{
//            AutoProgressHUD.showAutoHud("请输入登录密码")
//            return
//        }
//
//        if(!phone.isPhone){
//            AutoProgressHUD.showAutoHud("请输入正确的手机号")
//            return
//        }
//
//        if (passwd.count < 6 || passwd.count > 16){
//            AutoProgressHUD.showAutoHud("密码错误")
//        }
//
//        userService.request(.login(mobile:phone, passwd: passwd)) {[weak self] result in
//            result.hj_map2(UserAccount.self) { body, error in
//                if let error = error{
//                    AutoProgressHUD.showAutoHud(error.msg)
//                }else if let user = body!.decodedObj{
//                    UserStore.currentUser = user
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//    }
//
//}
