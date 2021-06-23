//
//  RecoveryPasswordViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 7/13/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import  Crashlytics

class RecoveryPasswordViewController: UIViewController {

    //MARK: Vars
    var token = ""
    var username = ""
    
    //MARK: UIVars
    @IBOutlet weak var newPassword: CustomTextField!
    @IBOutlet weak var repeatPassword: CustomTextField!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"RecoveryPassword"])
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    private func setupView(){
        
        //Navigation
        navigationItem.title = NSLocalizedString("notification.changePassword", comment: "")
        
        newPassword.addShowPasswordButton()
        repeatPassword.addShowPasswordButton()
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        //Validaciones front
        
        if newPassword.text?.count == 0 {
            
            let result = NSLocalizedString("notification.newPassword", comment: "Introduce tu contrasena")
            let alert = UtilityMethods.createAlert(title: "¡Atención!", message: [result])
            self.present(alert, animated:true,completion:nil)
            
            return
        }
        
        
        if repeatPassword.text?.count == 0 {
            
            let result = NSLocalizedString("notification.newPassword", comment: "Introduce tu nueva contrasena actual")
            let alert = UtilityMethods.createAlert(title: "¡Atención!", message: [result])
            self.present(alert, animated:true,completion:nil)
            
        }
        
        if newPassword.text != repeatPassword.text{
            
            let msg = NSLocalizedString("notification.passwordDoesntMatch", comment: "Las contraseñas no coinciden")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Contraseña invalida")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        let recoveryPassword = RecoveryPasswordModel (emailAddress: username, newPassword: newPassword.text!, confirmPassword: repeatPassword.text!, resetToken: token)
        
        let b = sender as! UIButton
        b.loadingIndicator(true, msg: NSLocalizedString("notification.loading", comment: " "))
         print("antes de task")
        Task.recoveryPassword(param: recoveryPassword) { (Response) in
           print("Pase task")
          b.loadingIndicator(false, msg: "" )
            
            if Response == nil {return}

            if Response is String {
                let alert = NotificationErrorViewController.createController(errors: Response as! String)
                self.present(alert, animated: true)
                return
            }
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()!
            let navigationVC = PrincipalNavigationViewController(rootViewController: initialViewController)
            AppDelegate.shared.window?.rootViewController = navigationVC
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()!
        let navigationVC = PrincipalNavigationViewController(rootViewController: initialViewController)
        AppDelegate.shared.window?.rootViewController = navigationVC
        AppDelegate.shared.window?.makeKeyAndVisible()
        
    }
}
