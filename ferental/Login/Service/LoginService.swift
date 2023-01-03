//
//  LoginService.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/21.
//

import UIKit
import Moya
import HandyJSON
import Alamofire




let kNetworkDomian = "com.shady.gerental.network"

let userService = MoyaProvider<UserAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                             logOptions: .verbose))])

public enum UserAPI {
    case login(mobile:String, passwd: String)
    case register(mobile:String, passwd: String, name:String)
}

extension UserAPI: TargetType {
    //http://app.cywl.info
    public var baseURL: URL { URL(string: "http://app.cywj.info/a001")! }
    public var path: String {
        switch self {
        case .login(_,_):
            return "login"
        case .register:
            return "user/register"
        }

    }
    public var method: Moya.Method { .post }

    public var task: Task {
        switch self {
        case .login(let userName, let passwd):
            return .requestParameters(parameters: ["mobile": userName, "passwd": passwd], encoding: URLEncoding.default)
        case .register(let mobile, let passwd, let name):
            return .requestParameters(parameters: ["mobile":mobile,"passwd":passwd, "name":name], encoding: URLEncoding.default)
        }
    }
    public var validationType: ValidationType {
        return .successCodes
    }
    public var sampleData: Data {
        switch self {
        case .login(_,_):
            return "{\"userName\": \"lsy\", \"token\": \"qeweqeeqweqwe\"}".data(using: String.Encoding.utf8)!
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}


class UserAccount: HandyJSON{
    var name: String?
    var phone: String?
    var token: String?
    required init(){}
}


class UserStore {
    class var currentUser: UserAccount?{
        set{
            if let json = newValue?.toJSON(){
                UserDefaults.standard.set(json, forKey: "currentUser")
                UserDefaults.standard.synchronize()
            }
        }
        get{
            let json = UserDefaults.standard.value(forKey: "currentUser")
            if json == nil{
                return nil
            }
            return UserAccount.deserialize(from: json as? NSDictionary)
        }
    }
    
    class var isLogin: Bool{
        return currentUser != nil
    }
}



