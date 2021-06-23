//
//  getBankTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/27/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


extension  Task{



    static func getBankTask(completion:@escaping(AnyObject?) -> Void){
    
    
        
            let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_BANK_ACCOUNTS)
            let networking = ApiRest<banksModel>()
        
            networking.getArray(url: endpoint, headers: ["content-type":"application-json"]){(Response) in
            
            
                switch Response{
                
                case .Success(let result):
                    
                    let banks = result as! [banksModel]
                    completion(banks as AnyObject?)
                
                default:
                    print("default case networking getBanksTask")
                    completion(nil)
                }
            
            }
        
        }
    
    }
