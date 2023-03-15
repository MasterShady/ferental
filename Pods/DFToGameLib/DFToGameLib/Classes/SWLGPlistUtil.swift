//
//  SWLGPlistUtil.swift
//  DFToGameLib
//
//  Created by mac on 2022/1/11.
//

import Foundation

class DFToGameLib {
    
}

open class SWLGPlistUtil {
    
    public init() {
        
    }
    

    
    open func getTemplate() ->String?  {
         
        let path = getCurrentBundle().bundlePath.appending("/template.plist")

       return path

       
    }
}


func getCurrentBundle() -> Bundle{
           
   let podBundle = Bundle(for: DFToGameLib.self)
   
   let bundleURL = podBundle.url(forResource: "DFToGameLibBundle", withExtension: "bundle")
   
   if bundleURL == nil {
       if podBundle.bundlePath.contains("DFToGameLib.framework") {   // carthage
           return podBundle
       }
   }
   
   if bundleURL != nil {
       let bundle = Bundle(url: bundleURL!)!
       return bundle
   }else{
       return Bundle.main
   }
}
