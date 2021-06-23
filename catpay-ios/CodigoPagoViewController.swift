//
//  CodigoPagoViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/16/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import  Crashlytics
class CodigoPagoViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var QRImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set Data
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentCode" ])
        let dataSession = OAuthManager.shared.profile!
        self.phoneNumber.text = dataSession.phoneNumber
        let data = AESMethods.encrypt(data: dataSession.toJSONString()!)
        guard let image = UtilityMethods.generateQRCode(from:data!) else{return}
        QRImage.image = image
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
        self.navigationItem.title = "Mi Cuenta"
    }

    @objc func navigation() {
        self.navigationController?.popViewController(animated: true)
    }

}
