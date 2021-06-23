//
//  deviceRequestModel.swift
//  catpay-ios
//
//  Created by IOS Developer on 11/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainSwift
import FirebaseMessaging


class deviceRequestModel: Mappable{

    var deviceId = ""
    var name = ""
    var model = ""
    var pushToken = ""
    var ipAddress = ""
    var type = "Iphone"
    private let keyAccess = "deviceIdKey2"


    required init?(map: Map) {
        
    }
    
    init(){
        
    
        let localStorage  = UserDefaults.standard
        
        if let deviceId = localStorage.string(forKey: keyAccess) {
            
            self.deviceId = deviceId
            
        }
        
        self.name = UIDevice.current.name
        self.model = UIDevice.current.modelName
        
        if let fcmToken = Messaging.messaging().fcmToken{
            self.pushToken = fcmToken
        }
    
    
    }
    
    func mapping(map: Map) {
        
        deviceId <- map["deviceId"]
        name <- map["name"]
        model <- map["model"]
        pushToken <- map["pushToken"]
        ipAddress <- map["ipAddress"]
        type <- map["type"]
        
        
        
    }

}
