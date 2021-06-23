//
//  updateDirectoryTask.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 6/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation

extension Task {
    
    public static func updateDirectoryPhones(refreshed: Bool, directoryId: String, phoneNumbers: [String], completion:@escaping(AnyObject?)->Void) {
        
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format: AppSettings.API_DIRECTORY_BY_ID, host, directoryId)
        let headers = ["Content-Type":"application/json"]
    
        let networking = ApiRest<directoryModel>()
    
        networking.putArray(withAuthorization: true, url: endpoint, withParams: phoneNumbers,  headers: headers) { (response) in
            
            switch response {
                
            case .Success:
        
             completion(true as AnyObject)
                print("Success updating contact phones")
                
            case .BadRequest(let ErrorData):
                
                let msg = ErrorData
                print(msg)
                completion(msg as AnyObject?)
            default:
                print("Fail updating contact phones")
                completion(nil)
                
            }
        }
        
    }
}
