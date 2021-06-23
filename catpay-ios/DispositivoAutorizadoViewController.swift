//
//  DispositivoAutorizadoViewController.swift
//  catpay-ios
//
//  Created by IOS Developer on 9/19/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class DispositivoAutorizadoViewController: UIViewController {
    
    
    var authenticate: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"AuthorizedDevice"])
        
        Task.authenticateDeviceTask(link: authenticate, completion: {_ in
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
