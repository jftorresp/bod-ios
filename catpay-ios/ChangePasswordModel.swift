//
//  ChangePasswordModel.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


import ObjectMapper
import Alamofire

class ChangePasswordModel:Mappable{
    
    var password = ""
    var newPassword = ""
    
    required init?(map: Map) {
        
    }
    
    
    init(password:String,newPassword:String){
        
        
       
        self.password = password
        self.newPassword = newPassword
        
    }
    
    func mapping(map: Map) {
        
        password <- map["password"]
        newPassword <- map["newPassword"]
        
       
    }
    
}

