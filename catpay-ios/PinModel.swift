//
//  PinModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/14/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper


class PinModel:Mappable{

    var pin:String = ""
    
    required init?(map: Map) {
        
    }
    
    
    init(pin:String){
    
        self.pin = pin
    }
    
    func mapping(map: Map) {
        pin <- map["pin"]
    }
    

}
