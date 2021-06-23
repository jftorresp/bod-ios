//
//  LoginViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/8/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics
import KeychainSwift


class LoginViewController: UIViewController {

    //model login
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        // fabric handler event //
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"Login" ])
        
        self.password.addShowPasswordButton()
        
        // scroll Gesture
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        AppDelegate.balance = 0
        AppDelegate.status = ""
        
        //get Banks //
        Task.getBankTask { (result) in
            if result != nil {
                AppDelegate.bankAccounts = result as! [banksModel]
            }}
    }
    
    
    private func setupView(){
      
        navigationItem.title = NSLocalizedString("notification.login", comment: "")
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = ""
        self.navigationItem.backBarButtonItem = backButtonItem
    }


    
    // Protocol scrollView //
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        titleLabel.font = UIFont(name: "OpenSans" , size: 18)

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
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

    
    // end protocol scrollView //
    
    
    @IBAction func login(_ sender: Any) {
    
        if user.text?.count == 0 {
            
            let result = NSLocalizedString("notification.user", comment: "Introduce tu número telefónico")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [result])
            self.present(alert, animated:true,completion:nil)
        
            return
        }
        
        if user.text?.count != 11 {
            
            let result = NSLocalizedString("notification.userInvalid", comment: "Introduce un número telefónico válido (11 dígitos)")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [result])
            self.present(alert, animated:true,completion:nil)
            
            return
        }

    
        
        if password.text?.count == 0 {
            
            let msg = NSLocalizedString("notification.password", comment: "Introduce tu contraseña")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
            self.present(alert, animated:true,completion:nil)
        
            return
        }
        
        let data = LoginRequestModel(username:user.text!,password:password.text!)
        print("conectando ...")
        let b = sender as! UIButton
        b.loadingIndicator(true, msg: NSLocalizedString("notification.authenticating", comment: " "))
        
        
        Task.Login(parameters: data) { (Response) in
            
            b.loadingIndicator(false,  msg: "")
          
            
            if Response is String {
            
                let dataResponse = UtilityMethods.convertToDictionary(text: Response as! String)
                
                // validation 400 error
                
                if let dataError = dataResponse?["error"] as? String {
                
                    print(dataResponse?["error_description"] as! String)

                    if(dataError == "UnknownDevice"){
                        
                        let storyboard = UIStoryboard(name: "DispositivoNoAutorizado", bundle: nil)
                        let loingVC = storyboard.instantiateViewController(withIdentifier: "DispositivoNoAutorizado") as? DispositivoNoAutorizadoViewController
                        self.present(loingVC!, animated: true, completion: nil)
                        return
                    }
                    
                    if(dataError == "invalid_grant"){
                        
                        let msg = dataResponse?["error_description"] as! String
                        let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
                        self.present(alert, animated:true,completion:nil)
                        return
                    }
                    
                    if(dataError == "MultipleConnections"){
                        
                        let msg = NSLocalizedString("notification.multipleConnections", comment: "")
                        let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
                        self.present(alert, animated:true,completion:nil)
                        return
                    }
                    
                    
                }
                
                if let dataError = dataResponse?["errors"] as? [String: Any] ,
                       dataError["passwordExpired"] != nil {
                        
                    let msg = NSLocalizedString("notification.passwordExpired", comment: "")
                    let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
                    self.present(alert, animated:true,completion:nil)
                    return
                }
                
                // validation 403 Temp Block

                if let dataError = dataResponse?["code"] as? String {
                    
                    
                    if(dataError == "TempBlock"){
        
                        let errors = "{\"message\":\"\(dataResponse?["description"] as! String)\"}"
                        
                        let errorsVC = NotificationErrorViewController.createController(errors: errors)
                        
                        self.present(errorsVC, animated: true)
                    }
                }
            
            } else if(Response is TokensModel){
                
                // success login//
                
                let response = Response as! TokensModel
                
                // inactive user //
                if response.status == "Desafiliado"{
                    
                    let msg = NSLocalizedString("notification.statusDesafiliadoNoRegistro", comment: "")
                    let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
                    self.present(alert, animated:true,completion:nil)
                    return
                }
               
                //success login with active status //
                
                let storyboard = UIStoryboard(name: "MakePaymentEmpty", bundle: nil)
                let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "MakePayMent") as! MakePayMentViewController
                self.navigationController?.pushViewController(makePaymentVC, animated: true)
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let forgotPassword = storyBoard.instantiateViewController(withIdentifier: "ForgotPassword")
        self.navigationController?.pushViewController(forgotPassword, animated: true)
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "Register")
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
 
}
