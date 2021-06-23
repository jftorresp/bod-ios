//
//  LoadingButton.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/20/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func loadingIndicator(_ show: Bool, msg: String) {
    
  
        let tag = 9876
        if show {

            let viewIndicator = Bundle.main.loadNibNamed("loadingIndicator", owner: self, options: nil)?[0] as! loadingIndicatorController
            viewIndicator.tag = tag
            let rootView = UtilityMethods.getTopViewController()?.view
            viewIndicator.loading.text = msg
            viewIndicator.center = (rootView!.center)
            viewIndicator.indicator.hidesWhenStopped = true
            viewIndicator.layer.cornerRadius = 5
            rootView?.addSubview(viewIndicator)
            viewIndicator.indicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        
            
        } else {
            
            self.isEnabled = true
            self.alpha = 1.0
            var topController: UIView!
            
            if let rootC = UtilityMethods.getTopViewController() as? UIAlertController{
            
                topController = rootC.presentingViewController?.view
           
            }else{
                
                topController = UtilityMethods.getTopViewController()?.view
            }
            
            if let viewIndicator = topController?.viewWithTag(tag) as? loadingIndicatorController {
                viewIndicator.indicator.stopAnimating()
                viewIndicator.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
}

