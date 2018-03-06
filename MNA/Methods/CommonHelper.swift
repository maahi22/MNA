//
//  CommonHelper.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import Reachability
import CoreData


class CommonHelper: NSObject {

    
    
    class func populateDBWithPulish (_ publish:String ,publication:String , edit:String ,appData:String){
        
        
        
        
    }
    
    
    //***** Json Methods
   class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    class func ConvertJsonStringToArray(_ jsonString:String) -> NSArray{
       
        if jsonString == "" {
            return NSArray()
        }
        
        
        var myData:NSArray?
        
        if let data = jsonString.data(using: String.Encoding.utf8) {
            
            do {
              let  myData = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                
                if let resultdata = myData
                {
                    print(resultdata)
                    return resultdata
                }else{
                    return NSArray()
                }
            
            
            
            } catch let error as NSError {
                print(error)
               return NSArray()
            }
        }
        
        return NSArray()
        
    }
    
    
    
    
    class func convertArraytoJsonString(_ array:NSArray) -> String{
        
        var jsonString : String = ""
        do
        {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            {
                jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
        catch
        {
            print(error)
        }
        
        return jsonString
    }
    //***** Json Methods ENDED
    
    class func deleteUserCredential() -> Bool{
        var isDelete = true
        isDelete = false
        return isDelete
    }
    
    
   
    
    
  
    
    
    
    class func getApplicationDirectoryPath ()-> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return documentsDirectory as String
    }
    
    class func getLocalPath ()-> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return documentsDirectory as String
    }
    
    
    class func getDocDirPath ()-> URL  {
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        return documentsUrl 
    }
    
   
    
   class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    
    
