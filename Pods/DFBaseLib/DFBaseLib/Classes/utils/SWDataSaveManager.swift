//
//  SWDataSaveManager.swift
//  DoFunNew
//
//  Created by mac on 2021/3/5.
//

import Foundation
import SDWebImage
public enum DocumentPath:Int {
    case DocumentPathTemp, //临时文件路径 系统会自动进行清理
         DocumentPathCache, //对象缓存目录 定义在app文档里面
         DocumentPathDocument //app文档路径 系统不会自动进行清理
}

private let CACHE_PATH = NSHomeDirectory() + "/Library/Caches" //缓存目录

public class SWDataSaveManager: NSObject {
    
    /**
     *  判断文件是否存在
     *
     *  @param path     路径类型
     *  @param filename 文件名
     *
     *  @return 是否存在
     */
   public static func isFileExistInPath(path:DocumentPath, filename:String) -> Bool {
        switch path {
        case .DocumentPathTemp:
            return FileManager.default.fileExists(atPath: NSTemporaryDirectory() + #"/"# + filename)
    
        case .DocumentPathDocument:
            let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
            let documnetPath = documentPaths[0]
            return FileManager.default.fileExists(atPath: documnetPath + #"/"# + filename)
            
        case .DocumentPathCache:
            return FileManager.default.fileExists(atPath: CACHE_PATH + #"/"# + filename)
        }
    }
    /**
     *  判断文件是否存在
     *
     *  @param path          指定根目录
     *  @param userDirectory 指定目录
     *  @param filename      文件名
     *
     *  @return
     */
    public static func isFileExistInPath(path:DocumentPath, userDirectory:String, filename:String) -> Bool {
        
        switch path {
            case .DocumentPathTemp:
                return FileManager.default.fileExists(atPath: NSTemporaryDirectory() + #"/"# + userDirectory + #"/"# + filename)
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                return FileManager.default.fileExists(atPath: documnetPath + #"/"# + userDirectory + #"/"# + filename)
            case .DocumentPathCache:
                return FileManager.default.fileExists(atPath: CACHE_PATH + #"/"# + userDirectory + #"/"# + filename)
        }
    }
    
    /**
     *  判断改文件夹是否存在
     *
     *  @param path          在某个目录下
     *  @param directoryName 文件夹
     *
     *  @return
     */
    public static func isDirectoryExistInPath(path:DocumentPath, directoryName:String) -> Bool {
        var isDirectory:ObjCBool = true
        
        switch path {
            case .DocumentPathTemp:
                return FileManager.default.fileExists(atPath: NSTemporaryDirectory() + #"/"# + directoryName, isDirectory: &isDirectory)
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                return FileManager.default.fileExists(atPath: documnetPath + #"/"# + directoryName, isDirectory: &isDirectory)
            case .DocumentPathCache:
                return FileManager.default.fileExists(atPath: CACHE_PATH + #"/"# + directoryName, isDirectory: &isDirectory)
        }
    }
    
    /**
     *  将文件写到本地
     *
     *  @param path     路径类型
     *  @param filename 文件名
     *  @param data     数据
     */
    
    public static func writeToPath(path:DocumentPath, filename:String, data:NSData) {
        switch path {
            case .DocumentPathTemp:
                data.write(toFile: NSTemporaryDirectory() + #"/"# + filename, atomically: false)
            break
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                data.write(toFile: documnetPath + #"/"# + filename, atomically: false)
            break
            case .DocumentPathCache:
                data.write(toFile: CACHE_PATH + #"/"# + filename, atomically: false)
            break
        }
    }
    
    /**
     *  从本地读取数据
     *
     *  @param path     路径类型
     *  @param filename 文件名
     *
     *  @return 读取的数据
     */
    public static func dataFromPath(path:DocumentPath, filename:String) -> NSData {
        switch path {
        case .DocumentPathTemp:
            return try! NSData(contentsOfFile: NSTemporaryDirectory() + #"/"# + filename)
        case.DocumentPathDocument:
            let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
            let documnetPath = documentPaths[0]
            return try! NSData(contentsOfFile: documnetPath + #"/"# + filename)
        case.DocumentPathCache:
            return try! NSData(contentsOfFile: CACHE_PATH + #"/"# + filename)
        }
    }
    
    /**
     *  将对象保存
     *
     *  @param path     路径类型
     *  @param filename 文件名
     *  @param obj      对象
     */
    public static func archiverToPath(path:DocumentPath, filename:String, obj:Any) {
        switch path {
        case .DocumentPathTemp:
            NSKeyedArchiver.archiveRootObject(obj, toFile: NSTemporaryDirectory() + #"/"# + filename)
            break
        case .DocumentPathDocument:
            let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
            let documnetPath = documentPaths[0]
            NSKeyedArchiver.archiveRootObject(obj, toFile: documnetPath + #"/"# + filename)
            break
        case .DocumentPathCache:
            SWGLog(msg: "缓存到目录：\(CACHE_PATH)\n文件名：\(filename)\n缓存类型：\(object_getClassName(obj))")
            NSKeyedArchiver.archiveRootObject(obj, toFile: CACHE_PATH + #"/"# + filename)
            break
        }
    }
    
    /**
     *  将对象保存到特定的文件夹下
     *
     *  @param path               根目录
     *  @param userName           根据用户名指定的文件夹
     *  @param filename           文件名
     */
    public  static func archiverToPath(path:DocumentPath, username:String, filename:String, obj:Any) {
        //如果username不为nil,则在响应目录下新建一个文件夹
        var document:String? = nil
        if !username.isEmpty {
            switch path {
            case .DocumentPathTemp:
                document = NSTemporaryDirectory() + #"/"# + username
                break
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                document = documnetPath + #"/"# + username
                break
            case .DocumentPathCache:
                document = CACHE_PATH + #"/"# + username
                break
            }
        }
        
        let bl:Bool = isDirectoryExistInPath(path: path, directoryName: username)
        
        if !bl {
            try! FileManager.default.createDirectory(atPath: document!, withIntermediateDirectories: true, attributes: nil)
        }
        SWGLog(msg: "缓存到目录：\(document ?? "")\n文件名：\(filename)\n缓存类型：\(object_getClassName(obj))")
        document! += (#"/"# + filename)
        
        if !(document!.isEmpty) {
            NSKeyedArchiver.archiveRootObject(obj, toFile: document!)
        }
    }
    
    /**
     *  从本地恢复对象
     *
     *  @param path     路径类型
     *  @param filename 文件名
     *
     *  @return 恢复的对象
     */
    public static func unarchiverFromPath(path:DocumentPath, filename:String) -> Any {
        switch path {
        case .DocumentPathTemp:
            return NSKeyedUnarchiver.unarchiveObject(withFile: NSTemporaryDirectory() + #"/"# + filename) as Any
        case .DocumentPathDocument:
            let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
            let documnetPath = documentPaths[0]
            return NSKeyedUnarchiver.unarchiveObject(withFile: documnetPath + #"/"# + filename) as Any
        case .DocumentPathCache:
            return NSKeyedUnarchiver.unarchiveObject(withFile: CACHE_PATH + #"/"# + filename) as Any
        }
    }
    
    /**
     *  从本地指定目录恢复对象
     *
     *  @param path     根目录
     *  @param userName 指定的文件夹名
     *  @param filename 文件名
     *
     *  @return
     */
    public static func unarchiverFromPath(path:DocumentPath, username:String, filename:String) -> Any {
        var document:String? = nil
        if !username.isEmpty {
            switch path {
            case .DocumentPathTemp:
                document = NSTemporaryDirectory() + #"/"# + username + #"/"# + filename
                break
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                document = documnetPath + #"/"# + username + #"/"# + filename
                break
            case .DocumentPathCache:
                document = CACHE_PATH + #"/"# + username + #"/"# + filename
                break
            }
            
            let bl:Bool = isDirectoryExistInPath(path: path, directoryName: username)
            
            if !bl {
                try! FileManager.default.createDirectory(atPath: document!, withIntermediateDirectories: true, attributes: nil)
            }
            
        }else {
            switch path {
            case .DocumentPathTemp:
                document = NSTemporaryDirectory() + #"/"# + filename
                break
            case .DocumentPathDocument:
                let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.userDomainMask, true)
                let documnetPath = documentPaths[0]
                document = documnetPath + #"/"# + filename
                break
            case .DocumentPathCache:
                document = CACHE_PATH + #"/"# + filename
                break
            }
        }
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: document ?? "") as Any
    }
    
    /**
     *  获取所在文件路径的所有文件的大小
     *
     *  @param path 路径类型
     */
    static func sizeInPath(path:DocumentPath) -> String {
        if path == .DocumentPathCache {
            let fileManager:FileManager = FileManager.default
            if !fileManager.fileExists(atPath: CACHE_PATH) {
                return "0KB"
            }
            let arr:NSArray = fileManager.subpaths(atPath: CACHE_PATH)! as NSArray
            let childFilesEnumerator:NSEnumerator = arr.objectEnumerator()
            let fileName:String = ""
            var folderSize = 0
            while fileName == (childFilesEnumerator.nextObject() as! String) {
                let fileAbsolutePath = CACHE_PATH + #"/"# + fileName
                
                let tempValue = (try? fileManager.attributesOfItem(atPath: fileAbsolutePath))
              
                folderSize += Int(tempValue![FileAttributeKey.size] as! UInt64)
            }
            let result:Float = Float(folderSize) / (1024.0 * 1024.0) + Float(SDImageCache.shared.diskCache.totalSize()) / (1024 * 1024)
            if result < 1 {
                return "\(result * 1024)KB"
            }else {
                return "\(result)MB"
            }
        }
        return "0MB"
    }
    
    /**
     *  删除制定的路径
     *
     *  @param path  路径
     *  @param block 完成删除操作
     */
    static func deletePath(path:DocumentPath, complete: @escaping () -> () ) {
        let fileManager:FileManager = FileManager.default
        let contents:NSArray = try! fileManager.contentsOfDirectory(atPath: CACHE_PATH) as NSArray
        let e:NSEnumerator = contents.objectEnumerator()
        let fileName:String = ""
        SDImageCache.shared.clearDisk(onCompletion: nil)
        
        while fileName == (e.nextObject() as! String) {
            try? fileManager.removeItem(atPath: CACHE_PATH + #"/"# + fileName)
        }
        
        complete()
    }
    
    /**
     *  删除某个文件
     *
     *  @param pathName 文件的绝对路径
     *  @param block    完成删除后的操作
     */
    static func deleteFileWithPathName(pathname:String, complete: @escaping () -> ()) {
        let fileManager:FileManager = FileManager.default
        try? fileManager.removeItem(atPath: pathname)
        complete()
    }
}
