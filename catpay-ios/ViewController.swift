//
//  ViewController.swift
//  catpay-ios
//
//  Created by Francisco Vasquez on 6/7/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var Configuration : Dictionary<String, Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Configuration = AppSettings.Configuration(main: Bundle.main);
        let host = Configuration?["ServiceBaseUrl"] as! String;
        print(String(format: AppSettings.API_PAYMENT_PAGED, host, 1.45678, 10));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

