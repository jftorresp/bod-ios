//
//  CustomTextField.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/4/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import Foundation
import UIKit


class CustomTextField: UITextField, UITextFieldDelegate{

    let button = UIButton()
    var showText = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        //border
        self.borderStyle = .roundedRect
//        self.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 3.0
        self.font = UIFont(name: "OpenSans", size: 14.0)
        self.layoutMargins = UIEdgeInsetsMake(0, 50, 0, 15)
        
        
        //toolbar
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        
        self.inputAccessoryView = toolBar
        
        // set delegate
        self.delegate = self
    }
    
    
    func addShowPasswordButton(){
        
        button.setImage(UIImage(named: "eyesBod"), for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        self.rightView = button
        
        button.addTarget(self, action: #selector(self.showPassword), for: .touchUpInside)
        
        self.rightViewMode = .whileEditing
        self.clearButtonMode = .never
        self.isSecureTextEntry = true
        
    }
    
    @objc func showPassword(){
        
        self.showText = !self.showText
        let imageName = self.showText ? "eyesRedBod" : "eyesBod"
        self.isSecureTextEntry = !self.showText
        
        self.button.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.button.alpha = 1
            self.button.setImage(UIImage(named:imageName), for: .normal)
            
        })
        
        
    }
   
    // padding left in textFields
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    
    
    
    // hanlder events done button and return button //
    
    @objc func doneClicked() ->Bool{
    
        return self.textFieldShouldReturn(self)
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // try to find next responder //
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // not found, so remove keyboard //
            textField.resignFirstResponder()
        }
        // do not add a line break //
        return false
    }
    

// tap gesture closeKeyboard handler //

class TapGestureRecognizer: UITapGestureRecognizer {
    
    let identifier: String
    
    private override init(target: Any?, action: Selector?) {
        self.identifier = ""
        super.init(target: target, action: action)
    }
    
    init(target: Any?, action: Selector?, identifier: String) {
        self.identifier = identifier
        super.init(target: target, action: action)
    }
    
    static func == (left: TapGestureRecognizer, right: TapGestureRecognizer) -> Bool {
        return left.identifier == right.identifier
    }
}


}
