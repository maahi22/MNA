//
//  DateHelper.swift
//  MNA
//
//  Created by Apple on 02/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
   
    
    class func converDateToString(_ dateVal:NSDate) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/mm/yyyy hh:mm"
        return dateFormat.string(from: dateVal as Date)
    }

    class func convertToDateFromString(_ dateStr:String)-> Date{
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if dateStr == "" {
            let date = Date()
            return date
            
        }else{
            let date = dateFormat.date(from: dateStr)
            return date!
        }
    }

    

}
