//
//  LoginResponseModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper

class TokensModel:Mappable{

    var token_type = ""
    var access_token = ""
    var expires_in = ""
    var refresh_token = ""
    var balance:Double = 0.0
    var status = ""
    
    private var formatBalance = ""{
        didSet{
            self.balance = Double(formatBalance) ?? 0.0
        }
    }
    
    
    required init?(map:Map){
    }
    
    func mapping(map: Map) {
        
        token_type <- map["token_type"]
        access_token <- map["access_token"]
        expires_in <- map["expires_in"]
        refresh_token <- map["refresh_token"]
        formatBalance <- map["balance"]
        status <- map["status"]
    }
}
