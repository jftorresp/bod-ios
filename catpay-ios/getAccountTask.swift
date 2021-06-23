//
//  getAccountTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/27/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


extension Task {


    public static func getAccountTask(refreshed:Bool, phoneNumber:String, completion:@escaping(AnyObject?)->Void){
    
        
            let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
            let endpoint = String(format: AppSettings.API_ACCOUNT,host,phoneNumber)
            let headers = ["Content-Type":"application/json"]
            
            let networking = ApiRest<AccountInfoModel>()
            
            networking.get(withAuthorization:true,url: endpoint, headers: headers){(Response) in
                
                switch Response {
                    
                case .Success(let result):
                    
                    let accountInfo = result as! AccountInfoModel
                    completion(accountInfo as AnyObject?)
             
                    case .BadRequest(let data):
                        
                        print("badRequest getAccount")
                        completion(data as AnyObject?)
                    
                    case .NotFound(let FailError):
                       
                        print("notFound getAccount")
                        
                        completion(FailError as AnyObject? )
                        
                
                    
                default:
                    print("default case networking getAccount")
                    completion(nil)
                }
                
            }
        
        
        }

}
