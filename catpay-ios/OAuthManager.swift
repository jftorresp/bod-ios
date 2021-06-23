//
//  OAuthManager.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 9/6/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import KeychainSwift

class OAuthManager {
    
    
    // atributtes //
    
    internal typealias RefreshCompletion = (_ succeeded: Bool, _ TokensObject: TokensModel?) -> Void
    
    internal let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    internal let lock = NSLock()
    internal var clientID: String = ""
    internal var baseURLString: String = ""
    internal var accessToken: String = ""
    internal var refreshToken: String = ""
    internal var profile: SessionsModel!
    internal var isRefreshing = false
    internal let keySession = "Session2"
    internal let keyProfile = "Profile2"
    internal var sessionAlive: Bool = false
    internal var connectionLost: Bool = false
    //internal var balance:Double = 0.0
    //internal var status = ""
    internal var requestsToRetry: [RequestRetryCompletion] = []
    
    
    // implement singleton // -- // MARK: Shared Instance
    
    static public let shared = OAuthManager()
    
    private init() {
        
        let keyChain = KeychainSwift()
        
        if let data = keyChain.get(keySession){
            
            let session =  TokensModel(JSONString: data)
            self.refreshToken = (session?.refresh_token)!
            self.accessToken = (session?.access_token)!
        }
        
        self.clientID = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
        self.baseURLString = AppSettings.Configuration(main: Bundle.main)["ServiceBaseUrl"] as! String

    }
    
    
    // get headers with autorization  //
    
    public func getHeadersAutorization() -> [String:String]?{
        
       // let keyChain = KeychainSwift()
        var  authorization = "Bearer "
        
        
       // if let data = keyChain.get(keySession){
        //    let session =  TokensModel(JSONString: data)
            authorization += self.accessToken//(session?.access_token)!//self.accessToken//(session?.access_token)!
       // }
        
        return ["Content-Type":"application/json","Authorization":authorization]
        
    }
    
    // set Session //
    
    public func setSession(session:TokensModel){
        
        let keychain = KeychainSwift()
        keychain.set((session.toJSONString()!), forKey: self.keySession)
        self.accessToken = session.access_token
        self.refreshToken = session.refresh_token
        //self.balance = session.balance
        //self.status = session.status
        self.sessionAlive = true
        
        //AppDelegate.balance = session.balance
        //AppDelegate.status = session.status
    }
    
    public func setProfile(profile:SessionsModel){
        let keychain = KeychainSwift()
        keychain.set((profile.toJSONString()!), forKey: self.keyProfile)
        self.profile = profile
        self.sessionAlive = true
    }
    
    public func closeSession(){
        print("Closing Session....")
        let keychain = KeychainSwift()

        keychain.clear()
        self.accessToken  = ""
        self.refreshToken = ""
        
        let sessionManager =  Alamofire.SessionManager.default
        sessionManager.adapter = nil
        sessionManager.retrier = nil
        
        self.sessionAlive = false
        
        //AppDelegate.balance = 0
        //AppDelegate.status = ""
    }
    
}



//MARK: Protocol implementation //


extension  OAuthManager: RequestRetrier, RequestAdapter , expiredSessionProtocol, lostConnectionProtocol{
    
    
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(self.baseURLString) {
            
            let headers = self.getHeadersAutorization()
            var urlRequest = urlRequest
            urlRequest.setValue(headers?["Authorization"], forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, TokensObject in
                    guard let strongSelf = self else { return }
                    
                    
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if succeeded{
                        
                        // refresh success //
                        
                        if let TokensObject = TokensObject {
                            
                            strongSelf.setSession(session: TokensObject)
                            
                        }
                        
                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                        strongSelf.requestsToRetry.removeAll()
                        
                    }else{
                        
                        let vc = UtilityMethods.getTopViewController()!
                        
                        // refresh fail //
                        if strongSelf.sessionAlive{
                            // expired session
                            strongSelf.handlerExpiredSession(presentView: vc)
                            strongSelf.closeSession()
                        }else{
                            // problem connection
                            
                            strongSelf.handlerConnectionInternet()
                            
                        }
                    }
                    
                }
            }
            
            
        } else {
            
            // dont need refresh
            
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
    
        let urlString = AppSettings.GetEnpoint(endpoint: AppSettings.API_OAUTH_TOKEN)
        
        let parameters = RefreshModel().toJSON()
        let headers = UtilityMethods.getHeadersLogin()
    
        Alamofire.request(urlString, method: .post, parameters: parameters, headers:headers).debugLog()
            .responseObject { (response: DataResponse<TokensModel>) -> Void in
                
                if response.result.isFailure {
                    
                    let code = response.result.error! as NSError
                    
                    if code.code == -1009 || code.code == -1001 || code.code == -1003{
                        
                        self.handlerConnectionInternet()
                        completion(false, nil)
                        return
                        
                    }
                }
                if let status = response.response?.statusCode {
                    switch status {
                        
                    case 200..<300:
                        
                        // Success request
                        let tokens = response.result.value!
                        self.isRefreshing = false
                        completion(true, tokens)
                        
                    default:
                        completion(false, nil)
                        
                    }
                }
        }
        
    }
    
    
    // MARK -- implement handler for expired Sessions //
    
    func handlerExpiredSession (presentView : UIViewController){
        
        let msg = NSLocalizedString("notification.session_expired_message", comment: "")
        let title = NSLocalizedString("notification.session_expired", comment: " ")
        let alert = UtilityMethods.createExitAlert(title: title , message:[msg])
        presentView.present(alert, animated:true,completion:nil)
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK -- implement handler for lost connection  //
    
    func handlerConnectionInternet () {
        
 //       lock.lock() ; defer { lock.unlock() }

        
        if self.sessionAlive{
            
            self.closeSession()
        }
        
        if self.connectionLost{
        
            return
        }
        
        self.connectionLost = true

        let title = NSLocalizedString("notification.titleInvalid", comment: "")
        // lost connction //

        let msg = NSLocalizedString("notification.server_in_maintenance", comment: " ")
        let alert = UtilityMethods.createExitAlert(title: title , message:[msg])
        let vc = UtilityMethods.getTopViewController()
        UIApplication.shared.endIgnoringInteractionEvents()
        vc?.present(alert, animated:true,completion: {
            self.connectionLost = false
        })
        
    }
    
    func handlerServiceInactive () {
        let title = NSLocalizedString("notification.titleInvalid", comment: " ")
        let msg = NSLocalizedString("notification.server_inactive", comment: "")
        let alert = UtilityMethods.createExitAlert(title: title , message:[msg])
        let vc = UtilityMethods.getTopViewController()
        vc?.present(alert, animated:true,completion:nil)
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func handlerUserNotAffiliated(message: String) {
        let dataJ = Data(message.utf8)
        var mensaje = ""
        
        do {
            if let json = try JSONSerialization.jsonObject(with: dataJ, options : .allowFragments) as? Dictionary<String,Any>
            {
                mensaje = json["error_description"] as! String
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        let title = NSLocalizedString("notification.titleInvalid", comment: " ")
        let msg = NSLocalizedString(mensaje, comment: "")
        let alert = UtilityMethods.createExitAlert(title: title , message:[msg])
        let vc = UtilityMethods.getTopViewController()
        vc?.present(alert, animated:true,completion:nil)
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
