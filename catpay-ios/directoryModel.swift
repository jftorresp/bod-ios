//
//  directoryModel.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 5/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
// ObjectMapper es una libreria que facilita pasar de un modelo de Swift a JSON y viceversa.

class directoryModel: Mappable {
    
    var id: String?
    var fullName: String?
    var documentType: String?
    var documentId: String?
    var phoneNumbers: [String]?
    
    required init?(map: Map) {
        
    }
    
    init(fullName: String, documentType: String, documentId: String , phoneNumbers: [String]){
        
        self.fullName = fullName
        self.documentType = documentType
        self.documentId = documentId
        self.phoneNumbers = phoneNumbers
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        documentType <- map["documentType"]
        documentId <- map["documentId"]
        phoneNumbers <- map["phoneNumbers"]
    }
}


