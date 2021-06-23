//
//  PerfilViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/16/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class PerfilViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var identification: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"Profile"])
        let profile = OAuthManager.shared.profile!
        username.text = profile.firstNames + "  " + profile.lastNames
        email.text = profile.email
        phone.text = profile.phoneNumber
        identification.text = profile.docType + profile.documentId
        self.navigationItem.title = "Perfil"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func navigation() {
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func cambiarPass(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CambiarPassword", bundle: nil)
        let cambiarPassVC = storyboard.instantiateViewController(withIdentifier: "CambiarPassword") as! CambiarPasswordViewController
        self.navigationController?.pushViewController(cambiarPassVC, animated: true)
    }
}
