//
//  DefaultDataManager.swift
//  MNA
//
//  Created by Apple on 02/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class DefaultDataManager: NSObject {


    class func SaveDeviceToken(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "DeviceToken")
            kUserDefault.synchronize()
        }
    }
    
    class func getDeviceToken() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "DeviceToken")  {
            return Token as! String
        }
        return ""
    }



    //System Version
    class func SaveSystemVersion(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "SystemVersion")
            kUserDefault.synchronize()
        }
    }
    
    class func getSystemVersion() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "SystemVersion")  {
            return Token as! String
        }
        return ""
    }
    
    //App Version
    class func SaveAppVersion(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "AppVersion")
            kUserDefault.synchronize()
        }
    }
    
    class func getAppVersion() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "AppVersion")  {
            return Token as! String
        }
        return ""
    }
    
    //Modal name
    class func SaveModalName(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "ModalName")
            kUserDefault.synchronize()
        }
    }
    
    class func getModalName() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "ModalName")  {
            return Token as! String
        }
        return ""
    }
    
    
    //UserName and password
    //App userName
    class func SaveUserName(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "userName")
            kUserDefault.synchronize()
        }
    }
    
    class func getUserName() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "userName")  {
            return Token as! String
        }
        return ""
    }
    
    class func removeUserName(){
        let kUserDefault = UserDefaults.standard
        kUserDefault.removeObject(forKey: "userName")
    }
    
    //App Password
    class func SavePassword(_ token :String){
        let kUserDefault = UserDefaults.standard
        if token != nil {
            kUserDefault.set(token, forKey: "Password")
            kUserDefault.synchronize()
        }
    }
    
    class func getPassword() -> String{
        let kUserDefault = UserDefaults.standard
        if let Token = kUserDefault.value(forKey: "Password")  {
            return Token as! String
        }
        return ""
    }
    
    class func removePassword(){
        let kUserDefault = UserDefaults.standard
        kUserDefault.removeObject(forKey: "Password")
    }
    


}
