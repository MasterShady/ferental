//
//  DictionaryExtension.swift
//  DoFunNew
//
//  Created by mac on 2021/3/12.
//

import UIKit

public extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
    
    func getValue<T>(key:Key,t:T.Type) ->T?  {
        
        guard let value = self[key] else {
            
            return nil
        }
          
        return value as? T
        
    }
}
