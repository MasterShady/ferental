//
//  DFHttpApiSignUtil.swift
//  DFBaseLib
//
//  Created by mac on 2022/2/21.
//

import Foundation
import CommonCrypto
import Alamofire


//网络层如果是Alamofire
public func DFHttpSign_Alamofire(withKey:String,withparam:[String:Any]) -> [String:Any] {
    
    var dic = withparam
    
    if dic["timestamp"] == nil {
        
        dic["timestamp"] = Int(NSDate.init().timeIntervalSince1970)
    }
    
    let str = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuioopasdfghjklzxcvbnm1234567890"
    
    var randomStr = ""
    
    
    for (_) in stride(from: 0, to: 8, by: 1) {
        
        randomStr += String.init(str.randomElement()!)
    }
    
    dic["signature_nonce"] = randomStr
    
    let keyvalueList = dic.sorted { kv1 , kv2 in
        
        return kv1.key < kv2.key
    }
    
    let needSignStr =  keyvalueList.map {
        
        let (new_key,new_value) = URLEncoding.queryString.queryComponents(fromKey: $0.key, value: $0.value).first!
        
        var value1 = ""
        value1 = new_value.df_urlDecoded().df_urlEncoded()
        
        if $0.key == "TransitData" {
           
            value1 = value1.df_urlEncoded()
        }

        return "\(new_key)=\(value1)"
        
    }.joined(separator: "&")
 
    
    print("sign_str\(needSignStr)")
    let key = withKey
    
    let cData = needSignStr.cString(using: .utf8)
    
    let cKey = key.cString(using: .utf8)
    
    
    let length = Int(CC_SHA1_DIGEST_LENGTH)
    
   
    var result = [CUnsignedChar].init(repeating: 0, count: length)
    
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey, strlen(cKey!), cData, strlen(cData!), &result)
    
    var signedStr  = ""
    
    for (_,tmp) in result.enumerated() {
        
        signedStr.append(.init(format: "%02x", tmp))
    }
  
   
    let data1  =   signedStr.lowercased().data(using: .utf8)!
    
    let signValue =  data1.base64EncodedString(options:[])
    
    dic["signature"] = signValue
    
    
    return dic
}

extension String {
     
    func df_urlEncoded() -> String {
        
        return  self.addingPercentEncoding(withAllowedCharacters: .df_URLQueryAllowed) ?? self
    }
     
    //将编码后的url转换回原始的url
    func df_urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
   
}


public extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    static let df_URLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@?/~" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}


extension NSNumber {
    fileprivate var df_isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        String(cString: objCType) == "c"
    }
}
