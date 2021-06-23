//
//  EditContactPhoneViewController.swift
//  debug
//
//  Created by Juan Felipe Torres on 7/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit

class EditContactPhoneViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var telefonoTxtField: UITextField!
    @IBOutlet weak var guardarBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.addDoneButtonOnKeyboard()
        self.hideKeyboardWhenTappedAround()
        
        telefonoTxtField.addTarget(self, action: #selector(textFieldChange), for: UIControlEvents.editingChanged)
        
        telefonoTxtField.text = DetailContactViewController.selectedPhone
        telefonoTxtField.delegate = self
    }
    
    func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            telefonoTxtField.inputAccessoryView = doneToolbar
        }

    
    @objc func doneButtonAction() {
        telefonoTxtField.resignFirstResponder()
    }
    
    @objc func textFieldChange(textField: UITextField) {
        DispatchQueue.main.async {
                self.guardarBtn.imageView?.image = UIImage(named: "imgSave")
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
    
    @IBAction func guardarPressed(_ sender: Any) {
        
        if let contact = DirectoryViewController.selectedContact {
            
            if let id = DirectoryViewController.selectedContact?.id {
                Task.updateDirectoryPhones(refreshed: false, directoryId: id, phoneNumbers: contact.phoneNumbers!) { (response) in
                    
                    let storyboard = UIStoryboard(name: "DetailContact", bundle: nil)
                    let detailContactVC = storyboard.instantiateViewController(withIdentifier: "DetailContact") as? DetailContactViewController
                    self.navigationController?.pushViewController(detailContactVC!, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelarPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditContactPhoneViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let index = DetailContactViewController.phoneIndex {
            DirectoryViewController.selectedContact?.phoneNumbers?[index] = textField.text!
            DetailContactViewController.selectedPhone = textField.text
        }
    }
    
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
