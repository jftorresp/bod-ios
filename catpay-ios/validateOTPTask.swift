//
//  validateOTPTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 7/17/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation



extension Task{


    static func validateOTPTask(otpCode:String,numberPhone:String, completion:@escaping(AnyObject?)->Void){
        
    
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format: AppSettings.API_SMS_BY_PHONE_NUMBER, host, numberPhone)
        let deviceId = DeviceModel().deviceId
        let clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String

        let headers = ["Content-Type":"application/json","otp":otpCode,"deviceId":deviceId,"client_id":clientId]
        let networking = ApiRest<emptyModel>()
        
        networking.create(url: endpoint, parameters: nil , headers: headers) { (Response) in
        
            switch Response{
            
            case .Success:
                completion(true as AnyObject?)
            
       
            case .BadRequest:
                
                completion(nil)
            
            
                default:
                completion(nil)
            
            }
            
            }
    
    }
}
