//
//  PaymentVerificationViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/26/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics

protocol PaymentVerificationViewDelegate: class {
    func paymentVerificationView(success:Bool)
}

class PaymentVerificationViewController: UIViewController {

    
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var banco: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var monto: UITextField!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var cancelarBtn: UIButton!
    @IBOutlet weak var confirmarBtn: UIButton!
    
    weak var delegate:PaymentVerificationViewDelegate?
    
    var bank = ""
    var transacctionData: TransacctionModel? = nil
    
    class func createController(bank:String,transactionData:TransacctionModel) -> PaymentVerificationViewController{
        let storyboard = UIStoryboard(name: "PaymentVerification", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()! as! PaymentVerificationViewController
        vc.transacctionData = transactionData
        vc.bank = bank
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelarBtn.addPaddingLeft()
        confirmarBtn.addPaddingRight()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentVerification"])
        
        UtilityMethods.openModal(view: self.view)
        
        descripcion.delegate = self
        descripcion.layer.cornerRadius = 5.0
        descripcion.layer.borderWidth = 0.5
        descripcion.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.telefono.text = transacctionData?.recipient?.phoneNumber
        self.banco.text = bank
        self.nombre.text = transacctionData?.recipient?.name
        self.monto.text = UtilityMethods.formatCurency(number: (transacctionData?.amount)!)
        self.descripcion.text = transacctionData?.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion:{
            self.delegate?.paymentVerificationView(success: false)
        })
    }
    
    @IBAction func confirmButton(_ sender: Any) {        
        self.dismiss(animated: true, completion:{
            self.delegate?.paymentVerificationView(success: true)
        })
    }

}

extension PaymentVerificationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == " ") {
            return false
        }
        
        let maxLength = 30
        let currentString: NSString = (textView.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
}
