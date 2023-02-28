//
//  DeviceService.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/20.
//

import UIKit

enum CacheConfig{
    case awalysIgnore
    case awaysAllow
    case inSeconds(Double)
}

class CommonService{
    static var allDevices = [Device]()
    static var gameCache = [GameType: [Game]]()
    
    class func getAllDevices(ignoreCache: Bool = false, handler: @escaping ([Device],Error?) -> ()){
        if ignoreCache || allDevices.count == 0{
            brandService.request(.getAllDevices) { result in
                result.hj_mapArray(Device.self, atKeyPath: "data") { [self] result in
                    switch result {
                    case .success((let devices, _)):
                        allDevices = devices
                        handler(allDevices,nil)
                    case .failure(let error):
                        handler([],error)
                    }
                }
            }
        }else{
            handler(allDevices,nil)
        }
    }
    
    class func getGames(type: GameType, cacheConfig:CacheConfig = .awalysIgnore,handler: @escaping ([Game], Error?) -> ()){
        if let games = gameCache[type] , games.count > 0, case CacheConfig.awaysAllow = cacheConfig {
            handler(gameCache[type]!, nil)
        }else{
            brandService.request(.getGames(type)) { result in
                result.hj_map2(Game.self) { body, error in
                    if let error = error{
                        handler([],error)
                    }else{
                        handler(body!.decodedObjList!, nil)
                    }
                }
            }
        }
    }
}