    class func getApplicationLocalPath ()-> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return documentsDirectory as String
    }
    
    
    
    
    
    
    class func updateAnnotationsToServer(_ NewspaperId :Int){
        
        
        
    }
    
    //Fetch server annotation and save/update in Db
    class func fetchServerAnnotation(_ newspaperID:Int, completion: @escaping ( _ Status :Bool) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            return
        }
        
        let userId = DefaultDataManager.getUserName()
        let urlString = BaseUrl + MNAUrl_getAnnotations
        let paramString = ["UserId":userId,"NewspaperId":newspaperID] as [String : Any]
       // MNAConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (status) in
        MNAConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            if status {
                
                if let anotation = responce.object(forKey: "Annotation"){
                   
                    guard  let userId = responce.object(forKey: "UserId") else{
                        return
                    }
                    guard let newspaperId = responce.object(forKey: "NewspaperId") else{
                        return
                    }
                    
                    DBHelper.saveServerAnnotations(anotation as! NSArray, NewspaperId:newspaperId as! Int64 ,userId:userId as! String )//(anotation as! NSArray)
                   
                    completion(true)
                }
                
               //
            }else{
                completion(false)
            }
        }
        
        }
        
    
    
    
    
    //Update Annotation
    class func UpdateServerAnnotation(_ newspaperID:Int , objAnnotation:NSManagedObject){
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            
            return
        }
        
        let userId = DefaultDataManager.getUserName()
        let urlString = BaseUrl + MNAUrl_getAnnotations
        let paramString = ["UserId":userId,"NewspaperId":newspaperID] as [String : Any]
        
        MNAConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            if status {
                if let anotation = responce.object(forKey: "Products"){
                    DBHelper.UpdateServerAnnotations(anotation as! NSArray,objAnotation:objAnnotation )//(anotation as! NSArray)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //ANNOTATION Save
   class func saveAnnotations(_ jsonString:String){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.getContext()
    
    
    
    }
    
    
   class func saveServerAnnotations(jsonString:String , NewsPaperId:Int , completion: @escaping (_ Status :Bool) -> Void) {
        
        
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(NewsPaperId))")
        if annotationsList.count > 0 {
            
            guard  let jsonDict:NSDictionary = self.convertToDictionary(text: jsonString) as! NSDictionary else{
                return
            }
            let annotationObject:NSArray = jsonDict.value(forKey: "Annotation") as! NSArray
            var jsonAddStr = ""
            jsonAddStr = self.convertArraytoJsonString(annotationObject)
            
            
            var isFound = false
            let mangeObj:NSManagedObject = annotationsList[0]
            guard let jsonStr = mangeObj.value(forKey: "annotationObject") else{ return}
            let arrAnnObj:NSMutableArray =  NSMutableArray(array: self.ConvertJsonStringToArray(jsonStr as! String))
            var arrAnnObj1 = NSMutableArray()
            
            if arrAnnObj.count > 0 {
                
                for dicAnnotate in arrAnnObj {
                    
                    let dictOrignal = dicAnnotate as! NSDictionary
                   // var appendDict = dictOrignal
                    var appendDict: NSMutableDictionary = NSMutableDictionary(dictionary: dictOrignal)
                   
                    let id1 = dictOrignal.value(forKey: "id") as! Int
                    let id2 = ((annotationObject[0]) as AnyObject).value(forKey: "id") as! Int
                    
                    if id1 == id2 {
                        
                        var createdOn = ""
                        if let createdOn1 = dictOrignal.value(forKey: "createdOn"){
                            createdOn  = "\(createdOn1)"
                        }
                        
                        var annotationText = ""
                        if let annotationText1 = dictOrignal.value(forKey: "annotationText"){
                            annotationText  = annotationText1 as! String
                        }
                        
                        let createOnVal = Int64(createdOn)
                        appendDict.setValue(createOnVal, forKey: "createdOn")
                        appendDict.setValue(annotationText, forKey: "annotationText")
                        isFound = true
                    }
                    
                    arrAnnObj1.add(appendDict)
                    
                }
                
                
                var JsonSting1 = self.convertArraytoJsonString(arrAnnObj1)
                
                if !isFound && annotationObject.count > 0 {
    
                    arrAnnObj.add(annotationObject[0])
                    JsonSting1 = self.convertArraytoJsonString(arrAnnObj)
                }else{
                    JsonSting1 = self.convertArraytoJsonString(arrAnnObj1)
                }
               
            mangeObj.setValue(JsonSting1, forKey: "annotationObject")
                
            let userId = DefaultDataManager.getUserName()
            let urlString = BaseUrl + MNAUrl_SaveAnnotationsOnServer
            let paramString = ["UserId":userId,"NewspaperId":NewsPaperId, "Annotation":JsonSting1] as [String : Any]
            
            MNAConnectionHelper.SaveAnnotationWithParam(url: urlString, paramString: paramString, completion: { (status) in
                mangeObj.setValue(status, forKey: "annotation_Sync")
                do {
                    try mangeObj.managedObjectContext?.save()
                } catch {
                    print("Error occured during save entity")
                }
                completion(status)
            })
                
                
                
                
                
                
            }else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.getContext()
                
                let entityDescription = NSEntityDescription.entity(forEntityName: "Annotations", in: context)
                let annotations = NSManagedObject(entity: entityDescription!, insertInto: context)
                annotations.setValue(NewsPaperId, forKey: "newspaper_Id")
                
                guard  let jsonDict:NSDictionary = self.convertToDictionary(text: jsonString) as! NSDictionary else{
                    return
                }
                let anootationObj:NSArray = jsonDict.value(forKey: "Annotation") as! NSArray
                var jsonString = ""
                jsonString = self.convertArraytoJsonString(anootationObj)
                annotations.setValue(jsonString, forKey: "annotationObject")
                
                let userId = DefaultDataManager.getUserName()
                let urlString = BaseUrl + MNAUrl_SaveAnnotationsOnServer
                let paramString = ["UserId":userId,"NewspaperId":NewsPaperId, "Annotation":jsonString] as [String : Any]
                
                MNAConnectionHelper.SaveAnnotationWithParam(url: urlString, paramString: paramString, completion: { (status) in
                    annotations.setValue(status, forKey: "annotation_Sync")
                    do {
                        try annotations.managedObjectContext?.save()
                    } catch {
                        print("Error occured during save entity")
                    }
                    completion(status)
                })
                
            }
            
            
            
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.getContext()
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Annotations", in: context)
            let annotations = NSManagedObject(entity: entityDescription!, insertInto: context)
            annotations.setValue(NewsPaperId, forKey: "newspaper_Id")
           
            guard  let jsonDict:NSDictionary = self.convertToDictionary(text: jsonString) as! NSDictionary else{
                return
            }
            let anootationObj:NSArray = jsonDict.value(forKey: "Annotation") as! NSArray
            var jsonString = ""
            jsonString = self.convertArraytoJsonString(anootationObj)
            annotations.setValue(jsonString, forKey: "annotationObject")
            
            let userId = DefaultDataManager.getUserName()
            let urlString = BaseUrl + MNAUrl_SaveAnnotationsOnServer
            let paramString = ["UserId":userId,"NewspaperId":NewsPaperId, "Annotation":jsonString] as [String : Any]
            
            MNAConnectionHelper.SaveAnnotationWithParam(url: urlString, paramString: paramString, completion: { (status) in
                
                annotations.setValue(status, forKey: "annotation_Sync")
              
                    do {
                        try annotations.managedObjectContext?.save()
                        
                        /* let alert = UIAlertController(title: "Alert", message: "Company info save succesfully. ", preferredStyle: UIAlertControllerStyle.alert)
                         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                         self.navigationController?.popViewController(animated: true)
                         }))
                         self.present(alert, animated: true, completion: nil)*/
                        
                    } catch {
                        print("Error occured during save entity")
                    }
                
             
                completion(status)
                //success delete
                
            })
            
        }
        
        
    }
    
    
    
    
    
    func clearEntity(_ entityName:String){
        
        
        
    }
    
    
  class  func deleteAnnotationDB(_ annotationId:Int, NewsPaperId:Int, completion: @escaping (_ Status :Bool) -> Void) {
        
    //Getting Annotation List
    let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(NewsPaperId))")
    if annotationsList.count > 0 {
        var delMangeObj:NSManagedObject?
        for anotation in annotationsList {
            let idval  = anotation.value(forKey: "id") as! Int
            if  idval == annotationId {
                
                delMangeObj = anotation
                
            }
            
        }
        
        if let del = delMangeObj {
            let userId = DefaultDataManager.getUserName()
            let urlString = BaseUrl + MNAUrl_DeleteAnnotationsOnServer
            let paramString = ["UserId":userId,"NewspaperId":NewsPaperId, "Annotation":annotationId] as [String : Any]
            MNAConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString, completion: { (responce, status) in
                
                
               completion(status)
                //success delete
                
            })
            
        }else{
            completion(false)
        }
        
        
    }else{
        completion(false)
    }
        
    
    }
    
    
    

    
    
    
    func getAnnotationIdDB(_ newspaperId:NSNumber) ->Int{
        
        var annotationId = 0
        
        //Getting Annotation List
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(newspaperId))")
        if annotationsList.count > 0 {
            let anotationObj = annotationsList[0]
            //let dictAnnotation = JSONSerialization.ob
            let str = anotationObj.value(forKey: "annotationObject") as! String
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
              
                if jsonDict != nil && jsonDict.count > 0 {
                    annotationId = jsonDict.count + 1
                    
                    //for annObj in jsonDict {
                        //let localDic = annObj as NSDictionary
                    let id = anotationObj.value(forKey: "id") as! Int
                    
                        if  id == annotationId {
                            annotationId = jsonDict.count + 2
                        }
                   // }
                }else{
                    
                    annotationId = 1
                }
                    
                
            
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
 
        }

        
        
        
        return annotationId
    }
    
    
    
    
    
    
    
    
    func getDateFromEpochDate(_ epochdate :String) -> String{
        
        
        return ""
    }
    
    
    //*****  get comment image
    class func getCommentImage(_ annotationId:Int , NewspaperId: Int64) -> UIImage{
        
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(NewspaperId))")
        if annotationsList.count > 0 && annotationId != 0 {
            let objAnnotation = annotationsList[0]
            let jsonStr = objAnnotation.value(forKey: "annotationObject")
            let pushPinArray = CommonHelper.convertToDictionary(text: jsonStr as! String) as! NSArray
            
            for pushpinObj in pushPinArray{
                let obj = pushpinObj as! NSDictionary
                let id = obj.value(forKey: "Id") as! Int64
                if annotationId ==  id {
                    
                    
                    
                }
                
            }
            
            
        }else{
            return UIImage()
        }
        
        
    }
    
    
    
    
    
}
