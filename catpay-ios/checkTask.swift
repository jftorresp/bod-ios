    //
//  checkTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

extension Task {

    static func Check(completion:@escaping(Bool)->Void){
        
        let networkCheck = ApiRest<emptyModel>()
        
        // checamos con application check
        
        let endpointCheck = AppSettings.GetEnpoint(endpoint: AppSettings.API_APPLICATION_CHECK)
        
        networkCheck.get(url: endpointCheck, headers: ["Content-Type":"application/json"]) { (response) in
            
            switch response {
                
            case .Success:
                
                completion(true)
            
            case .NoInternetConnection:
                    
                completion(false)
                    
            default:
                
                OAuthManager.shared.handlerConnectionInternet()
                completion(false)
              
            }
            
        }
        
        
    }

}
