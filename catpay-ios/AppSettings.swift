//
//  AppSettings.swift
//  catpay-ios
//
//  Created by Francisco Vasquez on 6/7/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation

class AppSettings {
    
    // RUTAS DE API
    
    // Application
    static let API_APPLICATION_CHECK = "%@/api/Application";
    
    // Account
    static let API_ACCOUNT = "%@/api/Account/%@";
    
    // Bank Account
    static let API_BANK_ACCOUNTS = "%@/api/BankAccount";
    
    // Device
    static let API_DEVICE = "%@/api/Device";
    
    // Payment
    static let API_PAYMENT_PAGED = "%@/api/Payment?page=%d&pageSize=%d";
    static let API_PAYMENT = "%@/api/Payment";
    
    // Sms
    static let API_SMS_BY_PHONE_NUMBER = "%@/api/Sms/%@";
    static let API_SMS = "%@/api/Sms";
    
    // OAuth
    static let API_OAUTH_REVOKE = "%@/api/Oauth/Revoke";
    
    // Connect
    static let API_OAUTH_TOKEN = "%@/api/Connect/Token";
    
    // Session
    static let API_SESSION = "%@/api/Session";
    static let API_SESSION_PROFILE = "%@/api/Session/Profile";
    static let API_SESSION_UPDATE = "%@/api/Session/%@/Update";
    static let API_SESSION_CHANGE_PASSWORD = "%@/api/Session/%@/ChangePassword";
    static let API_SESSION_FORGOT_PASSWORD_BY_EMAIL = "%@/api/Session/ForgotPassword?emailAddress=%@";
    static let API_SESSION_FORGOT_PASSWORD = "%@/api/Session/ForgotPassword";
    
    // Directory
    static let API_DIRECTORY = "%@/api/Directory"
    static let API_DIRECTORY_BY_ID = "%@/api/Directory/%@"
    
    /*
     * Get Global Configuration from Main Bundle
     */
    static func Configuration(main:Bundle) -> Dictionary<String, Any> {
        
      
       var cfg : Dictionary<String, Any>?
        
        // DISABLE SANDBOX //

        // detect environment Running //
        
        var nameEnvironment : String!
        
        switch Config.appConfiguration {
            
        case .TestFlight:
            
            nameEnvironment = "Certification"
            
        case .AppStore:
            
            nameEnvironment = "production"
            
        default:
            
            // LOCAL ENVIRONMENT //

            if let appSettings = main.infoDictionary?["GlobalAppSettings"] as? Dictionary<String, Any>{
                cfg = appSettings
            }
            
            return cfg!
            
        }
        
        if let path = Bundle.main.path(forResource: nameEnvironment, ofType: "plist"){
        
            if let infoDictionary = NSDictionary(contentsOfFile: path){
                
                if let appSettings = infoDictionary["GlobalAppSettings"] as? Dictionary<String,Any>{
                
                    cfg = appSettings
                }
            
            }
        
        }
        
       return cfg!
    }
    
    // get Endpoint
    
    static func GetEnpoint(endpoint: String) -> String {
        
        let configuration = Configuration(main: Bundle.main)
        let host = configuration["ServiceBaseUrl"] as! String
        return String(format: endpoint, host)
    }
    
    // convert string Json to dictionary
}

