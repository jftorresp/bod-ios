//
//  ForgotPasswordViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/16/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

class ForgotPasswordViewController: UIViewController {

    // form data /
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupView()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"ForgotPassword" ])
  
        // scroll Gesture
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView(){
        navigationItem.title = NSLocalizedString("notification.forgotPassword", comment: "")
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
        scrollView.scrollsToTop = false
    }
    
    func keyboardWillHide (notification:  Notification){
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        
        NotificationCenter.default.removeObserver(self)
    }
    // end protocol scrollView //
    
    
    func validateEmail() -> Bool {
    
        let regexExpresion = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        
        if (self.email.text?.range(of: regexExpresion, options: .regularExpression)) == nil{
            return false
        }
        
        return true
    }
    
    
    @IBAction func forgotAction(_ sender: Any) {
        
        let myEmail = self.email.text
        
        if(myEmail?.count == 0){
            
            // alert email empty
            let msg = NSLocalizedString("notification.emailInvalid", comment: "Introduce tu email")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
            self.present(alert, animated:true,completion:nil)
            
            return
        }
        
        if !self.validateEmail(){
        
            let msg = NSLocalizedString("notification.validateEmail", comment: "Introduce tu email")
            let alert = UtilityMethods.createAlert(title:  NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
            self.present(alert, animated:true,completion:nil)
            
            return
        }
        
        let b = sender as! UIButton
        b.loadingIndicator(true, msg: NSLocalizedString("notification.loading", comment: " "))
        
        Task.forgotPassword(email: myEmail!) { (completion) in
        
            b.loadingIndicator(false,  msg: "")
            
            guard let navCont = self.navigationController else{
                return
            }
            
            navCont.popViewController(animated: true)
        }
    
    }

}
