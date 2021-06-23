//
//  LoginRequestModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class LoginRequestModel:Mappable{

    var password = ""
    var username = ""
    var grant_type = ""
    var scope = ""
    var client_id = ""
    var client_secret = ""

    
    required init?(map: Map) {
        
    }
    
    
    init(username:String,password:String){
        
        self.grant_type = "password"
        self.scope = "offline_access"
        self.username = username
        self.password = password
        self.client_id = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
        self.client_secret = AppSettings.Configuration(main: Bundle.main)["ClientSecret"] as! String

        
    }
    
    func mapping(map: Map) {
        
        username <- map["username"]
        password <- map["password"]
        grant_type <- map["grant_type"]
        scope <- map["scope"]
       // client_secret <- map["client_secret"]
        client_id <- map["client_id"]
        
    }

}

