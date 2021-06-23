//
//  PrincipalNavigation.swift
//  catpay-ios
//
//  Created by Nebraska Melendez on 8/21/19.
//  Copyright © 2019 Technifiser. All rights reserved.
//

import UIKit

class PrincipalNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

       self.setupView()
    }
    

    //MARK : Setups
    
    private func setupView(){
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "OpenSans" , size: 18)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        self.navigationBar.barTintColor = UIColor.principalAppColor
        self.view.backgroundColor = .principalAppColor
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .white
        navigationBar.shadowImage = UIImage()
    }

}
