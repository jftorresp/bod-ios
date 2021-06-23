//
//  AccountInfoModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/27/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper


class AccountInfoModel:Mappable{
    
    var name = ""
    var phoneNumber = ""
    var lastTwoDigitId = ""
    var docType = ""
    
    init(){}
    required init?(map:Map){}
    
    func mapping(map: Map) {
        name <- map["name"]
        phoneNumber  <- map["phoneNumber"]
        lastTwoDigitId <- map["lastTwoDigitId"]
        docType <- map["docType"]
        
    }
    
}
