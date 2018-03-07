//
//  FileHelper.swift
//  MNA
//
//  Created by Apple on 02/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class FileHelper: NSObject {

    func CreateADIRWithName(_ folderName:String) -> Bool {
        var success = false
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dataPath = documentsDirectory.appendingPathComponent(folderName)
        
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
                success = true
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
                success = false
                
            }
        }
        
        return success
    }
    
    
   class func SaveImageFromUrlToFileAtPtah(_ filePath :NSURL , urlString : String) -> Bool {
        var success = false
        let url = URL(string:urlString)
        let data = try? Data(contentsOf: url!)
        let image: UIImage = UIImage(data: data!)!
        
        do {
            try UIImagePNGRepresentation(image)!.write(to: filePath as URL)
            print("Image Added Successfully")
            success = true
        } catch {
            print(error)
            success = false
        }
        return success
    }
    
    
    
    class func SaveImageAtPtah(_ filePath :NSURL  ,image:UIImage) -> Bool {
        var success = false
        
        do {
            try UIImagePNGRepresentation(image)!.write(to: filePath as URL)
            print("Image Added Successfully")
            success = true
        } catch {
            print(error)
            success = false
        }
        return success
    }
    
    
    
    
    
    class func getImageFromDocDir(_ fileName: String , completion:@escaping ( _ image :UIImage , _ Status:Bool) -> Void ){
        
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: imagePAth){
            let img = UIImage(contentsOfFile: imagePAth)
            completion(img!, true)
        }else{
            print("No Image")
            completion(UIImage(), false)
        }
        
    }
    
    
    class func saveImageDocumentDirectory(_ name :String , imageData: NSData){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        fileManager.createFile(atPath: paths as String, contents: imageData as Data, attributes: nil)
    }
    
    
    class func deleteImageDocumentDirectory(_ name :String ){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }
        
        
    }
    
    
    
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Create Directory :
    class func createDirectory(_ dirName: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dirName)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
    //Delete Directory :
    func deleteDirectory(_ dirName: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dirName)
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Something wronge.")
        }
    }
    
    
    
    
    
    
    //Download files
    
    
    
    
    
}
