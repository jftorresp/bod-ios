//
//  registerTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift
import Crashlytics

extension Task{


    static func register(parameters:RegisterModel,completion:@escaping(AnyObject?)->Void){
        
        Check { (status_check) in
            
            
            if(!status_check){
                
                print("check fail in register")
                completion(nil)
                return
            }
            
            let networkingRegister = ApiRest<SessionsModel>()
            let clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
            let header = ["Content-Type":"application/json","client_id":clientId]
            let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_SESSION)
            let sendingData = parameters.toJSON()
            
            // enviamos post con formulario registro
            networkingRegister.create(url: endpoint, parameters:sendingData ,headers: header, callback: { (response) in
                
                switch response{
                    
                case .Success(let data):
                    
                    print("success")
                    
                    //Fabric
                    Answers.logSignUp(withMethod: "Digits",success: true,customAttributes: nil)
                    
                    //completion(nil)
                    completion(data as! SessionsModel?)
                    
                
                        
                    case .BadRequest(let ErrorData):
                        
                        let msg = ErrorData
                        print(msg)
                        //   print(ErrorData["error_description"] as! String)
                        completion(msg as AnyObject?)
                        
                  
                    
                default:
                    
                    print("default case register")
                    completion(nil)
                    
                }})}
        
        }
    
}
