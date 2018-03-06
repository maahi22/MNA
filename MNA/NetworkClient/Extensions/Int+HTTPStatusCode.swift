//
//  Int+HTTPStatusCode.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

extension Int{
    public var isSuccessHTTPCode: Bool{
        return 200 <= self && self < 300
    }
}
