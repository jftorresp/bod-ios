//
//  ATMCodeViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/15/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import Crashlytics

class ATMCodePaymentViewController: UIViewController {
    
    var transsactionData: TransacctionModel? = nil
    var bankName = ""
    
    @IBOutlet weak var firstPin: UILabel!
    @IBOutlet weak var secondPin: UILabel!
    @IBOutlet weak var thirdPin: UILabel!
    @IBOutlet weak var fourthPin: UILabel!
    var pin = ""
    var errors = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"ATMCodePayment"])
    
        titleLabel.font = UIFont(name: "OpenSans" , size: 18)
        
        //set pin numbers //
        
        firstPin.text = ""
        secondPin.text = ""
        thirdPin.text = ""
        fourthPin.text = ""
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
 
    
    
    func paintPinBox(){
        
        print(pin)
        print(pin.count)
        if pin.count == 0{
            
            firstPin.text = ""
            secondPin.text = ""
            thirdPin.text = ""
            fourthPin.text = ""
            return
        }
        
        if pin.count == 1{
            firstPin.text = "."
            secondPin.text = ""
            thirdPin.text = ""
            fourthPin.text = ""
            return
        }
        
        if pin.count == 2{
            firstPin.text = "."
            secondPin.text = "."
            thirdPin.text = ""
            fourthPin.text = ""
            return
        }
        if pin.count == 3{
            firstPin.text = "."
            secondPin.text = "."
            thirdPin.text = "."
            fourthPin.text = ""
            return
        }
        
        if pin.count == 4{
            firstPin.text = "."
            secondPin.text = "."
            thirdPin.text = "."
            fourthPin.text = "."
            return
        }
        
        
    }
    
    @IBAction func buttonZero(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "0"
        paintPinBox()
    }
    @IBAction func buttonOne(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "1"
        paintPinBox()
    }
    
    @IBAction func buttonTwo(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "2"
        paintPinBox()
    }
    
    @IBAction func buttonThree(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "3"
        paintPinBox()
    }
    
    @IBAction func buttonFour(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "4"
        paintPinBox()
    }
    
    
    @IBAction func buttonFive(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "5"
        paintPinBox()
    }
    
    @IBAction func buttonSix(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "6"
        paintPinBox()
    }
    
    @IBAction func buttonSeven(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "7"
        paintPinBox()
    }
    
    @IBAction func buttonEight(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "8"
        paintPinBox()
    }
    
    @IBAction func buttonNine(_ sender: Any) {
        
        if pin.count>=4{return}
        self.pin += "9"
        paintPinBox()
    }
    
    @IBAction func buttonErase(_ sender: Any) {
        
        if(self.pin.count>0){
            self.pin.remove(at: self.pin.index(before: self.pin.endIndex))
            paintPinBox()
        }
    }
    
    @IBAction func buttonCheck(_ sender: Any) {
        
        if pin.count == 4 {
            
            transsactionData?.security = PinModel(pin:pin)
            
            // ready for send transaction request
            
            let storyboard = UIStoryboard(name: "ResultadoTransaccion", bundle: nil)
            let resultTransactionVC = storyboard.instantiateViewController(withIdentifier: "ResultadoTransaccion") as? ResultadoTransaccionViewController
            
            resultTransactionVC?.modalPresentationStyle = UIModalPresentationStyle.custom
            resultTransactionVC?.transactionData = transsactionData
            resultTransactionVC?.bankName = bankName
            
            let myDelegate = UIApplication.shared.delegate as! AppDelegate
            myDelegate.switchControllers(viewControllerToBeDismissed: self, controllerToBePresented: resultTransactionVC!)
        
    }}
}
