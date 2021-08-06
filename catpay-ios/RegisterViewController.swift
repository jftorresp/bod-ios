//
//  RegisterViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/14/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //  data form //
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var docType: UITextField!
    @IBOutlet weak var documentId: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var confirmPassword: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldPicker: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerImage: UIImageView!
    
    
    var phoneFilled = false
    var firstFilled = false
    var lastFilled = false
    var docFill = false
    var passFill = false
    var rPassFilled = false
    var allFilled = false
    
    
    let picker = UIPickerView()
    var pickerData = ["V","J","E","P","M","G"]
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁáÉéÍíÓóÚúÑñ"
    let RISTRICTED_CHARACTERS = "“!@#$%&*()_-+={}[] \\|:;\"'<>,.?/؋฿₵₡¢₫֏€ƒ₣₲₴₾₭₺₼₦₱£元圆圓﷼៛₽₹රු૱௹꠸₨₪৳₸₮₩¥円~½0123456789"
    let regexValidationDocumentId = "^[0-9]*$"
    var debugEnvironment = true
    var dataPicker: String = ""
    var registerModel: RegisterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        password.delegate = self
        confirmPassword.delegate = self
        phone.delegate = self
        firstName.delegate = self
        lastName.delegate = self

        
        // detect Environment for show email field //
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"Register" ])
        
        if let myEnvironment = AppSettings.Configuration(main: Bundle.main)["EnvironmentName"] as? String {
            
            if myEnvironment != "Debug Environment"{
             
                self.password.topAnchor.constraint(equalTo: email.topAnchor).isActive = true
                self.password.leadingAnchor.constraint(equalTo: email.leadingAnchor).isActive = true
                self.password.trailingAnchor.constraint(equalTo: email.trailingAnchor).isActive = true
                
                self.password.heightAnchor.constraint(equalTo: email.heightAnchor).isActive = true
                
                self.debugEnvironment = false
               // self.email.removeFromSuperview()
                self.email.tag = -1
                self.password.tag -= 1
                self.confirmPassword.tag -= 1
            
            }
            
        }
        
        // end detect Environment //
    
        picker.dataSource = self
        picker.delegate = self
        
    }
    
    private func setupView(){
        
        self.registerImage.image = UIImage(named: "btnLogin2")
        self.registerButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        self.registerButton.isEnabled = false
        
        phone.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        firstName.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        lastName.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        documentId.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        password.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        confirmPassword.addTarget(self, action: #selector(textFieldEmpty), for: UIControlEvents.editingChanged)
        
        phone.keyboardType = .numberPad
        
        navigationItem.title = NSLocalizedString("notification.register", comment: "")
        self.validationLabel.textAlignment = .natural
        self.validationLabel.text = NSLocalizedString("notification.error.password.validation", comment: "")
        
        self.validationLabel.isHidden = true
        self.validationLabel.numberOfLines = 0
       
        self.password.addShowPasswordButton()
        self.confirmPassword.addShowPasswordButton()
        
        // binding textfild with picker
        textFieldPicker.inputView = picker
        docType.text = pickerData[0]
        
        // scroll Gesture
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        self.documentId.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        // set backButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @objc func textFieldEmpty(textField: UITextField) {
        
        if textField == phone {
            if textField.text!.isEmpty {
                phoneFilled = false
            } else {
                phoneFilled = true
            }
        }
        
        if textField == firstName {
            if textField.text!.isEmpty {
                firstFilled = false
            } else {
                firstFilled = true
            }
        }
        
        if textField == lastName {
            if textField.text!.isEmpty {
                lastFilled = false
            } else {
                lastFilled = true
            }
        }
        
        if textField == documentId {
            if textField.text!.isEmpty {
                docFill = false
            } else {
                docFill = true
            }
        }
        
        if textField == password {
            if textField.text!.isEmpty {
                passFill = false
            } else {
                passFill = true
            }
        }
        
        if textField == confirmPassword {
            if textField.text!.isEmpty {
                rPassFilled = false
            } else {
                rPassFilled = true
            }
        }
        
        allFilled = phoneFilled && firstFilled && lastFilled && docFill && passFill && rPassFilled
        
        if allFilled == true {
            DispatchQueue.main.async {
                self.registerImage.image = UIImage(named: "btnLogin")
                self.registerButton.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
                self.registerButton.isEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.registerImage.image = UIImage(named: "btnLogin2")
                self.registerButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
                self.registerButton.isEnabled = false
            }
        }
    }
    
    // implement protcol scrollView 
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeObservers()
    }
    
    func addObservers(){
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil,  queue:nil){
            
            notification in
            
            self.keyboardWillShow(notification:notification)
            
            
        }
        
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil,  queue:nil){
            
            notification in
            
            self.keyboardWillHide(notification:notification)
            
            
        }
        
    }
    
    func keyboardWillShow(notification:Notification){
        
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInsets
    }
    
    func keyboardWillHide (notification:  Notification){
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        
        NotificationCenter.default.removeObserver(self)
    }

    
    
    // implementando el protocolo para el pickerView
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldPicker.text = pickerData[row]
        self.documentId.text = ""
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }


    @IBAction func pickerButton(_ sender: Any) {
        
        self.textFieldPicker.becomeFirstResponder()
        
    }
    
    
    @objc func textFieldDidChange(_ textField:UITextField){
    
        let doctype = self.docType.text!
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
        let containDocumentId = password.lowercased().contains(self.documentId.text!.lowercased())
        let containName = password.lowercased().contains(self.firstName.text!.lowercased())
        let containLastName = password.lowercased().contains(self.lastName.text!.lowercased())
        let containBankCharacter = password.lowercased().contains("banco")
        let containBODCharacter = password.lowercased().contains("bod")
        
        // No puede contener caracteres numéricos iguales o consecutivos.
        var containsConsecutiveChars = false
        let regex = "(.)\\1"
        if password.range(of: regex, options: .regularExpression) != nil {
            containsConsecutiveChars = true
        }
        
        let sequential = isValidNumber(s: password)
        
        return isValidLength && containSpecialCharacter && !containSpaces && !containDocumentId && !containName && !containLastName && !containBankCharacter && !containBODCharacter && containsConsecutiveChars == false && !containsInvalidSymbols && containsCapital && containsLower && containsDigit && sequential == true
    }
    
    
    func passwordError(show: Bool){
        
        UIView.animate(withDuration: 0.25) {
            self.validationLabel.isHidden = !show
        }
        
        self.view.endEditing(true)
        
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom)
        
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        // validation password
        
        view.endEditing(true)

        if password.text != confirmPassword.text{
            
            let msg = NSLocalizedString("notification.passwordDoesntMatch", comment: "Las contraseñas no coinciden")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Contraseña invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        
        // validation phone number
        if((phone.text?.count)!<11 || (phone.text?.count)!>11){
        
            
            let msg = NSLocalizedString("notification.userInvalid", comment: "Introduce un número telefónico válido (11 dígitos)")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Numero invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation firstName
        if((firstName.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.firstNameInvalid", comment: "Introduce tu nombre")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Nombre invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation lastName
        if((lastName.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.lastNameInvalid", comment: "Introduce tu apellido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Apellido invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
                
        // validation documentId
        if((documentId.text?.count)! == 0){
            
            let msg = NSLocalizedString("notification.documentIdInvalid", comment: "Introduce tu cedula de identidad")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Cedula invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        
        // validation documentId length
        
        if((documentId.text?.count)! < 5 ){
            
            let msg = NSLocalizedString("notification.documentIdInvalidDigit", comment: "Introduce una cédula de identidad válida")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Cedula invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation email only in debugEnvironment //
        
        if(self.debugEnvironment && (email.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.emailInvalid", comment: "Introduce tu email")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Email invalido")
            let alert = UtilityMethods.createAlert(title: title, message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation passwrod
        if((password.text?.count)!==0){
            
            let msg = NSLocalizedString("notification.password", comment: "Introduce tu contrasena")
            let title = NSLocalizedString("notification.titleInvalid", comment: "")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation password
        if !self.isValidPassword(password: self.password.text!){
            let msg = NSLocalizedString("notification.password.conditions", comment: "Verifica las condiciones de creación de contraseña")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Verificiar Contraseña")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            self.passwordError(show: true)
            return
        }else{
            self.passwordError(show: false)
        }
        
        // validation confirmPassword
        if self.confirmPassword.text! !=  self.password.text!{
            
            let msg = NSLocalizedString("notification.passwordDoesntMatch", comment: "Las contraseñas no coinciden")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Contraseña invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        let emailText = self.debugEnvironment ? self.email.text : ""
        
        let data = RegisterModel(phoneNumber:phone.text!, firstNames:firstName.text!,lastNames:lastName.text!, email:emailText!, password:password.text!,documentId:documentId.text!, docType:docType.text!)
        
        self.registerModel = data
        let atmVC = ATMCodeViewController.createController()
        atmVC.delegate = self
        self.navigationController?.pushViewController(atmVC, animated: true)
    }
    
    func errorNotification(in viewController: UIViewController, errors:String){
        let myAlert = NotificationErrorViewController.createController(errors: errors)
        viewController.present(myAlert, animated: true)
    }
}

//extension RegisterViewController: TermsAndConditionsViewDelegate {
//
//    func termsAndConditions(isAccepted: Bool) {
//        guard isAccepted else { return }
//        let atmVC = ATMCodeViewController.createController()
//        atmVC.delegate = self
//        self.navigationController?.pushViewController(atmVC, animated: true)
//    }
//}

extension RegisterViewController: ATMCodeViewDelegate{
    
    func atmView(with pin: PinModel, and atmCodeViewController:ATMCodeViewController) {
        
        guard let register = self.registerModel else{
            return
        }
        
        register.security = pin
        let loading = UIButton()
        loading.loadingIndicator(true, msg:NSLocalizedString("notification.creatingAccount", comment: ""))
        
        Task.SendOTPCodeTask(param: register) { (response) in
            
            loading.loadingIndicator(false, msg: "")
            // errror in registerData
            if  response is String {
                // show error//
            atmCodeViewController.navigationController?.popViewController(animated: true)
                self.errorNotification(in: self, errors: response as! String)
                return
            }
            
            // case success data
            
            guard let register = response as? RegisterModel else{
                return
            }
           let verificationCodeVC = VerificationCodeViewController.createController(registerModel: register)
            
            self.navigationController?.pushViewController(verificationCodeVC, animated: true)
        }
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        
        var maxLength = 0
        if textField == password || textField == confirmPassword {
            maxLength = 10
        }
        
        if textField == phone {
            maxLength = 11
        }
        
        if textField == firstName || textField == lastName {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == password {
            validationLabel.isHidden = false
        }
    }
}
