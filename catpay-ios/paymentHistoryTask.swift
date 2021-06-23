//
//  paymentHistoryTask.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation


extension Task{


    static func paymentHistory(refreshed:Bool,page:Int,pageSize:Int,completion:@escaping(AnyObject?)->Void) {
     
        let host = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String
        let endpoint = String(format:AppSettings.API_PAYMENT_PAGED,host,page,pageSize)
        let networking = ApiRest<PaymentHistoryModel>()
        let headers = ["Content-Type":"application/json"]
        
            networking.getArray(withAuthorization:true , url: endpoint, headers: headers) { (Response) in
            
            switch Response{
            
            case .Success(let data):
                
                print("paymentHistory success")
                completion(data as AnyObject?)
           
            case .BadRequest:
                
                print("badRequest HistoryPayment")
                completion(nil)
            
            default:
                print("default historyPayment")
                completion(nil)
            
            }
        }}
    }

