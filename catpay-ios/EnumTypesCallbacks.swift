//
//  EnumTypesCallbacks.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/12/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


// Response Alamofire callbacks

public enum ECallbackResultType {
    
    case Success(Any?)
    case UnknownError
    case AccessTokenTimeout // Access Token for the user is timed out
    case APIEndpointNotAvailable // The API endpoint is not available
    case InvalidToken // Invalid Token
    case NoInternetConnection // Invalid Token
    
    // Error with body //
    
    case NotFound(String) // http 404 not found
    case BadRequest(String) // invalid http 400
    case NotAuthorized(String) // Access invalid
    case InternalServerError(String) //500
    case Forbidden(String) // http 403 forbidden

    
}
