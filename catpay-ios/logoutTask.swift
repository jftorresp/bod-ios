//
//  logoutTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

extension Task{

    static func logout(completion:@escaping(Bool)->Void){
        
        
        let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_OAUTH_REVOKE)
        let networking = ApiRest<emptyModel>()
        let headers =  UtilityMethods.getHeadersLogin()
        let params = LogoutModel().toJSON()
        
        networking.connect(url: endpoint, parameters: params, headers:headers) { (Response) in
            
            switch Response {
                
            case .Success:
                
                print("logout success")
                // unregister push notifications //
                UIApplication.shared.unregisterForRemoteNotifications()
                OAuthManager.shared.closeSession()
                completion(true)
                
            default:
                completion(false)
                
            }
            
        }
        
    }


}
