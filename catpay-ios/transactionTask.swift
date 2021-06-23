//
//  transactionTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/30/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Crashlytics

extension Task{


    static func transactionTask(refreshed:Bool , params:TransacctionModel, completion:@escaping(AnyObject?)->Void){
    
    
            let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_PAYMENT)
            let parameters = params.toJSON()
            let networking = ApiRest<PaymentHistoryModel>()
            let headers = ["Content-Type":"application/json"]
            let currency = AppSettings.Configuration(main: Bundle.main)["CurrencySymbol"] as! String
        
        //Fabric
        
        Answers.logStartCheckout(withPrice: params.amount as? NSDecimalNumber,currency: currency,itemCount: 1,customAttributes: [:])
        
            networking.create(withAuthorization: true , url: endpoint, parameters: parameters, headers: headers, callback: { (Response) in
                
                switch Response{
                
                case .Success(let data):
                    
                    let responseObject = data as! PaymentHistoryModel
                    if responseObject.succeeded {
                        print("saing new balance \(responseObject.balance) and status \(responseObject.status)")
                        AppDelegate.balance = responseObject.balance
                        AppDelegate.status = responseObject.status
                    }
                    completion(data as AnyObject)
                    //Fabric
                    Answers.logCustomEvent(withName: "Payment Sent", customAttributes: ["Amount" : params.amount, "currency": currency])
                    
                    print("success transsactionData")
                
                case .BadRequest (let error):
                    
                    print("badRequest transsaction")
                    completion(error as AnyObject?)
                
                case .Forbidden(_): //When is 'inactive cliente' - the parameter comes empty, for that reason I send a string "Forbidden"
                    let error: String = "Forbidden" //
                    print("ForbiddenRequest transsaction")
                    completion(error as AnyObject?)
                
                default:
                    print("default transsaction")
                    completion(nil)
                    
                }
                
            })
            
            
        }
    }
