//
//  LogoutModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainSwift

class LogoutModel:Mappable{

    var token = ""
    var clientId = ""
    
    
    required init?(map:Map){}
    
    init(){
        
       // let keyChain = KeychainSwift()
        
       // if let data = keyChain.get("Session"){
           // let session =  //TokensModel(JSONString: data)
            self.token = OAuthManager.shared.refreshToken//(session?.refresh_token)!
        //}
        
        self.clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
    
    }
    
    
    func mapping(map: Map) {
        token <- map["token"]
        clientId <- map["client_id"]
    }


}
