//
//  APIHelper.swift
//  MNA
//
//  Created by Apple on 02/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class APIHelper: NSObject {

  /*  class func deviceTokenRegisterOnServer(){
        
        var userID = ""
        if let data = UserDefaults.standard.data(forKey: UserDetails),
            let myUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            userID = myUser.UserId!
        }
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            return
        }
        
        let urlString = KSCApiUrl + SERVICE_METHOD_UpdateNotificationToken
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let NotificationToken = DefaultDataManager.getDeviceToken()
        
        let paramString = ["DeviceId": deviceID, "UserId" : userID, "NotificationToken" : NotificationToken]
        KSCConnectionHelper.KSCgetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            if let statusVal = responce.object(forKey: "Status") {
                
                if (statusVal as! NSString).intValue == 1 {
                    print("deviceTokenRegisterOnServer ...Success")
                }else{
                    print("deviceTokenRegisterOnServer ...fail")
                }
            }
            
        }
        
    }//ENDED deviceTokenRegisterOnServer
    */
    
    
}
