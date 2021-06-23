//
//  EditContactPhoneViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 23/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit

class AddContactPhoneViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var guardarBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        guardarBtn.isEnabled = false
        
        telefonoTextField.delegate = self
        
        telefonoTextField.addTarget(self, action: #selector(textFieldChange), for: UIControlEvents.editingChanged)
        
        self.hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()
        
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        telefonoTextField.inputAccessoryView = doneToolbar
    }
    
    
    @objc func doneButtonAction() {
        telefonoTextField.resignFirstResponder()
    }
    
    @objc func textFieldChange(textField: UITextField) {
        
        var celFill = false
        if textField.text!.isEmpty {
            celFill = false
        } else {
            celFill = true
        }
        
        if celFill == true {
            DispatchQueue.main.async {
                self.guardarBtn.imageView?.image = UIImage(named: "imgSave")
                self.guardarBtn.isEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.guardarBtn.imageView?.image = UIImage(named: "imgSave1")
                self.guardarBtn.isEnabled = false
            }
        }
    }
    
    /* Setup the view for the navigation button above the banner view */
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
        viewHeader.backgroundColor = UIColor.principalAppColor
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }
    
    /* Function that connects the navigation button to the Navigation ViewController */
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)
    }
    
    @IBAction func cancelarPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func guardarPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "¡Atención!", message: "El teléfono que desea agregar ya existe", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK",style:.cancel))
        var repeatedPhone = false
        
        if let phones = DirectoryViewController.selectedContact?.phoneNumbers {
            for phone in 0..<(phones.count) {
                
                if phones[phone] == telefonoTextField.text! {
                    
                    repeatedPhone = true
                    print("repetido")
                } else {
                    repeatedPhone = false
                    print("no repetido")
                }
            }
            
            if repeatedPhone == true {
                self.present(alert, animated: true, completion: nil)
                
            } else {
                if let contact = DirectoryViewController.selectedContact {
                    contact.phoneNumbers?.append(telefonoTextField.text!)
                    
                    if let id = DirectoryViewController.selectedContact?.id {
                        Task.updateDirectoryPhones(refreshed: false, directoryId: id, phoneNumbers: contact.phoneNumbers!) { (response) in
                            
                            let storyboard = UIStoryboard(name: "DetailContact", bundle: nil)
                            let detailContactVC = storyboard.instantiateViewController(withIdentifier: "DetailContact") as? DetailContactViewController
                            self.navigationController?.pushViewController(detailContactVC!, animated: true)
                            
                            let alert = UtilityMethods.createAlert(title: "", message: ["Teléfono agregado satisfactoriamente"])
                            self.present(alert, animated:true,completion:nil)
                        }
                    }
                }
            }
        }
    }    
}

extension AddContactPhoneViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        let maxLength = 11
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
