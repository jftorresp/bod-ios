//
//  banksModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/27/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper


class banksModel:Mappable{


    var id = 0
    var name = ""
    var code = ""

    required init?(map:Map){}
    
    
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
    }


}
