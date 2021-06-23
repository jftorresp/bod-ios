//
//  DispositivoNoAutorizadoViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class DispositivoNoAutorizadoViewController: UIViewController {

    @IBOutlet weak var DeviceU: UILabel!
    @IBOutlet weak var Text1: UILabel!
    @IBOutlet weak var Text2: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"UnauthorizedDevice" ])
 
        titleLabel.font = UIFont(name: "OpenSans" , size: 18)
        self.DeviceU.font = UIFont(name: "OpenSans-Semibold", size: 14.0)
        self.Text1.font = UIFont(name: "OpenSans-Semibold", size: 16.0)
        self.Text2.font = UIFont(name: "OpenSans-Semibold", size: 14.0)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }


}
