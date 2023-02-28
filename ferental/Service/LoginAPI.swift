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


let userService = MoyaProvider<UserAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                             logOptions: .verbose))])

public enum UserAPI {
    case login(mobile:String, passwd: String)
    case register(mobile:String, passwd: String, name:String)
    case logoff(mobile:String, passwd: String)
}

extension UserAPI: TargetType {
    //http://app.cywl.info
    public var baseURL: URL { URL(string: kServerHost + "/a001")! }
    public var path: String {
        switch self {
        case .login(_,_):
            return "user/login"
        case .register:
            return "user/register"
        case .logoff:
            return "user/logoff"
        }

    }
    public var method: Moya.Method { .post }

    public var task: Task {
        switch self {
        case .login(let userName, let passwd):
            return .requestParameters(parameters: ["mobile": userName, "passwd": passwd], encoding: URLEncoding.default)
        case .register(let mobile, let passwd, let name):
            return .requestParameters(parameters: ["mobile":mobile,"passwd":passwd, "name":name], encoding: URLEncoding.default)
        case .logoff(let userName, let passwd):
            return .requestParameters(parameters: ["mobile": userName, "passwd": passwd], encoding: URLEncoding.default)
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
    var name: String!
    var mobile: String!
    var id: Int!
    required init(){}
}


struct UserStore {
    static var currentUser: UserAccount?{
        set{
            if let json = newValue?.toJSON(){
                UserDefaults.standard.set(json, forKey: "currentUser")
            }else{
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(kUserChanged)
        }
        get{
            if let json = UserDefaults.standard.value(forKey: "currentUser"){
                return UserAccount.deserialize(from: json as? NSDictionary)
            }
            return nil
        }
    }
    
    static var isLogin: Bool{
        return currentUser != nil
    }
}



