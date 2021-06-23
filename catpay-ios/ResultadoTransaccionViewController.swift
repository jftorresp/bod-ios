//
//  ResultadoTransaccionViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/30/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Crashlytics

class ResultadoTransaccionViewController: UIViewController {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var bank: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var makeNewPaymentButton: UIButton!
    @IBOutlet weak var compartirBtn: UIButton!
    
    @IBOutlet weak var numRefLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var clientePagadorLabel: UILabel!
    
    
    @IBOutlet weak var numRefStack: UIStackView!
    @IBOutlet weak var clienteStack: UIStackView!
    @IBOutlet weak var telefonoStack: UIStackView!
    @IBOutlet weak var bancoStack: UIStackView!
    @IBOutlet weak var montoStack: UIStackView!
    @IBOutlet weak var descripStack: UIStackView!
    @IBOutlet weak var fechaStack: UIStackView!
    @IBOutlet weak var clientePagadorStack: UIStackView!
    
    var transactionData: TransacctionModel? = nil
    var bankName = ""
    var activityIndicator: NVActivityIndicatorView!
    
    var failColor: UIColor = UIColor(red:0.93, green:0.17, blue:0.16, alpha:1.0)
    var successColor: UIColor = UIColor(red:0.00, green:0.73, blue:0.23, alpha:1.0)
    var loadingColor: UIColor = UIColor(red:0.00, green:0.27, blue:0.09, alpha:1.0)
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidDisappear(_ animated: Bool) {
        notificationCenter.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numRefStack.isHidden = true
        compartirBtn.isHidden = true
        fechaStack.isHidden = true
        clientePagadorStack.isHidden = true
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"TransactionResult"])
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Transacción"
        phoneNumber.text = transactionData?.recipient?.phoneNumber
        bank.text = bankName
        fullName.text = transactionData?.recipient?.name
        amount.text = UtilityMethods.formatCurency(number: (transactionData?.amount)!)
        descrip.text = transactionData?.description
        
        // proccess transaction
        
        // config animation progress //
        
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: (stateView.frame.height / 2) - 15, width: 30, height: 30)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: UIColor.white, padding: 0)
        
        self.stateView.addSubview(self.activityIndicator)
        
        // loading animation
        
        stateView.backgroundColor = loadingColor
        stateLabel.isHidden = true
        activityIndicator.startAnimating()
        makeNewPaymentButton.alpha = 0
        Task.transactionTask(refreshed: true, params: transactionData!, completion: { (Response) in
            
            // set backButton //
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"icCancel"), style: .plain, target: self, action: #selector(self.closeButton))
            
            // set visible makeNewPaymentButton //
            self.makeNewPaymentButton.alpha = 1

          // stop animation
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.stateLabel.isHidden = false
            
            if Response == nil{
                // session expired
                self.stateView.backgroundColor = self.failColor
                self.stateLabel.text = "Servicio no disponible, por favor intente más tarde"
                return
            }
            
            if !(Response is String)  {
                
                // transactionTask 200 OK
                let transactionData = Response as! PaymentHistoryModel
                
                if transactionData.succeeded{
                
                    self.numRefStack.isHidden = false
                    self.telefonoStack.isHidden = true
                    self.fechaStack.isHidden = false
                    self.clientePagadorStack.isHidden = false
                    self.compartirBtn.isHidden = false
                    
                    self.numRefLabel.text = transactionData.operationId
                    self.clientePagadorLabel.text = transactionData.payer?.name
                    self.fechaLabel.text = UtilityMethods.format_date(fecha: (transactionData.created))

                    self.stateView.backgroundColor = UtilityMethods.getBackgroundColor()
                    transactionData.feedBack = NSLocalizedString("notification.transactionTrue", comment: " ")
                    self.stateLabel.text = transactionData.feedBack
                    self.stateLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
                    return
                }
                
                // transaction rechazada
                self.stateView.backgroundColor = self.failColor
                self.stateLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
                self.stateLabel.text = transactionData.feedBack
                
            }else{
                
                // error in transaction
                self.stateView.backgroundColor = self.failColor
                self.stateLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
                
                if let forbiddenStatus = Response as? String,
                    forbiddenStatus == "Forbidden" {
                    self.stateLabel.text = NSLocalizedString("notification.transactionForbidden", comment: "")
                    return
                }
                
                self.stateLabel.text = "TRANSACCIÓN RECHAZADA"
                
                // push window modal
                let myAlert = NotificationErrorViewController.createController(errors: Response as! String)
                self.present(myAlert, animated: true)
            
            }
        })
    }
    
    @IBAction func compartirPagoPressed(_ sender: Any) {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
                
        var imagesToShare = [Any]()
        imagesToShare.append(image!)
        
        let activityController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: .UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appMovedToBackground() {
        let storyboard = UIStoryboard(name: "MakePaymentEmpty", bundle: nil)
        let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "MakePayMent") as? MakePayMentViewController
        self.navigationController?.pushViewController(makePaymentVC!, animated: true)
    }
    
    @IBAction func addNewPayment(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "MakePaymentDirectory", bundle: nil)
        let makePaymentVC = storyboard.instantiateViewController(withIdentifier: "makePaymentDirectory") as! MakePaymentDirectoryViewController
        self.navigationController?.pushViewController(makePaymentVC, animated: true)
    }
    
    @objc func closeButton() {
        if let navCont = self.navigationController {
            self.navigationController?.popToViewController( navCont.viewControllers[1], animated: true)
        }    }

}
