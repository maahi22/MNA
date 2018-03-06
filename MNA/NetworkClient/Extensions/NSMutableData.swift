//
//  NSMutableData.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 18/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
