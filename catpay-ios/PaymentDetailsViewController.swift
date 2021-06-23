//
//  PaymentDetailsViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/23/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class PaymentDetailsViewController: UIViewController {

    var details: PaymentHistoryModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentDetails" ])
        
        var phoneNumber = ""
        let dataSession = OAuthManager.shared.profile!
        phoneNumber = dataSession.phoneNumber
        
        if phoneNumber == details?.payer?.phoneNumber{
        // pago Enviado
            self.navigationItem.title = NSLocalizedString("notification.sentDetailsPaymet", comment: "Detalle de pago enviado")
        }else{
            // Pago recibido
            self.navigationItem.title = NSLocalizedString("notification.receivedDetailsPaymet", comment: "Detalle de pago recibido")
        }
        
        
        // Do any additional setup after loading the view.
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueDetailsTable" {
            // Setup new view controller
            let destination = segue.destination as! PaymentDetailsTableViewController
            destination.details = details
         
        }
    }
    
}
