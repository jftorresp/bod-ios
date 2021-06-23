//
//  EditContactInfoViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 23/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit

class EditContactInfoViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var cedulaTextField: UITextField!
    @IBOutlet weak var tipoCedulaTextField: UITextField!
    @IBOutlet weak var tipoCedulaBtn: UIButton!
    @IBOutlet weak var guardarBtn: UIButton!
    
    let picker = UIPickerView()
    var pickerData = ["V","E","P","M"]
    var dataPicker: String = ""
    let regexValidationDocumentId = "^[0-9]*$"
    
    var nameFill = false
    var cedFill = false
    var allFilled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        // Setting the outlets with the data of the selected contact
        nombreTextField.text = DirectoryViewController.selectedContact?.fullName
        cedulaTextField.text = DirectoryViewController.selectedContact?.documentId
        tipoCedulaTextField.text = DirectoryViewController.selectedContact?.documentType
        
        nombreTextField.addTarget(self, action: #selector(textFieldChange), for: UIControlEvents.editingChanged)
        cedulaTextField.addTarget(self, action: #selector(textFieldChange), for: UIControlEvents.editingChanged)
        
        picker.dataSource = self
        picker.delegate = self
        
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

            nombreTextField.inputAccessoryView = doneToolbar
            cedulaTextField.inputAccessoryView = doneToolbar
            tipoCedulaTextField.inputAccessoryView = doneToolbar

        }

    
    @objc func doneButtonAction() {
        nombreTextField.resignFirstResponder()
        cedulaTextField.resignFirstResponder()
        tipoCedulaTextField.resignFirstResponder()
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
        
        self.cedulaTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        tipoCedulaTextField.inputView = picker
        tipoCedulaTextField.text = pickerData[0]
    }
    
    /* Function that connects the navigation button to the Navigation ViewController */
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)
    }
    
    @IBAction func tipoCedulaPressed(_ sender: Any) {
        self.tipoCedulaTextField.becomeFirstResponder()
    }
    

    @IBAction func cancelarPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func guardarPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "¿Estás seguro de realizar el cambio?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            
            
            if let id = DirectoryViewController.selectedContact?.id , let contact = DirectoryViewController.selectedContact {
                let params = directoryModel(fullName: self.nombreTextField.text!, documentType: self.tipoCedulaTextField.text!, documentId: self.cedulaTextField.text!, phoneNumbers: contact.phoneNumbers!)
                
                Task.updateDirectory(refreshed: false, directoryId: id, params: params) { (response) in
                    
                    let storyboard = UIStoryboard(name: "DetailContact", bundle: nil)
                    let detailContactVC = storyboard.instantiateViewController(withIdentifier: "DetailContact") as? DetailContactViewController
                    self.navigationController?.pushViewController(detailContactVC!, animated: true)
                    
                    let alert = UtilityMethods.createAlert(title: "", message: ["Cambio realizado exitosamente"])
                    self.present(alert, animated:true,completion:nil)
                }

            }
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated:true,completion:nil)
                
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
    
        let doctype = self.tipoCedulaTextField.text!
        var maxDigit = 0
        
        switch doctype {
            
            case "V":
            
                maxDigit = 9
                
            case "E":
            
                maxDigit = 9
                
            case "P":
            
                maxDigit = 14

            default:
                // m case //
                maxDigit = 14
            
        }
        
        let stringNumber = textField.text!
        
        if ( !stringNumber.isEmpty && (stringNumber.range(of: regexValidationDocumentId, options: .regularExpression)) == nil){
            
            textField.text!.removeLast()
        }
        
        if stringNumber.count > maxDigit{
            
            let subString = textField.text?.substring(to: stringNumber.index(stringNumber.startIndex, offsetBy: maxDigit))
            textField.text = subString
        }
    
    }
    
}

extension EditContactInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipoCedulaTextField.text = pickerData[row]
        self.cedulaTextField.text = ""
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
