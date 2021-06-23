//
//  RegisterModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/14/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class RegisterModel:Mappable{

    var accountId: Int = 0
    var phoneNumber: String = ""
    var firstNames: String = ""
    var lastNames: String = ""
    var documentId: String = ""
    var docType: String = ""
    var email: String = ""
    var password: String = ""
    var security: PinModel? = nil
    var deviceInfo: DeviceModel? = nil
        
    required init?(map: Map) {
        
    }
    
    
    init(phoneNumber:String, firstNames:String, lastNames:String, email:String , password:String, documentId:String, docType:String){
        
        self.accountId = 23
        self.phoneNumber = phoneNumber
        self.firstNames = firstNames
        self.lastNames = lastNames
        self.email = email
        self.password = password
        self.docType = docType
        self.documentId = documentId
        self.security = PinModel(pin: "1234")
        self.deviceInfo = DeviceModel()
    }
    
    func mapping(map: Map) {
        
        accountId <- map["accountId"]
        password <- map["password"]
        firstNames <- map["firstNames"]
        lastNames <- map["lastNames"]
        documentId <- map["documentId"]
        phoneNumber <- map["phoneNumber"]
        docType <- map["docType"]
        email <- map["email"]
        security <- map["security"]
        deviceInfo <- map["deviceInfo"]
    }

}
