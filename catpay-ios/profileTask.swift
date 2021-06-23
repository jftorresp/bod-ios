//
//  profileTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift
extension Task{

    static func profile(refreshed:Bool,completion:@escaping(AnyObject?)->Void){
        
        Check { (status_check) in
            
            if(!status_check){
                
                print("check fail in profile")
                completion(nil)
                return
            }
        
        
        let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_SESSION_PROFILE)
        let networking = ApiRest<SessionsModel>()
         let headers = ["Content-Type":"application/json"]
        
            networking.get(withAuthorization:true , url: endpoint, headers: headers) { (Response) in
            
            switch Response {
                
            case .Success(let data):
                
                let session = data as! SessionsModel
                completion(session)
                
            default:
                print("fail get profile")
                completion(nil)
                
        }}}
  }
}
