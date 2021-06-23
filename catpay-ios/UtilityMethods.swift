//
//  UtilityMethods.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import SystemConfiguration


class UtilityMethods {

    // convert String json to dictionary //
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // create simplify alertView //
    
    static func createAlert(title:String, message:[String]) -> UIAlertController{
        
        var msgData = ""
        
        for msg in message{
            msgData += msg+"\n"
        }
        
        let alert = UIAlertController(title:title, message:msgData, preferredStyle:.alert)
        
        // cerrando notificacion
        alert.addAction(UIAlertAction(title:"OK",style:.cancel))
        return alert
    }
    
    // create simplify createExitView //
    
    static func createExitAlert(title:String, message:[String]) -> UIAlertController{
        
        var msgData = ""
        
        for msg in message{
            
            msgData += msg+"\n"
        }
        
        let alert = UIAlertController(title:title, message:msgData, preferredStyle:UIAlertControllerStyle.alert)
        
        
        // cerrando notificacion
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:{(action) in
            
           let myDelegate = UIApplication.shared.delegate as! AppDelegate
           myDelegate.setRootInitialView()
           OAuthManager.shared.connectionLost = false
            
        }))
        
        return alert
    }
    
    // get headers login function //
    
    static func getHeadersLogin() -> [String:String]?{
        

        let DeviceInfo = DeviceModel()
        
        let deviceInfo  = DeviceInfo.toJSON() as! [String:String]
        let clientId = AppSettings.Configuration(main: Bundle.main)["ClientId"] as! String
        let headers = deviceInfo + ["client_id":clientId, "Content-Type" : "application/x-www-form-urlencoded"]
        return headers
    
    }
    
   
    
    // handler date iso 8601 //
    
    static func format_date (fecha : String) ->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "es_VE")
        
        guard let dt = dateFormatter.date(from: fecha) else{
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            guard let dt = dateFormatter.date(from: fecha) else{
                
                // parche para error en la fecha //
                
                dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
                
                guard let dt = dateFormatter.date(from: fecha) else{
                    // default case //
                    return ""
                }
                
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd/M/yyyy h:mm a"
                return dateFormatter.string(from: dt)
            
            }
            
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat =  "dd/M/yyyy h:mm a"
            return dateFormatter.string(from: dt)
        }
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "dd/M/yyyy h:mm a"
        
        return dateFormatter.string(from: dt)
        
        
    }
    
    // backround color of application //
    
    static func getBackgroundColor() ->UIColor{
        
        return UIColor(red:0.40, green:0.71, blue:0.33, alpha:1.0)
    
    }
    
    // format mount in default format //
    
    static func formatCurency(number:Double) -> String{
        
     
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencyDecimalSeparator = ","
        formatter.currencyGroupingSeparator = "."
        formatter.maximumIntegerDigits = AppSettings.Configuration(main: Bundle.main)["MaxAmountLength"] as! Int
        formatter.currencySymbol = AppSettings.Configuration(main: Bundle.main)["CurrencySymbol"] as! String
        let result = formatter.string(from: number as NSNumber)
        return result!

    }
    
    // get double of format mount //
    
    static func getDoubletoFormatCurrency(string :String) ->Double?{
        
        let formatter = NumberFormatter()
        let maxAmountLength = AppSettings.Configuration(main: Bundle.main)["MaxAmountLength"] as! Int
        
        let currencySymbol = AppSettings.Configuration(main: Bundle.main)["CurrencySymbol"] as! String
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.maximumIntegerDigits = maxAmountLength
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencyDecimalSeparator = ","
        var newString = string.replacingOccurrences(of: ",", with: "")
        newString = newString.replacingOccurrences(of: currencySymbol, with: "")
        newString = newString.replacingOccurrences(of: ".", with: "")
        
        // valid digit
        if newString.count > maxAmountLength{
            return nil
        }
        
        
        newString.insert(",", at: newString.index(newString.endIndex, offsetBy: -2))
        newString = currencySymbol + newString
        
        formatter.currencySymbol = currencySymbol
        return formatter.number(from: newString) as? Double
        
        
    
    }
    
    // create QR //
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    // get top UIViewController //
    
    static func getTopViewController() -> UIViewController?{
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            
            return topController
        }
        return nil
    
    }
    
    
    // open modal animate //
    
    static func openModal(view: UIView){
        
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.25) {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view.alpha = 1
            
        }
        
        
    }
    
    // close modal animate //
    
    static func closeModal(view:UIView){
        
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            view.alpha = 0
            
            
        }) { (_) in
            
            view.removeFromSuperview()
        }
        
    }
 

}

// connection function utilities //

func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    if !(isReachable && !needsConnection){
        
        //notification no hay internet
        // session expirada
        let msg = NSLocalizedString("notification.no_internet_connection", comment: " ")
        let title = NSLocalizedString("notification.titleInvalid", comment: " ")
        let alert = UtilityMethods.createAlert(title: title , message:[msg])
        
        let vc = UtilityMethods.getTopViewController()
        
        vc?.present(alert, animated: true, completion:nil)
        
    }
    
    
    return (isReachable && !needsConnection)
}



