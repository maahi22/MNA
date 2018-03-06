//
//  DownloadHelper.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit

class DownloadHelper: NSObject {

    
    class func deleteFileFromDocDirName(_ fileName:String) ->Bool{
        
        var returnStatus = false
        
        let documentsUrl: URL = CommonHelper.getDocDirPath()
        let pdfPath = documentsUrl.appendingPathComponent("pdffiles/\(fileName).pdf")
        let jsonPath = documentsUrl.appendingPathComponent("pdffiles/\(fileName).json")
        
        let fileManger = FileManager.default
        do {
            
            //Delete pdf file
            let filePath = pdfPath.path
            if fileManger.fileExists(atPath: filePath){
                try  fileManger.removeItem(atPath: filePath)
            }else{
                print("Not Exist ")
            }
            
            //Delete json file
            let filePath2 = jsonPath.path
            if fileManger.fileExists(atPath: filePath2){
                try  fileManger.removeItem(atPath: filePath2)
                returnStatus = true
            }else{
                print("Not Exist ")
                returnStatus = false
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        
        return returnStatus
    }
    
    
    class  func getJSONFromServer()  {
        
        
        
        
    }
    
}
