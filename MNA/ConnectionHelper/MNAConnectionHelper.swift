//
//  MNAConnectionHelper.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit

class MNAConnectionHelper: NSObject {

    class func GetParam(_ params: NSDictionary) -> NSString{
        var passparam : NSString!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let theJSONText = NSString(data: jsonData,
                                       encoding: String.Encoding.ascii.rawValue)
            passparam = theJSONText!
        } catch let error as NSError {
            print("getParam() \(error)")
            passparam = ""
        }
        return passparam
    }
    
    
    
    
    //https://stackoverflow.com/questions/41745328/completion-handlers-in-swift-3-0
    class  func GetDataFromJson(url: String, paramString: [String : Any], completion: @escaping (_ success: NSDictionary ,  _ Status :Bool) -> Void) {
        
        print("GetDataFromJson \(url)   Param \(paramString)")
        
        
        
        //@escaping...If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is @escaping.
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            
            
            
            
            if error != nil{
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: Data!, options: []) as? [String:AnyObject]
                
                print("Result",result!)
                
            } catch {
                print("Error -> \(error)")
            }
            
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completion(responseJSONDict as! NSDictionary ,true)
                // print(responseJSONDict)
                
                
            } catch {
                print(error)
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
            }
            
            
            
        }
        task.resume()
    }
    
    
    class  func GetDataFromJson(url: String,  completion: @escaping (_ success: NSDictionary ,  _ Status :Bool) -> Void) {
        
        print("GetDataFromJson \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completion(responseJSONDict as! NSDictionary ,true)
                //print(responseJSONDict)
                
            } catch {
                print(error)
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
            }
            
        }
        task.resume()
    }
    
    
    
    class func urlToImageConverter (_ imageUrl:String ,completionHandler :@escaping ( _ image :UIImage , _ Status:Bool) -> Void ){
        
        URLSession.shared.dataTask(with: NSURL(string: imageUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                completionHandler (UIImage() , false)
                return
            }
            
            let image = UIImage(data: data!)
            if image == nil {
                completionHandler (UIImage() , false)
                return
            }
            
            completionHandler (image! , true)
            
        }).resume()
        
    }
    
    
    
    class func CallAgetApiWithoutParameter (_ urlString:String ,completionHandler :@escaping ( _ success: NSDictionary ,  _ Status :Bool) -> Void ){
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {Data, response, error in
            
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completionHandler(dict as NSDictionary ,false)
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completionHandler(dict as NSDictionary ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completionHandler(responseJSONDict as! NSDictionary ,true)
                //print(responseJSONDict)
                
                
            } catch {
                print(error)
            }
            
            
            
            }.resume()
        
        
    }
    
    
    
    //MNA NOtification
    class  func GetRequestFromJson(url: String,  completion: @escaping (_ success: NSArray ,  _ Status :Bool) -> Void) {
        
        print("GetDataFromJson \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                let dict : [Any] = []
                completion(dict as NSArray  ,false)
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict : [Any] = []
                completion(dict as NSArray ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completion(responseJSONDict as! NSArray ,true)
                //print(responseJSONDict)
                
            } catch {
                print(error)
                let dict : [Any] = []
                completion(dict as NSArray ,false)
            }
            
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    //Call Login
    class  func LoginCalled(url: String, paramString: [String : Any], completion: @escaping ( _ Status :Bool) -> Void) {
        
       
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                completion(false)
                return
            }
            
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    print(stringData) //JSONSerialization
                
                    if stringData == "true" {
                        completion(true)
                    }else{
                        completion(false)
                    }
                
                
                }
            }
            
        }
        task.resume()
    }
    
    //Password change
    class  func ChangePasswordCalled(url: String, paramString: [String : Any], completion: @escaping ( _ Message:String , _ Status:Bool) -> Void) {
        
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                             
                completion("",false)
                return
            }

        
        
        
            if let data = Data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    print(stringData) //JSONSerialization
                    
                    if stringData == "true" {
                        completion("",true)
                    }else{
                        completion("",false)
                    }
                    
                    
                }
            }
            
        }
        task.resume()
    }

    
    
    
    //Call Save AnnotationOn server
    class  func SaveAnnotationWithParam(url: String, paramString: [String : Any], completion: @escaping ( _ Status :Bool) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                completion(false)
                return
            }
            
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
               //     print(stringData)
                    
                    if stringData == "Success" {
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    //Call delete AnnotationOn server
    class  func DeleteAnnotationWithParam(url: String, paramString: [String : Any], completion: @escaping ( _ Status :Bool) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                completion(false)
                return
            }
            
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    //     print(stringData)
                    
                    if stringData == "Success" {
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    //Download file
    class func DownloadFiles(url: URL, to localUrl: URL,NewspaperId:Int, completion: @escaping (_ Status :Bool) -> ()) {
        
        //fetch annotation list from server
        CommonHelper.fetchServerAnnotation(NewspaperId) { (status) in
            
            print("fetchServerAnnotation  \(status)")
        }
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion(true)
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                    completion(false)
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
                completion(false)
            }
        }
        task.resume()
    }
    
    
    
    
    
   
    
    
    
    
    
}
