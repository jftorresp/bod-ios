//
//  SendOTPCodeTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 7/17/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation



extension Task{


    static func SendOTPCodeTask(param: RegisterModel, completion:@escaping(AnyObject?)->Void){
    
        
            let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_SMS)
            let params = param.toJSON()
            let networking = ApiRest<RegisterModel>()
            let clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
            let headers = ["deviceId":(param.deviceInfo?.deviceId)!, "Content-Type":"application/json","client_id":clientId]
            
            
            networking.create(url: endpoint, parameters: params, headers: headers , callback: { (Response) in
                
                switch Response{
                
                case .Success:
                    
                    completion(param)
                
             
                case .BadRequest(let ErrorData):
                    
                    let msg = ErrorData
                    completion(msg as AnyObject?)
                    
                        
                  
                default:
                    
                    completion(nil)
            }})
        
        }
}
