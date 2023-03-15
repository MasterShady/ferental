//
//  SWLGStack.swift
//  DoFunNew
//
//  Created by mac on 2021/11/22.
//

import Foundation


struct SWLGStack <T> {
    
    var _list:[T] = []
    
    
    init(withDatas:[T]) {
        
        _list = withDatas
    }
    
    func current() -> T? {
        
        return _list.first
    }
    
    mutating func pop()  {
        
        guard _list.count > 0 else {
            
            return
        }
        
        _list.remove(at: 0)
    }
    
   
}
