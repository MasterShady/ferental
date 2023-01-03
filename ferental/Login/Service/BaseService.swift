//
//  BaseService.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/21.
//

import UIKit
import Moya
import HandyJSON


typealias ResponseCallBack<D> = (Result<D,MoyaError>)->()


func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

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

class BaseService {
    static func make<T:NSObject>() -> T{
        print(type(of: T.self))
        return T()
    }
}


extension Result where Success : Moya.Response , Failure == MoyaError{
    /**
     拆包Moya返回的result对象
     sucess 情况 表明网络请求是正常的.
        将 Response 转换成 json 再转换为模型对象.
        转换成功, 构造新的Result 并且封装对象返回
        转换失败 构造 新的Result 封装MoyaError返回
        
     error 情况是网络层的错误
     构造 新的Result 封装MoyaError返回
     
     */
    func hj_map<D: HandyJSON>(_ type:D.Type, atKeyPath keyPath: String?,failsOnEmptyData: Bool = true) -> Result<(D,Moya.Response),MoyaError>{
        switch self {
        case let .success(response):
            do {
                let obj = try response.hj_map(type, atKeyPath: keyPath, failsOnEmptyData: failsOnEmptyData)
                return .success((obj, response))
            } catch let error as MoyaError{
                return .failure(error)
            } catch let otherError{
                return .failure(.underlying(otherError, response))
            }
        case let .failure(error):
            return .failure(error)
        }
    }
    
    
    func hj_map<D: HandyJSON>(_ type:D.Type, atKeyPath keyPath: String?,failsOnEmptyData: Bool = true,responseCallBack: @escaping ResponseCallBack<(D,Moya.Response)>){
        switch self {
        case let .success(response):
            do {
                let obj = try response.hj_map(type, atKeyPath: keyPath ,failsOnEmptyData: failsOnEmptyData)
                responseCallBack(.success((obj, response)))
            } catch let error as MoyaError{
                responseCallBack(.failure(error))
            } catch let otherError{
                responseCallBack(.failure(.underlying(otherError, response)))
            }

        case let .failure(error):
            responseCallBack(.failure(error))
            break
        }
    }
    
    
}

extension Moya.Response{
    func hj_map<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String?, failsOnEmptyData: Bool = true) throws -> D {
        do{
            let json = try self.mapJSON(failsOnEmptyData: failsOnEmptyData)
            //Moya 中的 map 方法要求 对象实现 Decodable 协议. 我们这里用的是HandyJSON来做转换
            if let dic = json as? NSDictionary{
                if let obj = type.deserialize(from: dic,designatedPath: keyPath){
                    return obj
                }else{
                    let error = NSError(domain: kNetworkDomian, code: 1000)
                    throw MoyaError.underlying(error, self)
                }
            }else{
                //jsonMapping error
                throw MoyaError.jsonMapping(self)
            }
        }
        catch(let error){
            throw error
        }
    }
}


extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
