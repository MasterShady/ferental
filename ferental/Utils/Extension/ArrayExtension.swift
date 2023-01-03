//
//  ArrayExtension.swift
//  ReCamV5
//
//  Created by Park on 2020/3/18.
//  Copyright © 2020 Wade. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    func indexOf(_ object: Element) -> Int? {
        if let index = firstIndex(of: object) {
            return index
        }
        return nil
    }
    
    func random() -> Element {
        return self[Int(arc4random())%count]
    }
}

extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

extension Sequence where Iterator.Element == Int {
    
    private func removeRepeats()->[Int]{
        let set = Set(self)
        return Array(set).sorted {$0>$1}
    }

    private func countFor(value:Int)->Int{
        return filter {$0 == value}.count
    }

    func sortByRepeatCount()->[Iterator.Element]{
        var wets = [[Int]]()
        let clearedAry = removeRepeats()
        for i in clearedAry{
            wets.append([i,countFor(value: i)])
        }

        wets = wets.sorted {
            $0[1] > $1[1]
        }

        var result = [Int]()
        for x in wets{
            let i = x[0]
            let count = x[1]
            for _ in 0..<count{
                result.append(i)
            }
        }

        return result
    }
}
