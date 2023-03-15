//
//  Notification(ext).swift
//  lolmTool
//
//  Created by mac on 2022/3/1.
//

import Foundation


extension Notification {
    
    static var LolmDF_Netstatus_notification:Notification {
        
        get {
            
            .init(name: Notification.Name.init("lolmdf_NetStatus_update_no"))
        }
    }
    
    
   static var LolmDF_TokenTimeout_notification:Notification {
        
    get {
        
        .init(name: Notification.Name.init("lolmdf_TOKEN_ERROR_NO"))
    }
    }
    
    static var LolmDF_RentSuccess_notification:Notification {
         
     get {
         
         .init(name: Notification.Name.init("lolmdf_rent_success"))
     }
     }
    
    static var LolmDF_Logout_notification:Notification {
         
     get {
         
         .init(name: Notification.Name.init("lolmdf_user_logout"))
     }
     }
}
