//
//  String+Methods.swift
//  MNA
//
//  Created by Maahi on 24/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import Foundation


extension String {
    func safeAddingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String? {
        // using a copy to workaround magic: https://stackoverflow.com/q/44754996/1033581
        let allowedCharacters = CharacterSet(bitmapRepresentation: allowedCharacters.bitmapRepresentation)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
