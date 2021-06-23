//
//  RegisterAccountViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/26/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
//import SearchTextField
import Crashlytics

class RegisterAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate  {

    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var originYConstraint: NSLayoutConstraint!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var banco: SearchTextField!
    @IBOutlet weak var cedula: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var textFieldPicker: UITextField!
     
    let picker = UIPickerView()
    var pickerData = ["V","E","P","M", "J", "G"]
    let regexValidation = "[ÑñA-Za-z]*[ÑñA-Za-z][ÑñA-Za-z]*$"
    let regexValidationDocumentId = "^[0-9]*$"


    var nameBanks: [String] = []
    var parentView: AddPaymentViewController? = nil
    var edit = false
    
    class func createController(parentView:AddPaymentViewController) -> RegisterAccountViewController{
        let storyboard = UIStoryboard(name: "RegisterAccount", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()! as! RegisterAccountViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.parentView = parentView
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"RegisterAccount"])
        
        self.banco.delegate = self
        
        //set data
        self.telefono.text = parentView?.telefono.text
        self.banco.text = parentView?.banco.text
        self.nombre.text = parentView?.transsactionData.recipient?.name
        self.cedula.text = parentView?.transsactionData.recipient?.lastTwoDigitId
        
        self.nameBanks = (parentView?.nameBanks)!
        
        picker.dataSource = self
        picker.delegate = self
        
        self.textFieldPicker.inputView = picker
        self.textFieldPicker.text = parentView?.transsactionData.recipient?.docType
       
        UtilityMethods.openModal(view: self.view)
        
        // Background color
        self.banco.theme.bgColor = UIColor.white
        
        self.banco.startVisible = true
        self.banco.interactedWith = false
        self.banco.theme.font  = UIFont(name: "OpenSans" , size: 14.0)!
        self.banco.filterStrings(nameBanks)
        
        
        // add validation in documentId //
        
        self.cedula.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)

        
        // keyboard handler
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.banco.startVisible = true
        self.banco.interactedWith = true
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.banco.endEditing(true)
    }

    
    //start -- up modal when open keyboard //
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
                
                self.originYConstraint.constant = 0
            } else {
                self.originYConstraint.constant = -100
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // end -- up modal when open keyboard //
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldPicker.text = pickerData[row]
        self.cedula.text = ""
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    
    @IBAction func pickerButton(_ sender: Any) {
        
        self.textFieldPicker.becomeFirstResponder()
        
    }
    
    
    @IBAction func closebutton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  @objc  func textFieldDidChange(_ textField:UITextField){
        
        let doctype = self.textFieldPicker.text!
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
        
        if (!stringNumber.isEmpty && (stringNumber.range(of: regexValidationDocumentId, options: .regularExpression)) == nil){
            
            textField.text!.removeLast()
        }
    
        if stringNumber.count > maxDigit{
            
            let subString = textField.text?.substring(to: stringNumber.index(stringNumber.startIndex, offsetBy: maxDigit))
            textField.text = subString
        }
        
    }

    @IBAction func agregar(_ sender: Any) {
    
        //validation phone
        if((telefono.text?.count)!<11 || (telefono.text?.count)!>11){
            
            let msg = NSLocalizedString("notification.userInvalid", comment: "Introduce un número telefónico válido (11 dígitos)")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Numero invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        //validation full name
        if((nombre.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.firstNameInvalid", comment: "Introduce tu nombre y apellido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Nombre invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation firstName Only Letters //
        if  ((nombre.text?.range(of: regexValidation, options: .regularExpression)) == nil) {
            
            let msg = NSLocalizedString("notification.firstNameInvalidCharacters", comment: "Introduce tu apellido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Apellido invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation documentId
        if((cedula.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.documentIdInvalid", comment: "Introduce tu cedula de identidad")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Cedula invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        //validation banco
        if((banco.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.bank", comment: "Introduce un banco valido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Banco invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
            
        parentView?.setAccountInfo(docType: textFieldPicker.text!, documentId: cedula.text! , bank: banco.text!, fullName: nombre.text!, phoneNumber: telefono.text! )
        
        self.dismiss(animated: true)
    }
       
}
