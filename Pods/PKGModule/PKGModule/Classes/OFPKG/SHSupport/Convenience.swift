//
//  PKGEnv.swift
//  EmotionDiary
//
//  Created by 刘思源 on 2023/3/20.
//

import Foundation
import KeychainAccess

public struct BaseError: Error {
    public let message: String
    public var shouldDisplayToUser = true
    public var code: Int? = 0
}

extension UIApplication {
    func pkg_currentWindow() -> UIWindow? {
        if Thread.isMainThread {
            if #available(iOS 13, *) {
                let connectedScenes = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({$0 as? UIWindowScene})
                if connectedScenes.count == 0 {
                    return UIApplication.shared.windows.first
                }
                let window = connectedScenes.first?
                    .windows
                    .first { $0.isKeyWindow }
                return window
            }else{
                return UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
            }
        }
        return nil
    }
}

func LolmDF_uuid() ->String {
    let service = "com.lolmdf.app.ios"
    let keychain = Keychain(service: service)
    if let uuid = keychain["uuid"] {
        return uuid
    }
    else{
        let uuid =  UUID().uuidString
        keychain["uuid"] = uuid
        return uuid
    }
}


func LolmDFLog<T>(msg : T, file : String = #file, lineNum : Int = #line) {
#if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):[\(lineNum)]:   \(msg)")
#endif
}
