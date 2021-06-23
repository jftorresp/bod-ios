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

protocol ATMCodeViewDelegate:class{
    func atmView(with pin:PinModel, and atmCodeViewController:ATMCodeViewController)
}

class ATMCodeViewController: UIViewController {

    var register: RegisterModel?
    
    @IBOutlet weak var firstPin: UILabel!
    @IBOutlet weak var secondPin: UILabel!
    @IBOutlet weak var thirdPin: UILabel!
    @IBOutlet weak var fourthPin: UILabel!
    
    var pin = ""
    var errors = ""
    weak var delegate:ATMCodeViewDelegate?
    
    class func createController() -> ATMCodeViewController{
        let storyboard = UIStoryboard(name: "ATMCode", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! ATMCodeViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"ATMCode" ])
    }

    private func setupView(){
        //set pin numbers //
        firstPin.text = ""
        secondPin.text = ""
        thirdPin.text = ""
        fourthPin.text = ""
        // set title //
        self.navigationItem.title = "Ingresa clave"
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
            self.delegate?.atmView(with: PinModel(pin:pin),and: self)
        }
        
    }
}
