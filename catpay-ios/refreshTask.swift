//
//  refreshTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

extension Task {

    static func refresh(completion:@escaping(Bool) ->Void){
        
        Check { (status_check) in
            
            if(!status_check){
                
                print("check fail in refresh")
                completion(false)
                return
            }
        
        let endpoint  = AppSettings.GetEnpoint(endpoint: AppSettings.API_OAUTH_TOKEN)
        let networking = ApiRest<TokensModel>()
        let headers = UtilityMethods.getHeadersLogin()
        let params = RefreshModel().toJSON()
        networking.connect(url: endpoint, parameters: params, headers: headers) { (Response) in
            
            switch Response{
                
            case .Success(let data):
                
                let refresh = data as! TokensModel
                let keychain = KeychainSwift()
                keychain.set(refresh.toJSONString()!, forKey: "Session")
                completion(true)
                
            default:
               
            // default fail refresh sesion expired
             
                // session expirada
                let msg = NSLocalizedString("notification.session_expired_message", comment: "")
                let title = NSLocalizedString("notification.session_expired", comment: " ")
                let alert = UtilityMethods.createExitAlert(title: title , message:[msg])
                
                let vc = UtilityMethods.getTopViewController()                
                vc?.present(alert, animated:true,completion:nil)
                UIApplication.shared.endIgnoringInteractionEvents()
                completion(false)
                

            }
            
        }
    }
 }

}
