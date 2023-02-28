//
//  BaseService.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/21.
//

import UIKit
import Moya
import HandyJSON


let apiProvider = MoyaProvider<BaseAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                           logOptions: .verbose))])


public enum BaseAPI {
    case any(path: String, params:[String:Any], method:Moya.Method = .get)
}


extension BaseAPI: TargetType {
    public var baseURL: URL { URL(string: "https://api.npoint.io")! }
    public var path: String {
        switch self {
        case .any(let path,_,_):
            return path
        }
    }
    public var method: Moya.Method {
        if case let .any(_, _, method) = self {
            return method
        }
        return .get
    }
    
    public var task: Task {
        switch self {
        case let .any(_, params,_):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    public var validationType: ValidationType {
        switch self {
        case .any(_,_,_):
            return .successCodes
        default:
            return .none
        }
    }
    public var sampleData: Data {
        switch self {
        case .any(_,_,_):
            return "{\"userName\": \"lsy\", \"token\": \"qeweqeeqweqwe\"}".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? { nil }
    
}



