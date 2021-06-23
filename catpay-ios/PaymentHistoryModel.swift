//
//  PaymentHistoryModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper


class PaymentHistoryModel:Mappable {


    
    var operationId = ""
    var description = ""
    var amount = 0.00
    var succeeded = false
    var feedBack = ""
    var payer:AccountInfoModel? = nil
    var recipient:AccountInfoModel? = nil
    var senderAccountId = 0
    var recipientAccountId = 0
    var created = ""
    var referencesHistoryName = ""
    var nameBank = ""
    var status = ""
    var balance: Double = 0.0
    
    required init?(map: Map) {
        
   
    }
    
    
    func mapping(map: Map) {
        
        operationId <- map["operationId"]
        description <- map["description"]
        amount <- map["amount"]
        succeeded <- map["succeeded"]
        feedBack <- map["feedBack"]
        payer <- map["payer"]
        recipient <- map["recipient"]
        senderAccountId <- map["senderAccountId"]
        recipientAccountId <- map["recipientAccountId"]
        created <- map["created"]
        status <- map["status"]
        balance <- map["balance"]
        
    }

}


