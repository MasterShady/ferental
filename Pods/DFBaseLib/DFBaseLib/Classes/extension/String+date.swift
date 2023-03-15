//
//  String+date.swift
//  DoFunNew
//
//  Created by mac on 2021/3/2.
//

import UIKit
import CommonCrypto
public extension String {
    
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    //MARK:- 时间戳转成字符串
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    //MARK:- 时间戳转成字符串(时分 HH:mm)
    static func timeIntervalHourAndMinTimeStr(timeInterval:Double, _ dateFormat:String? = "HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    //MARK:- 字符串转时间戳
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return String(date!.timeIntervalSince1970)
    }
    
    //MARK:- MD5 加密
    enum MD5EncryptType {
        /// 32位小写
        case lowercase32
        /// 32位大写
        case uppercase32
        /// 16位小写
        case lowercase16
        /// 16位大写
        case uppercase16
    }
    //MD5加密 默认是32位小写加密
    func swMD5Encrypt(_ md5Type: MD5EncryptType = .lowercase32) -> String {
        guard self.count > 0 else {
            return ""
        }
        /// 1.把待加密的字符串转成char类型数据 因为MD5加密是C语言加密
        let cCharArray = self.cString(using: .utf8)
        /// 2.创建一个字符串数组接受MD5的值
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        /// 3.计算MD5的值
        /*
         第一个参数:要加密的字符串
         第二个参数: 获取要加密字符串的长度
         第三个参数: 接收结果的数组
         */
        CC_MD5(cCharArray, CC_LONG(cCharArray!.count - 1), &uint8Array)
        switch md5Type {
        /// 32位小写
        case .lowercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
        /// 32位大写
        case .uppercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
        /// 16位小写
        case .lowercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
            return tempStr.subString(start: 8, length: 16)
        /// 16位大写
        case .uppercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
            return tempStr.subString(start: 8, length: 16)
        }
    }
    
    var unsafePointer: UnsafePointer<Int8> {
        return self.withCString { $0 }
    }
        
    var unsafeBufferPointer: UnsafeBufferPointer<UInt8> {
        var tmpStr = self
        return tmpStr.withUTF8 { $0 }
    }
    
    
    /**
     去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    func sw_ValidPassword() -> Bool {
        

         let characters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@$!%*#_~?&^")
        
        return  self.trimmingCharacters(in: characters) != self
        
    }
}
