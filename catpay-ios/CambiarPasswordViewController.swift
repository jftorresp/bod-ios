//
//  CambiarPasswordViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/16/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class CambiarPasswordViewController: UIViewController {

    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var newPassword: CustomTextField!
    @IBOutlet weak var repeatPassword: CustomTextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        newPassword.delegate = self
        repeatPassword.delegate = self
        
        self.validationLabel.textAlignment = .natural
        self.validationLabel.text = NSLocalizedString("notification.error.password.validation", comment: "")
        
        self.validationLabel.isHidden = true
        self.validationLabel.numberOfLines = 0
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"ChangePassword" ])
        self.password.addShowPasswordButton()
        self.newPassword.addShowPasswordButton()
        self.repeatPassword.addShowPasswordButton()
    }
    
    private func setupView(){
        self.navigationItem.title = "Cambiar Contraseña"
    }
    
    func isValidNumber(s: String) -> Bool {
        let consecutiveChars: [Character: Character] = [
            "0": "1",
            "1": "2",
            "2": "3",
            "3": "4",
            "4": "5",
            "5": "6",
            "6": "7",
            "7": "8",
            "8": "9"
        ]
        var prev: Character = "\0"
        var repeatCount = 1
        for c in s {
            if c == consecutiveChars[prev] || prev == consecutiveChars[c] {
                return false
            }
            if c == prev {
                repeatCount += 1
            }
            prev = c
        }
        return repeatCount < s.count
    }

    func isValidPassword(password:String) ->Bool{
        
        // Longitud mínima 8 caracteres, máxima 10 caracteres
        let isValidLength = password.count >= 8 && password.count <= 10
        
        let invalidSymbols = ["؋","฿","₵","₡","¢","₫","֏","€","ƒ","₣","₲","₴","₾","₭","₺","₼","₦","₱","£","元","圆","圓","﷼៛","₽","₹","රු","૱","௹","꠸","₨","₪","৳","₸","₮","₩","¥","円","~","½"]
        
        // Solamente contiene ciertos caracteres especiales
        let containsInvalidSymbols = invalidSymbols.contains(where: password.contains)
        
        // Los caracteres especiales permitidos son los siguientes: “! @ # $ %& * ( ) _ - + = { } [ ] \ | : ; " ' < > , . ? /” y debe contener al menos uno de esos
        let containSpecialCharacter = "“!@#$%&*()_-+={}[] \\|:;\"'<>,.?/".filter { (char) -> Bool in
            return password.contains(char)
        }.first != nil
        
        // Debe tener al menos: Una letra en mayúscula, una letra en minúscula, un carácter numérico
        
        let capitalLettersRegex = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLettersRegex)
        let containsCapital = texttest.evaluate(with: password)
        
        let lowerLettersRegex = ".*[a-z]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", lowerLettersRegex)
        let containsLower = texttest2.evaluate(with: password)
        
        let digitRegex = ".*[0-9]+.*"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", digitRegex)
        let containsDigit = texttest3.evaluate(with: password)
        
        // No puede contener espacios en blanco
        let containSpaces = password.lowercased().contains(" ")
        let containBankCharacter = password.lowercased().contains("banco")
        let containBODCharacter = password.lowercased().contains("bod")
        
        // No puede contener caracteres numéricos iguales o consecutivos.
        var containsConsecutiveChars = false
        let regex = "(.)\\1"
        if password.range(of: regex, options: .regularExpression) != nil {
            containsConsecutiveChars = true
        }
        
        let sequential = isValidNumber(s: password)
        
        return isValidLength && containSpecialCharacter && !containSpaces && !containBankCharacter && !containBODCharacter && containsConsecutiveChars == false && !containsInvalidSymbols && containsCapital && containsLower && containsDigit && sequential == true
    }
    
    func passwordError(show: Bool){
        
        UIView.animate(withDuration: 0.25) {
            self.validationLabel.isHidden = !show
        }
        
        self.view.endEditing(true)
    }

    @IBAction func SendChangePass(_ sender: Any) {
        
       //Validaciones front
        
        if password.text?.count == 0 {
            
            let result = NSLocalizedString("notification.password", comment: "Introduce tu contrasena actual")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [result])
            self.present(alert, animated:true,completion:nil)
            
            return
        }
        
        
        if newPassword.text?.count == 0 {
        
            let result = NSLocalizedString("notification.newPassword", comment: "Introduce tu nueva contrasena actual")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [result])
            self.present(alert, animated:true,completion:nil)

        }
        
        if((repeatPassword.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.passwordDoesntMatch", comment: "Las contraseñas no coinciden")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Contraseña invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation password
        if !self.isValidPassword(password: self.newPassword.text!){
            let msg = NSLocalizedString("notification.password.conditions", comment: "Verifica las condiciones de creación de contraseña")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Verificiar Contraseña")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            self.passwordError(show: true)
            return
        }else{
            self.passwordError(show: false)
        }
        
        
        if newPassword.text != repeatPassword.text{
            
            let msg = NSLocalizedString("notification.passwordDoesntMatch", comment: "Las contraseñas no coinciden")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Contraseña invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
     
        
        //
        
            print("conectando ...")
            let b = sender as! UIButton
            b.loadingIndicator(true, msg: NSLocalizedString("notification.changing_password", comment: ""))

        let params = ChangePasswordModel(password:password.text!, newPassword: newPassword.text!)
        Task.changePassword(refreshed: false, param: params) { (Response) in
  
            b.loadingIndicator(false, msg: "")
           
            if Response is String {
                let errors = Response as! String
                let myAlert =  NotificationErrorViewController.createController(errors: errors)
                self.present(myAlert, animated: true)
                return
            }
            
            let msg = NSLocalizedString("notification.new_password_message", comment: "Contraseña modificada con éxito")
            let title = NSLocalizedString("", comment: "")
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "OK", style: .cancel) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CambiarPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == newPassword {
            validationLabel.isHidden = false
        }
    }
}
