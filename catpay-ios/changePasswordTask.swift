//
//  changePasswordTask.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import KeychainSwift


extension Task {

    
    static func changePassword (refreshed:Bool, param:ChangePasswordModel, completion:@escaping(AnyObject?)->Void) {
            
        Check { (status_check) in
            
            if(!status_check) {
                
                print("check fail in changePassword")
                completion(nil)
                return
            }
        
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        //let Keychain = KeychainSwift()
        var idSession = ""
    
       // if let data = Keychain.get("Profile"){
        
          let session = OAuthManager.shared.profile!//SessionsModel(JSONString: data)!
            
            idSession = session.id
        
       // }
        
        let endpoint = String(format: AppSettings.API_SESSION_CHANGE_PASSWORD , host,idSession)
        let Networking = ApiRest<emptyModel>()
        let headers = ["Content-Type":"application/json"]
        
        
            Networking.put(withAuthorization:true , url: endpoint, withParams: param.toJSON(), headers: headers) { (Response) in
            
            switch Response {
                
            case .Success:
                
                
             completion(true as AnyObject)
                
                
          
                
            case .BadRequest(let ErrorData):
                
                let msg = ErrorData
                print(msg)
                completion(msg as AnyObject?)
                
                    
            /*
                case .NotAuthorized:
                    
                    if(refreshed){
                        completion(nil)
                    }else{
                        
                        // refresh token and try Again
                        
                        refresh(completion: { (re) in
                            print("refrescando token")
                            if re{
                                //refresh success try again with refreshed true
                                
                                changePassword(refreshed: true,param: param, completion: { (response) in
                                    
                                    completion(response)
                                    
                                })
                                
                            }else{
                                // refresh fail
                                completion(nil)
                            }
                        })
                    }
                    
                    */
                    
            
            default:
                print("Fail change password")
                completion(nil)
                
            }
    
        }
        
    }
        
   }
    
}
