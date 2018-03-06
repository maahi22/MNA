//
//  AlertModel.swift
//  MNA
//
//  Created by Apple on 03/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import Foundation

class AlertModel {
    
    @objc dynamic var N_Id: String?  = ""
    @objc dynamic var S_Description: String?  = ""
    @objc dynamic var DT_CreatedOn: String?  = ""
    
    init(){
        
    }
    
    init(N_Id: String,S_Description: String,DT_CreatedOn: String?){
        self.N_Id = N_Id
        self.S_Description = S_Description
        self.DT_CreatedOn = DT_CreatedOn
    }

    
}




