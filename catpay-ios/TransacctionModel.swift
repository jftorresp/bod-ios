//
//  TransacctionModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/29/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper

class TransacctionModel:Mappable {


    var recipient:AccountInfoModel? = nil
    var recipientAccountId  = 0
    var amount = 0.0
    var description = ""
    var security:PinModel? = nil
    
    init(){
        self.recipient = AccountInfoModel()
    }
    
    required init?(map:Map){}
    
    func mapping(map:Map){
    
        recipient <- map ["recipient"]
        recipientAccountId <- map ["recipientAccountId"]
        amount <- map ["amount"]
        description <- map ["description"]
        security <- map ["security"]
    }


}
