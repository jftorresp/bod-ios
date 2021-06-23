//
//  getDirectoryTask.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 5/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation

extension Task {

    static func getDirectory(refreshed: Bool, page: Int, pageSize: Int, completion:@escaping(AnyObject?)->Void) {
    
     
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format:AppSettings.API_DIRECTORY, host) + "?page=" + String(page) + "&pageSize=" + String(pageSize)
        let networking = ApiRest<directoryModel>()
        let headers = ["Content-Type":"application/json"]
        
            networking.getArray(withAuthorization:true , url: endpoint, headers: headers) { (Response) in
            
            switch Response {
            
            case .Success(let data):
                
                print("getDirectory success")
                completion(data as AnyObject?)
           
            case .BadRequest:
                
                print("badRequest getDirectory")
                completion(nil)
            
            default:
                print("default getDirectory")
                completion(nil)
            
            }
        }
    }
}
