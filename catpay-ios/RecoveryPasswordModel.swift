//
//  RecoveryPasswordModel.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire


class RecoveryPasswordModel: Mappable{


    var emailAddress = ""
    var resetToken = ""
    var newPassword = ""
    var confirmPassword = ""

        
    required init?(map: Map) {
        
    }

    init(emailAddress: String, newPassword:String, confirmPassword: String, resetToken: String){

        self.emailAddress = emailAddress
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
        self.resetToken = resetToken.removingPercentEncoding!.removingPercentEncoding!
    }
    
    func mapping(map: Map) {
        
        emailAddress <- map["emailAddress"]
        newPassword <- map["newPassword"]
        confirmPassword <- map["confirmPassword"]
        resetToken <- map ["resetToken"]
    }

}



