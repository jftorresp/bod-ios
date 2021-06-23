//
//  VerificationCodeViewController.swift
//  catpay-ios
//
//  Created by IOS Developer on 7/26/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var codeTextField: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helpText: UILabel!
    
    var session: RegisterModel?    
    
    class func createController(registerModel: RegisterModel) ->VerificationCodeViewController{
        
        let storyboard = UIStoryboard(name: "VerificationCode", bundle: nil)
        let verificationCodeVC = storyboard.instantiateViewController(withIdentifier: "VerificationCode") as! VerificationCodeViewController
        verificationCodeVC.session = registerModel
        return verificationCodeVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"VerificationCode"])
    }

    private func setupView(){
        self.navigationItem.title = "Verificación de Número Telefónico"
        helpText.font = UIFont(name: "OpenSans" , size: 12)
        self.phoneNumber.text = session?.phoneNumber
    }
    
    // Protocol scrollView //
    
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
        scrollView.scrollsToTop = false
    }
    
    func keyboardWillHide (notification:  Notification){
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    

    @IBAction func verrificationButton(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if codeTextField.text == "" {
            let alert =  UtilityMethods.createAlert(title:  NSLocalizedString("notification.titleInvalid", comment: ""), message: ["Ingrese el codigo"])
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let code = codeTextField.text!
        let buttonIndicator = UIButton()
        
        buttonIndicator.loadingIndicator(true, msg: NSLocalizedString("notification.verification_Indicator", comment: " Verificando"))
        
        Task.validateOTPTask(
            otpCode: code,
            numberPhone: self.session!.phoneNumber) { (response) in
                
                if response == nil{
                    
                    let title =  NSLocalizedString("notification.titleInvalid", comment: "")
                    let msg = NSLocalizedString("notification.InvalidCode_Verification", comment: "")
                    buttonIndicator.loadingIndicator(false, msg: "")
                    let alert = UIAlertController(title:title, message:msg, preferredStyle:.alert)
                    
                    // cerrando notificacion
                    alert.addAction(UIAlertAction(title:"OK",style:.cancel))
                    buttonIndicator.loadingIndicator(false, msg: "")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                // verification succes
                // register account
                Task.register(parameters: self.session!, completion: { (response) in
                    
                    if (response == nil){
                        let title =  NSLocalizedString("notification.titleInvalid", comment: "")
                        let msg = NSLocalizedString("notification.InvalidCode_Verification", comment: "")
                        buttonIndicator.loadingIndicator(false, msg: "")
                        let alert = UIAlertController(title:title, message:msg, preferredStyle:.alert)
                        alert.addAction(UIAlertAction(title:"OK",style:.cancel))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let errors = response as? String{
                        let myAlert = NotificationErrorViewController.createController(errors: errors)
                        buttonIndicator.loadingIndicator(false, msg: "")
                        self.present(myAlert, animated: true)
                        return
                    }
                    
                    if response is SessionsModel{
                        
                        let loginRequest = LoginRequestModel(
                            username:(self.session?.phoneNumber)!,
                            password:(self.session?.password)!
                        )
                        
                        Task.Login(parameters: loginRequest, completion: { (Response) in
                            
                            buttonIndicator.loadingIndicator(false, msg: "")
                            
                            if !(Response is String) {
                                
                                let alert = UIAlertController(
                                    title: NSLocalizedString("", comment: " "),
                                    message: NSLocalizedString("notification.register_msg", comment: "")
                                    , preferredStyle: .alert
                                )
                                
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: " "), style: .default) { action in
                                    //TODO: render principal view //
                                    let storyboard = UIStoryboard(name: "MakePaymentEmpty", bundle: nil)
                                    let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "MakePayMent") as! MakePayMentViewController
                                    
                                    if let navCont = self.navigationController {
                                        let controllers = [navCont.viewControllers.first!,makePaymentVC]
                                        navCont.setViewControllers(controllers, animated: true)
                                    }
                                })
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }else{
                        buttonIndicator.loadingIndicator(false, msg: "")
                    }
                })
        }
    }

}
