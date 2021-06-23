//
//  Login.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/12/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginModel:Mappable{
    
    var phone:String = ""
    var password:String = ""
    
    init(phone: String, password: String) {
        
        self.phone = phone
        self.password = password

    }
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        phone <- map["phone"]
        password <- map["password"]
        
    }

}
