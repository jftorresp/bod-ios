//
//  AccountModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountModel:Mappable{


    var name = ""
    var id = 0 
    var code = ""
    
    required init(map:Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        id <- map["id"]
        code <- map["code"]

    }


}
