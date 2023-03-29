//
//  File++.swift
//  gerental
//
//  Created by 刘思源 on 2023/2/22.
//

import CommonCrypto
class File{
    static func fileMD5(url: URL) -> String? {
        guard let file = try? FileHandle(forReadingFrom: url) else { return nil }
        defer { file.closeFile() }
        
        let bufferSize = 1024 * 1024
        
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)
        
        while autoreleasepool(invoking: {
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0.baseAddress, CC_LONG(data.count))
                }
                return true
            } else {
                return false
            }
        }) {}
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Final(&digest, &context)
        
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
