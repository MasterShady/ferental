//
//  NetMothod.swift
//  DoFunNew
//
//  Created by mac on 2021/2/25.
//

import UIKit

class LolmDF_HttpFactory: NSObject {
    //共用方法
    private static func baseNetRequest(url: String, params: Dictionary<String, Any>, method: HTTPMethod, showLoading: Bool, view:UIView, succ: @escaping (String) -> Void, fail: @escaping (String) -> ()) {

        
        LolmDFHttpUtil.lolm_dohttpTask(url: url, method: method, parameters: params, showLoading: showLoading, view: view) { (response) in
            succ(response)
        } failBlock: { (errorStr) in
            fail(errorStr)
        }
    }
    
}
