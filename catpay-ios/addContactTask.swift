//
//  addContactTask.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 5/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import Foundation
import Alamofire

extension Task {
    
    static func addContact(parameters: directoryModel, completion:@escaping(AnyObject?)->Void) {

        let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_DIRECTORY)
        let networking = ApiRest<directoryModel>()
        let headers = ["Content-Type":"application/json"]
        let sendingData = parameters.toJSON()
        
        networking.create(url: endpoint, parameters: sendingData, headers: headers) { (response) in
            
            switch response {
                
            case .Success(let data):
                
                print("Success adding contact")
                                
                //completion(nil)
                completion(data as! directoryModel?)
                
            case .BadRequest(let ErrorData):
                    
                let msg = ErrorData
                print(msg)
                //   print(ErrorData["error_description"] as! String)
                completion(msg as AnyObject?)
                
            case .NotFound(let FailError):
               
                let msg = FailError
                print(msg)
                
                completion(msg as AnyObject? )
                
            default:
                
                print("default case add contact")
                completion(nil)
                
            }}
        }
}
