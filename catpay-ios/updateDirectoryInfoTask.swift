//
//  updateDirectoryInfoTask.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 6/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation

extension Task {
    
    public static func updateDirectory(refreshed: Bool, directoryId: String, params: directoryModel, completion:@escaping(AnyObject?)->Void) {
        
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format: AppSettings.API_DIRECTORY_BY_ID, host, directoryId)
        let headers = ["Content-Type":"application/json"]
        
        let networking = ApiRest<directoryModel>()
        
        networking.patch(withAuthorization: true, url: endpoint, parameters: params.toJSON(), headers: headers) { (response) in
            
            switch response {
                
            case .Success:
        
             completion(true as AnyObject)
                print("Success updating contact info")
                
            case .BadRequest(let ErrorData):
                
                let msg = ErrorData
                print(msg)
                completion(msg as AnyObject?)
            default:
                print("Fail updating contact info")
                completion(nil)
                
            }
        }
        
    }
}
