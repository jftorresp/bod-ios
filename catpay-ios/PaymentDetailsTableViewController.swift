//
//  PaymentDetailsTableViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/23/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class PaymentDetailsTableViewController: UITableViewController {

    @IBOutlet weak var TransactionID: UILabel!
    @IBOutlet weak var Acquiring: UILabel!
    @IBOutlet weak var BankAccount: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Wallet: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    var details: PaymentHistoryModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentDetailsTable" ])
        
        TransactionID.text = details?.operationId
        
        // Acquiring Mask Number //
        
        var maskNumber = (details?.recipient?.phoneNumber)!
        var start = maskNumber.index( (maskNumber.startIndex), offsetBy: 4)
        var end =  maskNumber.index( start, offsetBy: 3)
        maskNumber.replaceSubrange(start...end, with: "****")
        
        Acquiring.text = (details?.recipient?.name)! + "  (" + maskNumber + ")  "
        Amount.text = UtilityMethods.formatCurency(number: Double((details?.amount)!))
        Date.text = UtilityMethods.format_date(fecha: (details?.created)!)
        
        // Payer Mask Number //
        
        maskNumber = (details?.payer?.phoneNumber)!
        start = maskNumber.index( (maskNumber.startIndex), offsetBy: 4)
        end =  maskNumber.index( start, offsetBy: 3)
        maskNumber.replaceSubrange(start...end, with: "****")
        
        Wallet.text = (details?.payer?.name)! + "  (" + maskNumber + ")  "
        BankAccount.text = details?.nameBank
        Description.text = details?.description
        
        
        //estatus
        
        if (details?.succeeded)! {
        
             let status = NSLocalizedString("notification.approved", comment: " aprobado")
             Status.text = status
        
        }else{
        
            let status = NSLocalizedString("notification.rejected", comment: " rechazado")
            Status.text = status
            
        }
        
        //Color 
        var phoneNumber = ""
        
        let dataSession = OAuthManager.shared.profile!
        phoneNumber = dataSession.phoneNumber
        
            
        
        if phoneNumber == details?.payer?.phoneNumber{
            // Pago Enviado
            Amount.textColor = UIColor.red
            
            let mountSplit = Amount.text!.split(separator: ".")
            Amount.text = "\(mountSplit[0]). -\(mountSplit[1])"

            
        }else{
            
            // Pago recibido
            Amount.textColor = UtilityMethods.getBackgroundColor()
            Amount.text = " \(Amount.text!)"
            
        }

        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetails" {
            // Setup new view controller
            
            let aux = sender as! PaymentHistoryModel
            self.details = aux
            
        }
    }
    
    @IBAction func compartirPressed(_ sender: Any) {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
                
        var imagesToShare = [Any]()
        imagesToShare.append(image!)
        
        let activityController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
}
