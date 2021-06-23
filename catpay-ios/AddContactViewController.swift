//
//  AddContactViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 23/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var cedulaTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var tipoCedulaTextField: UITextField!
    @IBOutlet weak var tipoCedulaBtn: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var guardarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    let picker = UIPickerView()
    var pickerData = ["V","E","P","M"]
    var dataPicker: String = ""
    var dirModel: directoryModel?
    let regexValidationDocumentId = "^[0-9]*$"
    
    var nameFill = false
    var cedFill = false
    var telFill = false
    var allFilled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        tipoCedulaBtn.layer.cornerRadius = 5
        self.guardarBtn.isEnabled = false
        
        picker.dataSource = self
        picker.delegate = self
        nombreTextField.delegate = self
        tipoCedulaTextField.delegate = self
        cedulaTextField.delegate = self
        telefonoTextField.delegate = self
        
        nombreTextField.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        tipoCedulaTextField.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        cedulaTextField.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        telefonoTextField.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        
        guardarBtn.addPaddingRight()
        cancelarBtn.addPaddingLeft()
        
        self.hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()
        
//        if nombreTextField.text?.isEmpty ?? true && cedulaTextField.text?.isEmpty ?? true &&  tipoCedulaTextField.text?.isEmpty ?? true && telefonoTextField.text?.isEmpty ?? true {
//
//            guardarBtn.imageView?.image = UIImage(named: "imgSave")
//        }
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
            telefonoTextField.inputAccessoryView = doneToolbar

        }

    
    @objc func doneButtonAction() {
        nombreTextField.resignFirstResponder()
        cedulaTextField.resignFirstResponder()
        tipoCedulaTextField.resignFirstResponder()
        telefonoTextField.resignFirstResponder()
    }
    
    @objc func textFieldEmpty(textField: UITextField) {
        
        if textField == nombreTextField {
            if textField.text!.isEmpty {
                cedFill = true
            } else {
                nameFill = true
            }
        }
        
        if textField == cedulaTextField {
            if textField.text!.isEmpty {
                cedFill = false
            } else {
                cedFill = true
            }
        }
        
        if textField == telefonoTextField {
            if textField.text!.isEmpty {
                telFill = false
            } else {
                telFill = true
            }
        }
        
        allFilled = nameFill && cedFill && telFill
        
        if allFilled == true {
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
        
        view.endEditing(true)
        
        if nombreTextField.text! == "" || tipoCedulaTextField.text! == "" || cedulaTextField.text! == "" || telefonoTextField.text! == "" {
            let alert = UtilityMethods.createAlert(title: "Opción inválida", message: ["Por favor llena todos los campos antes de guardar"])
            self.present(alert, animated:true,completion:nil)
        } else {
            let data = directoryModel(fullName: nombreTextField.text!, documentType: tipoCedulaTextField.text!, documentId: cedulaTextField.text!, phoneNumbers: [telefonoTextField.text!])
            
            self.dirModel = data
            
            guard let dir = self.dirModel else {
                return
            }
            
            Task.addContact(parameters: dir) { (response) in
                
                if response is String {
                    let dataResponse = UtilityMethods.convertToDictionary(text: response as! String)
                    
                    if let dataError = dataResponse?["message"] as? String {
                        
                        if (dataError == "Contacto ya existe") {

                            let alert = UtilityMethods.createAlert(title: "¡Atención!", message: ["Un contacto con esos datos ya existe"])
                            self.present(alert, animated:true,completion:nil)
                        }
                    }
                }
                else if (response is directoryModel) {
                    let direct = response as? directoryModel
                    print("successfully added contact")
                    self.dirModel = direct
                    
                    let storyboard = UIStoryboard(name: "Directory", bundle: nil)
                    let directorioVC = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController
                    self.navigationController?.pushViewController(directorioVC!, animated: true)
                        
                    let alert = UtilityMethods.createAlert(title: "¡Listo!", message: ["Contacto agregado satisfactoriamente"])
                    self.present(alert, animated:true,completion:nil)
                }
            }


        }
    }
    
    @objc func textFieldDidChange(_ textField:UITextField) {
    
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

extension AddContactViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    func nombreTxtFieldEmpty(sender: UITextField) {
        
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == telefonoTextField || textField == cedulaTextField {
            if (string == " ") {
                return false
            }
        }
        
        var maxLength = 0
        if textField == telefonoTextField {
            maxLength = 11
        }
        
        if textField == cedulaTextField || textField == nombreTextField || textField == tipoCedulaTextField {
            maxLength = 100
        }
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString


        return newString.length <= maxLength
    }
}

extension UIButton {
    
    func addPaddingLeft() {
        self.titleEdgeInsets.left = 5
    }
    
    func addPaddingRight() {
        self.imageEdgeInsets.right = 5
    }
}
