//
//  FSFileConfig.swift
//  DoFunNew
//
//  Created by mac on 2021/3/8.
//

import Foundation

class LolmDFFileConfig: NSObject {
    var fileData : Data
    var name : String
    var fileName : String
    var mimeType : String
    
    override init() {
        fileData = Data()
        name = ""
        fileName = ""
        mimeType = ""
    }
    
    func initFile(fileData : Data,name : String,fileName : String,mimeType : String) {
        self.fileData = fileData
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}


