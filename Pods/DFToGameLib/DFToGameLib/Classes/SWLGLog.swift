//
//  SWLGLog.swift
//  DFToGameLib
//
//  Created by mac on 2021/12/24.
//

import Foundation


enum SWLGLogType {


    case normal
    case Warning
    case Error
}

struct SWLGLogOption:OptionSet {
    var rawValue: Int
    
    init(rawValue: RawValue) {
        
        self.rawValue = rawValue
    }
    
    typealias RawValue = Int
    
    static let normal:SWLGLogOption = .init(rawValue: 1)
    
    static let warning:SWLGLogOption = .init(rawValue: 1 << 1)
    
    static let error:SWLGLogOption = .init(rawValue: 1 << 2)
    
    static let none:SWLGLogOption = .init(rawValue: 1 << 3)
    
    static let all:SWLGLogOption = [.error,.normal,.warning]
}


func SWLGLog(withMsg:String,file: String = #file, funcName: String = #function, line: Int = #line)  {
     
    if SWOtherInfoWrap.shared.logoption.contains(.normal) {
        
        print("[Log]","where->\(file)/\(funcName)/\(line)","msg->\(withMsg)",separator: "\n")
    }
}


func SWLGWarning(withMsg:String,file: String = #file, funcName: String = #function,line: Int = #line)  {
     
    if SWOtherInfoWrap.shared.logoption.contains(.warning) {
    
        print("[Warning]","where->\(file)/\(funcName)/\(line)","msg->\(withMsg)",separator: "\n")
    }
}

func SWLGError(withMsg:String,file: String = #file, funcName: String = #function,line: Int = #line)  {
     
    if SWOtherInfoWrap.shared.logoption.contains(.error) {
        
        print("[Error]","where->\(file)/\(funcName)/\(line)","msg->\(withMsg)",separator: "\n")
        
       
      
    }
}
