//
//  recoveryPasswordTask.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation



extension Task {


    static func recoveryPassword (param: RecoveryPasswordModel, completion:@escaping(AnyObject?)->Void){
        
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format:AppSettings.API_SESSION_FORGOT_PASSWORD_BY_EMAIL,host, param.emailAddress)
    
        let params = param.toJSON()
        let headers = ["Content-Type":"application/json"]
    
        
        let networking = ApiRest<emptyModel>()
        
        networking.create(url: endpoint, parameters: params, headers: headers) { (Response) in
           
            switch Response {
                
            case .Success:
            
                completion(true as AnyObject)
            
 
            case .BadRequest(let badRequest):
                
                completion(badRequest as AnyObject)
                
      
            default:
                
                completion(nil)
                
            
            }
        }
    
    }}
