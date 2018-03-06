//
//  Validations.swift
//  MNA
//
//  Created by Apple on 02/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class Validations: NSObject {

    
    class func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
}
