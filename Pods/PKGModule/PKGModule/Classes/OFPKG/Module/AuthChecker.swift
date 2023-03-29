//
//  AuthChecker.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/16.
//

import Foundation
import AVFoundation
import Photos


@objcMembers public class AuthChecker : NSObject{
    public class func checkCameraPermission(reusltHandler:@escaping (Bool)->()) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            // 相机权限已经授权
            reusltHandler(true)
        case .notDetermined:
            // 相机权限还未确定，需要请求相机权限
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    reusltHandler(granted)
                }
            }
            
        case .denied, .restricted:
            // 相机权限已拒绝或受限制，需要在设置中打开相机权限
            reusltHandler(false)
            
        @unknown default:
            fatalError("New authorization status was added to AVFoundation.")
        }
    }
    
    
    public class func checkPhotoLibraryPermission(reusltHandler:@escaping (Bool)->()) {
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoLibraryAuthorizationStatus {
        case .authorized:
            reusltHandler(true)
        case .notDetermined:
            // 相册权限还未确定，需要请求相册权限
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        if status == .authorized || status == .limited {
                            reusltHandler(true)
                        } else {
                            reusltHandler(false)
                        }
                    } else {
                        if status == .authorized{
                            reusltHandler(true)
                        }else{
                            reusltHandler(false)
                        }
                    }
                }
                
            }
            
        case .denied, .restricted:
            // 相册权限已拒绝或受限制，需要在设置中打开相册权限
            reusltHandler(false)
            
        case .limited:
            reusltHandler(true)
        @unknown default:
            fatalError("New authorization status was added to Photos framework.")
        }
    }
    
    
    public class func alertGoSettingsWithTitle(title: String, message: String){
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        let confirm = UIAlertAction(title:"去设置", style: .default) { (_)in
            if let url = URL.init(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        alert.addAction(cancel)
        alert.addAction(confirm)
        UIViewController.pkg_getCurrent()!.present(alert, animated:true, completion:nil)
    }
}


