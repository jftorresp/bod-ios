//
//  FailableObjectModel.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/12/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import ObjectMapper

public class APIError: Mappable {
    
    var message: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        message <- map["message"]
    }
    
    func getMessage() -> String? {
        return self.message
    }
}
