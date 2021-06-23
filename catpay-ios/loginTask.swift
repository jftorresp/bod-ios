//
//  loginTask.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/21/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift
import Crashlytics

extension Task{

static func Login(parameters:LoginRequestModel,completion:@escaping(AnyObject?)->Void){
    
            let networkingLogin = ApiRest<TokensModel>()
            let header = UtilityMethods.getHeadersLogin()
            let endpoint = AppSettings.GetEnpoint(endpoint: AppSettings.API_OAUTH_TOKEN)
            let sendingData = parameters.toJSON()
            
            networkingLogin.connect(url: endpoint, parameters:sendingData ,headers: header) { (ECallbackResultType) in
                
                switch ECallbackResultType {
                    
                case .Success(let data):
                    let session = data as! TokensModel
                    
                    OAuthManager.shared.setSession(session: session)
                    
                    AppDelegate.balance = session.balance
                    AppDelegate.status = session.status
                    
                    // get profile after success login
                    Task.profile(refreshed: false) { (Response) in
                        
                        if Response != nil{
                            let data = Response as! SessionsModel
                            
                            // save in keychain data profile
                            
                            OAuthManager.shared.setProfile(profile: data)
                            
                            // register push notification
                            
                            Task.registerDeviceTask(completion: { (_) in})
                            
                            //Fabric
                            Answers.logLogin(withMethod: "Digits",success: true,customAttributes: nil)
                            
                            //callback
                            completion(session)
                        }else{
                        
                            OAuthManager.shared.handlerConnectionInternet()
                            completion(nil)
                        
                        }
                    }
                    
    
                case .BadRequest(let ErrorData):
                    
                    let msg = ErrorData
                    print(msg)
                    completion(msg as AnyObject?)
                    
                case .NotAuthorized(let ErrorData):
                    
                    let msg = ErrorData
                    OAuthManager.shared.handlerUserNotAffiliated(message: msg)
                    completion(msg as AnyObject?)
                    
                    
                case .Forbidden(let ErrorData):
                    
                    print(ErrorData)
                    completion(ErrorData as AnyObject?)
                    
                default:
                    
                    OAuthManager.shared.handlerServiceInactive()
                    completion(nil)
                }
            }
    }
}
