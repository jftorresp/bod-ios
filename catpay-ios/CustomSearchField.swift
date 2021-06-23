//
//  CustomSearchField.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/10/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import UIKit
//import SearchTextField

class CustomSearchField :  SearchTextField {


    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        //border
        self.borderStyle = .roundedRect
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 3.0
        self.font = UIFont(name: "OpenSans", size: 14.0)
        self.layoutMargins = UIEdgeInsetsMake(0, 50, 0, 15)
        
    }
    
    
    // padding left in textFields
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    

}
