//
//  NagivationViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class NagivationViewController: UIViewController {

    @IBOutlet weak var logoImgContraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var environment: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"Navigation" ])
        
        //load data settings
        
        if let myVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        
            self.version.text = "version -v" + myVersion
            
        }
        
        if let myEnvironment = AppSettings.Configuration(main: Bundle.main)["EnvironmentName"] as? String {
            
            if myEnvironment == "Debug Environment"{
            
                self.environment.text = "DEMO Environment"
                self.environment.alpha = 1
           
            }else{
                
                self.logoImgContraintCenterY.constant -= 10
                self.environment.isHidden = true

            }
        
        }
        
        bankName.text = AppSettings.Configuration(main: Bundle.main)["BankName"] as? String
        copyright.text = AppSettings.Configuration(main: Bundle.main)["Copyright"] as? String
        
        
      let profile = OAuthManager.shared.profile!
            username.text = profile.firstNames + "  " + profile.lastNames
            email.text = profile.email
            
        // config fontSize //
        self.username.font = UIFont(name: "OpenSans", size: 23.0)
        self.version.font = UIFont(name: "OpenSans", size: 11.0)
        self.environment.font = UIFont(name: "OpenSans", size: 11.0)
        self.bankName.font = UIFont(name: "OpenSans", size: 11.0)
        self.copyright.font = UIFont(name: "OpenSans", size: 11.0)
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupView(){
        self.containerView.backgroundColor = .principalAppColor
        self.view.backgroundColor = .principalAppColor
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("notification.logging_out_tittle", comment: " "), message: "", preferredStyle: .alert)
         self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: NSLocalizedString("notification.logging_out_accept", comment: " "), style: .default) { action in
            
        let b = sender as! UIButton
        b.loadingIndicator(true, msg: NSLocalizedString("notification.logging_out", comment: " "))
        
        
        Task.logout { (resp) in
            
           b.loadingIndicator(false,  msg: "")
            
            print("cerre la app")
       
            exit(0)
        }
      })
        alert.addAction(UIAlertAction(title: NSLocalizedString("notification.logging_out_close", comment: " "), style: .destructive) { action in
           
        })
    }
    
    @IBAction func makePayment(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        
        let storyboard = UIStoryboard(name: "MakePaymentEmpty", bundle: nil)
        let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "MakePayMent") as? MakePayMentViewController
        self.navigationController?.pushViewController(makePaymentVC!, animated: true)
    }

    @IBAction func paymentHistory(_ sender: Any) {
        let paymentHistoryVC = PaymentHistoryViewController.createController()
        self.navigationController?.pushViewController(paymentHistoryVC, animated: true)
    }
    
    @IBAction func perfil(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Perfil", bundle: nil)
        let perfilVC = storyboard.instantiateViewController(withIdentifier: "Perfil") as! PerfilViewController
        self.navigationController?.pushViewController(perfilVC, animated: true)
    }
    
    @IBAction func codigoPago(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CodigoPago", bundle: nil)
        let codigoPagoVC = storyboard.instantiateViewController(withIdentifier: "CodigoPago") as? CodigoPagoViewController
        self.navigationController?.pushViewController(codigoPagoVC!, animated: true)
    }
    
    @IBAction func directoryPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Directory", bundle: nil)
        let directorioVC = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController
        self.navigationController?.pushViewController(directorioVC!, animated: true)
    }
    
}
