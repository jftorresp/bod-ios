//
//  authenticateDeviceTask.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 9/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation

extension Task{


    static func authenticateDeviceTask(link:String, completion: @escaping(Bool) -> Void){
        
        
        let networking = ApiRest<emptyModel>()
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        
        let endpoint = host + "/" + link
        let headers = ["Content-Type":"application/json"]
        
        networking.get(url: endpoint, headers: headers ) { (_) in
            
        }

    
    }
    


}
