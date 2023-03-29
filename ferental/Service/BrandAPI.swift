//
//  BrandService.swift
//  ferental
//
//  Created by 刘思源 on 2023/1/4.
//

import Foundation
import Moya
import HandyJSON
import Alamofire

public enum GameType: Int, HandyJSONEnum {
    case computer = 1
    case phone = 2
}

struct Game: HandyJSON,Equatable{
    var name: String!
    var id: String?
    var type: GameType!
    
}


struct Brand: HandyJSON, Equatable{
    var name: String!
    var logo: String!
    var id: String!
}

struct Device: HandyJSON, Equatable{
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
    }
    
    
    var memory: String?{
        params["memory"] as? String
    }
    
    var cpu: String{
        params["cpu"] as? String ?? ""
    }
    
    var gpu: String?{
        params["gpu"] as? String
    }
    
    var screenSize: String {
        if let screenSize = params["screenSize"] as? String{
            return screenSize
        }
        return ""
    }
    
    var cover: String{
        if pics.count > 0{
            return pics[0]
        }
        return ""
    }
    
    var id: Int!
    
    var name: String!
    
    var deposit: Double = 0
    var price: Double = 0
    //租用次数
    var rentCount = 0
    
    var params:[String:Any]!
    
    var brand: Brand!

    var address: String {
        if let address = params["address"] as? String{
            return address
        }
        return "湖北省武汉市洪山区高新二路9号,北辰光谷里"
    }
    var longitude: Double {
        if let longitude = params["longitude"] as? String{
            return Double(longitude) ?? 114.415359
        }
        return 114.415359
    }
    var latitude: Double {
        if let latitude = params["latitude"] as? String{
            return Double(latitude) ?? 30.479471
        }
        return 30.479471
    }

    var pics:[String] = []
    
    var games:[Game] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.params <-- TransformOf<[String:Any],String>(fromJSON: { (raw) -> [String:Any] in
                if let jsonData = raw?.data(using: .utf8),
               let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return dict
            }
            return [String:Any]()
        }, toJSON: { (dic) -> String in
            if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return ""
        })
        
        mapper <<< self.pics <-- TransformOf<[String], String>(fromJSON: { (raw) -> [String] in
            if let strippedJsonString = raw?
                .replacingOccurrences(of: "\r\n", with: "")
                .replacingOccurrences(of: "    ", with: "")
                .replacingOccurrences(of: "'", with: "\""),
               let jsonData = strippedJsonString.data(using: .utf8),
               let array = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String]{
                return array
            }
            return []
        }, toJSON: {(array) -> String in
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return ""
        })
    }
    
}


let brandService = MoyaProvider<BrandAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                             logOptions: .verbose))])

public enum BrandAPI {
    case getAllBrands
    case getAllDevices
    case getBrands(GameType)
    case getGames(GameType)
}

extension BrandAPI: TargetType {
    //http://app.cywl.info
    public var baseURL: URL { URL(string: kServerHost + "/a001")! }
    public var path: String {
        switch self {
        case .getAllBrands:
            return "brand"
        case .getAllDevices:
            return "goods/"
        case .getBrands(let type):
            return "brand/gametype/\(type.rawValue)"
        case .getGames(let type):
            return "games/\(type.rawValue)"
        
        }

    }
    public var method: Moya.Method { .get }

    public var task: Task {
        switch self {
        case .getAllBrands, .getAllDevices, .getGames, .getBrands:
            return .requestPlain
        }
    }
    public var validationType: ValidationType {
        return .successCodes
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
