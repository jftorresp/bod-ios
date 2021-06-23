//
//  ErrorParseableDecorator.swift
//  catpay-ios
//
//  Created by Juan Vasquez on 09-07-20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import Foundation


class ErrorParseableDecorator {
    
    class func decorate(error message: String) -> String {
        
        if message == "Incorrect password." {
            return NSLocalizedString("notification.change.incorrect.password", comment: "")
        }
        return message
    }
}
