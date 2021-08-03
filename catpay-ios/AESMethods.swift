//
//  AESMethods.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 7/6/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import CryptoSwift

class AESMethods{

    static func encrypt(data:String)->String?{
        let key = AppSettings.Configuration(main: Bundle.main)["Key"] as! String
        let iv = AppSettings.Configuration(main: Bundle.main)["IV"] as! String
        let keyBytes: Array<UInt8> = Array(key.utf8)
        let ivBytes: Array<UInt8> = Array(iv.utf8)
        do {
            let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7) // aes128
            let ciphertext = try aes.encrypt(Array(data.utf8))
            return ciphertext.toBase64()
        } catch {
            print(error)
        }
        return nil
    }
    
    static func decrypt(message:String)->String?{
        
        let formatMesage  = message.replacingOccurrences(of: "\n", with: "")
        let key = AppSettings.Configuration(main: Bundle.main)["Key"] as! String
        let iv = AppSettings.Configuration(main: Bundle.main)["IV"] as! String
        let keyBytes: Array<UInt8> = Array(key.utf8)
        let ivBytes: Array<UInt8> = Array(iv.utf8)
        do {
            let decoded = Data(base64Encoded: formatMesage)
            let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7) // aes128
            
            guard let decodeBytes = decoded?.bytes else{
                return nil
            }
            
            let descryptText = try aes.decrypt(decodeBytes).toBase64()
            let decodedData = Data(base64Encoded: descryptText)
            let result = String(data: decodedData!, encoding: String.Encoding.utf8)
            
            return result
        } catch {
            print(error)
        }
        
        return nil
    }
    
}
