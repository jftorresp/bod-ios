//
//  ApiRestProtocol.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/12/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Alamofire
import UIKit
import AlamofireObjectMapper

protocol ApiRestProtocol {
    
    // implements methods HTTP //
    
    func get(withAuthorization authorization:Bool , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType)  -> Void)
    
    func getArray(withAuthorization authorization:Bool , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType)  -> Void)
    
    func put(withAuthorization authorization:Bool , url: String, withParams parameters: [String : Any]?, headers: [String : String]? ,  callback: @escaping (ECallbackResultType) -> Void)
    
    func putArray(withAuthorization authorization:Bool , url: String, withParams parameters: [String], headers: [String : String]? ,  callback: @escaping (ECallbackResultType) -> Void)
    
    func delete(withAuthorization authorization:Bool , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType)  -> Void)
    
    func patch(withAuthorization authorization:Bool , url: String, parameters: [String : Any]?, headers: [String : String]?, callback: @escaping (ECallbackResultType) -> Void)
    
    func create(withAuthorization authorization:Bool , url: String, parameters: [String : Any]?, headers: [String : String]?,callback: @escaping (ECallbackResultType) -> Void)

}

protocol expiredSessionProtocol {
    
    func handlerExpiredSession (presentView : UIViewController)
    
}


protocol lostConnectionProtocol{
    
    func handlerConnectionInternet()
    
}


// extension and utilities for ApiRest //

// DEBUG LOG  ///

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}
