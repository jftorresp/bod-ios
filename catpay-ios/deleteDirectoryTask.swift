//
//  deleteDirectoryTask.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 6/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation

extension Task {
    
    public static func deleteDirectory(directoryId: String, completion:@escaping(AnyObject?)->Void) {
        
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format: AppSettings.API_DIRECTORY_BY_ID, host, directoryId)
        let headers = ["Content-Type":"application/json"]
        
        let networking = ApiRest<directoryModel>()
        
        networking.delete(withAuthorization: true, url: endpoint, headers: headers) { (response) in
            
            switch response {
                
                case .Success:
                
                    completion(true as AnyObject?)
                
                    print("succes deleteDirectory")
                
                case .BadRequest(let data):
                    
                    print("badRequest deleteDirectory")
                    completion(data as AnyObject?)
                
                case .NotFound(let FailError):
                   
                    print("notFound deleteDirectory")
                    
                    completion(FailError as AnyObject? )
                
                default:
                    print("default case networking deleteDirectory")
                    completion(nil)
            }
        }
    }
}
