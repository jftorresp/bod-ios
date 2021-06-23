//
//  CustomLabel.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/7/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation

import UIKit

class CustomLabel: UILabel {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
       //font
        self.textColor = UIColor.white
        
        self.font = UIFont(name: "OpenSans-Semibold ", size: 18.0)
    
      
        
       
    }
    
}



// extension of concatDictionary

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}
