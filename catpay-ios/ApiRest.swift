
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/9/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ApiRest <T : BaseMappable>: ApiRestProtocol {
    
    let SessionOauthManager = OAuthManager.shared
    
    func get(withAuthorization authorization:Bool = false , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType) ->  Void)  {
      
        
        let sessionManager = Alamofire.SessionManager.default
        let endpoint = URL(string: url)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 10
        
        // if required autorization //
        
        if authorization {
            
            sessionManager.retrier = SessionOauthManager
            sessionManager.adapter = SessionOauthManager
        }
    
        
        // Envio http request usando alamofire
        Alamofire.request(request).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            // Obtengo el estado de request
            
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003 {
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode
                
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
    }
    
    func getArray(withAuthorization authorization:Bool = false , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType) ->  Void)  {
        
        
        let endpoint = URL(string: url)!

        Alamofire.request(endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().debugLog().responseArray { (response: DataResponse<[T]>) -> Void in
        // Envio http request usando alamofire

            // Obtengo el estado de request
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003 {
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                callback(self.handlerStatus(status: status, response: response))
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
    }
    
    func create(withAuthorization authorization:Bool = false , url: String, parameters: [String : Any]?, headers: [String : String]? ,callback: @escaping (ECallbackResultType) -> Void){
        
        
        // if required autorization //
        
//        if authorization{
//            
//            Alamofire.SessionManager.default.retrier = SessionOauthManager
//            Alamofire.SessionManager.default.adapter = SessionOauthManager
//            
//        }
        
        Alamofire.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default ,  headers:headers).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            
            // Obtengo el estado de request
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003{
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
        
        
    }
    
    
    func put(withAuthorization authorization:Bool = false , url: String, withParams parameters: [String: Any]?, headers: [String : String]?, callback: @escaping (ECallbackResultType) -> Void) {
        
        
        let sessionManager = Alamofire.SessionManager.default
        
        
        // if required authorization //
        
        if authorization{
            
            sessionManager.retrier = SessionOauthManager
            sessionManager.adapter = SessionOauthManager
            
        }
                        
        Alamofire.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default ,  headers:headers).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            
            // Obtengo el estado de request
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003{
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
        
        
    }
    
    func putArray(withAuthorization authorization:Bool = false , url: String, withParams parameters: [String], headers: [String : String]?, callback: @escaping (ECallbackResultType) -> Void) {
        
        
        let sessionManager = Alamofire.SessionManager.default
        
        
        // if required authorization //
        
        if authorization{
            
            sessionManager.retrier = SessionOauthManager
            sessionManager.adapter = SessionOauthManager
            
        }
        
        let endpoint = URL(string: url)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                        
        Alamofire.request(request).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            // Obtengo el estado de request
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003{
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
        
        
    }
    
    func patch(withAuthorization authorization:Bool = false , url: String, parameters: [String : Any]?, headers: [String : String]? ,callback: @escaping (ECallbackResultType) -> Void) {
        
        
        let sessionManager = Alamofire.SessionManager.default
        
        
        // if required authorization //
        
        if authorization{
            
            sessionManager.retrier = SessionOauthManager
            sessionManager.adapter = SessionOauthManager
            
        }
        
        Alamofire.request(url,method: .patch, parameters: parameters, encoding: JSONEncoding.default ,  headers:headers).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            // Obtengo el estado de request
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003{
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
    }
    
    func delete(withAuthorization authorization:Bool = false , url: String, headers: [String : String]?, callback: @escaping (ECallbackResultType) ->  Void)  {
      
        
        let sessionManager = Alamofire.SessionManager.default
        
        // if required autorization //
        
        if authorization{
            
            sessionManager.retrier = SessionOauthManager
            sessionManager.adapter = SessionOauthManager
            
        }
                
        // Envio http request usando alamofire
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: headers).validate().debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            // Obtengo el estado de request
            
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003 {
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode
                
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
    }
    
    
    
    func connect(withAuthorization authorization:Bool = false , url: String, parameters: [String : Any]?, headers: [String : String]? ,callback: @escaping (ECallbackResultType) -> Void){
        
        
        let sessionManager = Alamofire.SessionManager.default
        
        
        // if required autorization //
        
        
        if authorization{
            
            sessionManager.adapter = SessionOauthManager
            sessionManager.retrier = SessionOauthManager
            
        }
        
        
        Alamofire.request(url,method: .post, parameters: parameters, headers:headers).debugLog().responseObject { (response: DataResponse<T>) -> Void in
            
            
            // check connection Internet //
            if response.result.isFailure {
                
                let code = response.result.error! as NSError
                
                if code.code == -1009 || code.code == -1001 || code.code == -1003{
                    
                    self.SessionOauthManager.handlerConnectionInternet()
                    callback(ECallbackResultType.NoInternetConnection)

                }
                
            }
            
            if (response.response != nil) {
                
                let status = response.response!.statusCode;
                callback(self.handlerStatus(status: status, response: response))
                
                
            } else {
                // Endpoint inexistente
                callback(ECallbackResultType.APIEndpointNotAvailable)
            }
        }
        
        
    }
    
    
    private func handlerStatus(status:Int , response: Any) -> ECallbackResultType {
        
        
        switch status {
            
        case 200..<300:
            
            // Success request case single object
            
            if let handlerResponse = response as? DataResponse<T>{
                
                if let value = handlerResponse.result.value {
                    
                    // Success Success with data
                    
                    return(ECallbackResultType.Success(value))
                    
                    
                }else{
                    
                    // Response Success without data
                    
                    return(ECallbackResultType.Success(true))
                    
                }
                
            }else{
                
                // Success request case collection object
                
                let handlerResponse = response as! DataResponse<[T]>
                
                if let value = handlerResponse.result.value {
                    
                    // Success Success with data
                    
                    return(ECallbackResultType.Success(value))
                    
                    
                }else{
                    
                    // Response Success without data
                    
                    return(ECallbackResultType.Success(true))
                    
                }
            }
            
        case 300..<501:
            
            var body: String!
            
            if let handlerResponse = response as? DataResponse<T>{
                
                // case single Object
                
                body = String(data:handlerResponse.data!,encoding:String.Encoding.utf8)
                
                
            }else{
                
                let handlerResponse = response as! DataResponse<[T]>
                body = String(data:handlerResponse.data!,encoding:String.Encoding.utf8)
                
            }
            
            var error : ECallbackResultType?
            
            // DEFINIMOS EL TIPO DE ERROR SEGUN SEA EL CODIGO HTTP //
            
            switch status{
                
            case 400:
                error = ECallbackResultType.BadRequest(body!)
                
            case 401:
                print("aca en 401")
                error = ECallbackResultType.NotAuthorized(body!)
                
            case 403:
                print("aca en 403")
                error = ECallbackResultType.Forbidden(body!)
                
            case 404:
                print("aca en 404")
                error = ECallbackResultType.NotFound(body!)
                
            case 409:
                print("aca en 409")
                error = ECallbackResultType.NotAuthorized(body!)
                
            case 500:
                print("aca en 500")
                error = ECallbackResultType.InternalServerError(body!)
                
            default:
                print(body!)
                error = ECallbackResultType.UnknownError
            }
            
            
            return error!
            
            
        default:
            
            
            return (ECallbackResultType.UnknownError)
        }
    }
}


