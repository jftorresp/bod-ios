//
//  RefreshModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainSwift
class RefreshModel:Mappable {


    var grantType = "refresh_token"
    var refreshToken = ""
    var clientId = ""
    var clientSecret = ""
    
    
    init(){
        
        self.refreshToken = OAuthManager.shared.refreshToken
        self.clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
        self.clientSecret = AppSettings.Configuration(main: Bundle.main)["ClientSecret"] as! String

        
    }
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        grantType <- map ["grant_type"]
        refreshToken <- map ["refresh_token"]
        clientId <- map ["client_id"]
      //  clientSecret <- map["client_secret"]
    }

}
