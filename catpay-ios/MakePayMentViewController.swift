//
//  MakePayMentViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class MakePayMentViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var saldoDisponible: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"MakePayment" ])
    }
    
    private func setupView(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
        viewHeader.backgroundColor = UIColor.principalAppColor
        
        let backButton = UIBarButtonItem()
        backButton.title = "Realizar Pagos"
        self.navigationItem.backBarButtonItem = backButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setBalance()
    }

    
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)

    }
    
    
    private func setBalance(){
        //Set balance //
        let balance = UtilityMethods.formatCurency(number:AppDelegate.balance)
        self.saldoDisponible.text =  balance
    }
    
    
    @IBAction func addPayment(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "MakePaymentDirectory", bundle: nil)
        let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "makePaymentDirectory") as! MakePaymentDirectoryViewController
        self.navigationController?.pushViewController(makePaymentVC, animated: true)
    }

}
