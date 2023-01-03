//
//  DateExtension.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/23.
//

import Foundation

extension Date{
    static func makeDate(year:Int,month:Int,day:Int) -> Date{
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
        return calendar.date(from: dateComponents)!
    }
    
    var year: Int{
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int{
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int{
        Calendar.current.component(.day, from: self)
    }
}
