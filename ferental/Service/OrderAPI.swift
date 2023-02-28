//
//  OrderServce.swift
//  ferental
//
//  Created by 刘思源 on 2023/1/4.
//

import Foundation
import Moya
import HandyJSON
import Alamofire

import HandyJSON



struct Order: HandyJSON{
    enum Status:Int,HandyJSONEnum{
        case pendingReview
        case pendingPickup
        case completed
    }
    
    var device: Device!
    
    var status: Status = .pendingReview
    var cover: String {
        if device.pics.count > 0{
            return device.pics[0]
        }
        return ""
    }

    var createdDate: Date!
    
    var id: Int! //短id
    var startDate: Date!
    var duration: Int!
    var orderId: String! //长id
    
    
    var title: String {
        device.name
    }
    
    var rentalFee: Double{
        device.price
    }
    
    var endDate: Date{
        return (startDate as NSDate).addingDays(duration)!
    }
    
    var amount: Double{
        return duration * rentalFee
    }
    
    var statusTitle: String{
        switch status{
        case .pendingReview:
            return "待审核"
        case .pendingPickup:
            return "待提货"
        case .completed:
            return "已完成"
        }
    }
    
    var descTitle: String{
        switch status{
        case .pendingPickup:
            return "包裹已到达，请尽快前往指定地点提货"
        default:
            return ""
        }
    }
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.duration <-- "days"
        mapper <<< self.startDate <-- TimeStampMsTransform()
        mapper <<< self.createdDate <-- CustomDateFormatTransform(formatString: "yyyyMMddHHmmssSSS")
        mapper <<< self.orderId <-- "order"
    }
    
}



let orderService = MoyaProvider<OrderAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                             logOptions: .verbose))])

public enum OrderAPI {
    case makeOrder(deviceId:Int,dayCount:Int,totalPrice:Double)
    case getAllOrders
}

extension OrderAPI: TargetType {
    public var baseURL: URL { URL(string: kServerHost + "/a001")! }
    public var path: String {
        switch self {
        case .makeOrder:
            return "order/add"
        case .getAllOrders:
            return "order/user/\((UserStore.currentUser!.id!))"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .makeOrder:
            return .post
        case .getAllOrders:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .makeOrder(let deviceId, let dayCount, let totalPrice):
            return .requestParameters(parameters: [
                "days":dayCount,
                "device":deviceId,
                "user": UserStore.currentUser!.id!,
                "status": 0,
                "money": totalPrice,
                "startDate": Date().timeIntervalSince1970 * 1000
            
            ], encoding: URLEncoding.default)
        case .getAllOrders:
            return .requestPlain
                //.requestParameters(parameters: ["id":String(UserStore.currentUser!.id)], encoding: URLEncoding.default)
        }
    }
    public var validationType: ValidationType {
        return .successCodes
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
