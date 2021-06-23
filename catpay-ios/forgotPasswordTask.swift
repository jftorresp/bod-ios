//
//  forgotPasswordTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

extension Task{
    
    static func forgotPassword(email:String, completion:@escaping(Bool)->Void){
        
        Check { (status_check) in
            
            if(!status_check){
                
                print("check fail in forgotPassword")
                completion(false)
                return
            }
        
        let email = email.lowercased()
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format: AppSettings.API_SESSION_FORGOT_PASSWORD_BY_EMAIL, host, email)
        let headers = ["Content-Type":"application/json"]

        let networking = ApiRest<emptyModel>()
        
            networking.get(url: endpoint, headers : headers) { (response) in
            
            switch response{
                
                case .Success:
                    
                    completion(true)
                    
                default:
                    completion(false)
                    
                }
            
        }}
    }

}
