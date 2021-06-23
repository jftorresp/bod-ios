//
//  registerDeviceTask.swift
//  catpay-ios
//
//  Created by IOS Developer on 11/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation

extension Task{
    
    
    static func registerDeviceTask( completion: @escaping(Bool) -> Void){
        
        
        let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_DEVICE)
        let headers = ["Content-Type":"application/json"]
        let params = deviceRequestModel().toJSON()
        let networking = ApiRest<emptyModel>()
        
        networking.create(withAuthorization:true,url: endpoint,parameters:params, headers: headers ) { (response) in
            
            switch response{
            
            case .Success:
                
                completion(true)
                
            default:
                
                completion(false)
                
            
                
            }}
        
    }
}
