//
//  SessionsModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


//
//  UsersModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper


class SessionsModel:Mappable{
    
    
    var id: String = ""
    var firstNames: String = ""
    var lastNames: String = ""
    var documentId: String = ""
    var phoneNumber: String = ""
    var docType: String = ""
    var email: String = ""
    var confirmed: Bool = false
    var hasPinLock: Bool = false
    var birthDay: String = ""
    var account: AccountModel? = nil
    var status = ""
    var balance: Float = 0.0
  
    
    // qr only
    var amount: String? = nil;
    var description: String? = nil;
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstNames <- map["firstNames"]
        lastNames <- map["lastNames"]
        documentId <- map["documentId"]
        phoneNumber <- map["phoneNumber"]
        docType <- map["docType"]
        email <- map["email"]
        confirmed <- map["confirmed"]
        hasPinLock <- map["hasPinLock"]
        birthDay <- map["birthDay"]
        account <- map["account"]
        status <- map["status"]
        balance <- map["balance"]
        amount <- map["amount"]
        description <- map["description"]
    }
    
}
