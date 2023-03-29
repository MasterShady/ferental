//
//  CartModel.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/29.
//

import Foundation

class CartItem :HandyJSON, Equatable{
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.device == rhs.device
    }
    
    required init() {}
    
    var selected = false
    var count = 1
    var device: Device!
}
