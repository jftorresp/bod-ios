//
//  AddPaymentViewController.swift
//  catpay-ios
//
//  Created by Mobile iOS Development on 6/26/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import Crashlytics

class AddPaymentViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var banco: SearchTextField!
    @IBOutlet weak var monto: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var contactTxtField: CustomTextField!
    @IBOutlet weak var realizarpagoBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    
    var nameBanks:[String] = []
    var transsactionData = TransacctionModel()
    var mount = 0.000
    var contact: directoryModel?
    var savedContact: Bool?
    
    // implements protocol QRCoreReader
    lazy var readerVC: QRCodeReaderViewController = {
        
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        let vc = QRCodeReaderViewController(builder: builder)
        vc.delegate = self
        
        return vc
    }()
    
    class func createController() -> AddPaymentViewController {
        let storyboard = UIStoryboard(name: "AddPayment", bundle: nil)
        let addPaymentVC = storyboard.instantiateViewController(withIdentifier: "AddPayment") as! AddPaymentViewController
        return addPaymentVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelarBtn.addPaddingLeft()
        realizarpagoBtn.addPaddingRight()
        
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"AddPayment"])
        
        if savedContact == true {
            telefono.isEnabled = false
            contactTxtField.isEnabled = false
            telefono.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            contactTxtField.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        } else {
            telefono.isEnabled = true
            contactTxtField.isEnabled = true
        }
        
        if(MakePaymentDirectoryViewController.contactoDirectorio == true) {
            telefono.text = MakePaymentDetailViewController.selectedPhone
        } else {
            telefono.text = AddContactPaymentViewController.selectedPhone
        }
        
        contactTxtField.text = contact?.fullName
        descripcion.delegate = self
        
        setupView()
        setupForm()
    }
    
    private func setupView(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
        self.headerView.backgroundColor = .principalAppColor
    }
    
    private func setupForm() {
                
        self.scrollView.delegate = self
        
        //MARK: - TELEFONO
        // handler events for phoneNumber textField
        let button = UIButton()
        button.addTarget(self, action: #selector(self.clearNumberPhone(_:)), for: .touchDown)
        button.setImage(UIImage(named: "icEmptyPhone.png"), for: .normal)
        let view = UIView()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        telefono.rightView = view
        telefono.rightViewMode = .whileEditing
        telefono.clearButtonMode = .never
        
        //MARK: - BANK
        // get banks
        self.nameBanks = AppDelegate.bankAccounts.map({
            (value: banksModel) -> String in
            return value.name
        })
        
        // handlers events for BankUITextField
        self.banco.theme.bgColor = UIColor.white
        self.banco.startVisible = true
        self.banco.interactedWith = true
        self.banco.theme.font  = UIFont(name: "OpenSans" , size: 14.0)!
        self.banco.filterStrings(self.nameBanks)
        
        //MARK: - MONTO
        self.monto.addTarget(self, action: #selector(AddPaymentViewController.textFieldDidChange), for: .editingChanged)
        self.monto.text = UtilityMethods.formatCurency(number: mount)
        
        //MARK: - DESCRIPTION
        self.descripcion.addTarget(self, action: #selector(AddPaymentViewController.textFieldDidChange), for: .editingChanged)
        
        // gesture scrollView - scroll Gesture
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // Protocol scrollView //
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBalance()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    private func setBalance(){
        //Set balance //
        let balance = UtilityMethods.formatCurency(number:AppDelegate.balance)
        self.balance.text = balance
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
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height - 5, right: 0)
        scrollView.contentInset = contentInsets
    }
    
    func keyboardWillHide (notification:  Notification){
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // end protocol scrollView //
    
    @IBAction func phoneNumberLimitdigits(_ textField: UITextField) {
        let maxDigit = 11
        let NumberPhone = textField.text!
        
        if NumberPhone.count > maxDigit{
            let subString = String(NumberPhone.prefix(maxDigit))
            textField.text = subString
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField == self.monto {
            let string = textField.text!
            if let newMount = UtilityMethods.getDoubletoFormatCurrency(string: string){
                self.mount = newMount
            }
            
            textField.text = UtilityMethods.formatCurency(number: self.mount)
        }
        
        if textField == self.descripcion {
            let maxDigit = 40
            let string = textField.text!
            
            if string.count > maxDigit{
                let subString = String(string.prefix(maxDigit))
                textField.text = subString
            }
        }
    }
    
    // textfield telefono format
    @objc func clearNumberPhone(_ textField: UITextField){
            
        self.telefono.text = ""
        self.banco.text = ""
        self.mount = 0.000
        self.monto.text = UtilityMethods.formatCurency(number: self.mount)
        self.descripcion.text = ""
        self.transsactionData.recipient?.docType = ""
        self.transsactionData.recipient?.lastTwoDigitId = ""
        self.transsactionData.recipient?.name = ""
        self.transsactionData.recipient?.phoneNumber = ""
    }
        
    func setAccountInfo(docType: String, documentId:String, bank:String, fullName:String, phoneNumber: String){
        
        self.telefono.text = phoneNumber
        self.banco.text = bank
        
        self.transsactionData.recipient?.phoneNumber = phoneNumber
        self.transsactionData.recipient?.name = fullName
        //AQUI DEBERIA GUARDARSE EL BANCO en transsacctionData
        self.transsactionData.recipient?.docType = docType
        self.transsactionData.recipient?.lastTwoDigitId = documentId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelarPagoPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MakePaymentDirectory", bundle: nil)
        let makePaymentDirVC = storyboard.instantiateViewController(withIdentifier: "makePaymentDirectory") as? MakePaymentDirectoryViewController
        self.navigationController?.pushViewController(makePaymentDirVC!, animated: true)
        
    }
    
    @IBAction func RealizarPago(_ sender: Any) {
        
        if MakePaymentDirectoryViewController.contactoDirectorio == true {
            self.transsactionData.recipient?.phoneNumber = MakePaymentDetailViewController.selectedPhone!
            self.transsactionData.recipient?.name = (contact?.fullName)!
        } else {
            
            if savedContact == false {
                self.transsactionData.recipient?.name = contactTxtField.text!
                self.transsactionData.recipient?.phoneNumber = telefono.text!
            } else {
                self.transsactionData.recipient?.phoneNumber = AddContactPaymentViewController.selectedPhone!
                self.transsactionData.recipient?.name = (contact?.fullName)!
            }
        }
        
        self.transsactionData.recipient?.docType = (contact?.documentType)!
        self.transsactionData.recipient?.lastTwoDigitId = (contact?.documentId)!
        
        
        self.view.endEditing(true)
    
        //validation phone
        
        if(telefono.text?.count != 11 || telefono.text == ""){
                        
            let msg = NSLocalizedString("notification.userInvalid", comment: "Introduce un número telefónico válido (11 dígitos)")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Numero invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        

        // validation banco
        
        if(!checkBank()) {
            
            let msg = NSLocalizedString("notification.bank", comment: "Introduce un banco valido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Banco invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        // validation amount
        
        if mount == 0 {
            
            // cambiar msj
            let msg = NSLocalizedString("notification.mountEmpty", comment: " Introduce monto")
            let title = NSLocalizedString("notification.titleInvalid", comment: " ")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        //validation description
        
        if(descripcion.text == ""){
            
            let msg = NSLocalizedString("notification.conceptInvalid", comment: "Introduce un concepto de pago")
            let title = NSLocalizedString("notification.titleInvalid", comment: "Campo Vacío")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return
        }
        
        //validation account
        
        if transsactionData.recipient?.docType == "" || (transsactionData.recipient?.lastTwoDigitId)! == "" || (transsactionData.recipient?.phoneNumber)! == "" || (transsactionData.recipient?.name)! == "" {

            let msg = NSLocalizedString("notification.accountDoesntExist", comment: " Cuenta no existe")
            let title = NSLocalizedString("notification.titleInvalid", comment: " Cuenta no existe")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated:true,completion:nil)
            return

        }
        
        // validation status //
        if AppDelegate.status == "Inactivo" {
            
            let msg = NSLocalizedString("notification.inactiveUser", comment: "")
            let alert = UtilityMethods.createAlert(title: NSLocalizedString("notification.titleInvalid", comment: ""), message: [msg])
            self.present(alert, animated:true,completion:nil)
            return
            
        }
        
        // validData -- confirm Payment
        
        self.transsactionData.amount = self.mount
        self.transsactionData.description = self.descripcion.text!
        self.transsactionData.recipient?.phoneNumber = self.telefono.text!
        
        
        let paymentVerificationVC = PaymentVerificationViewController.createController(bank: self.banco.text!, transactionData: self.transsactionData)
        
        paymentVerificationVC.delegate = self
        self.present(paymentVerificationVC, animated: true)
    }
    
    func checkBank() -> Bool{
    
        let selectedBank = self.banco.text!
        let index = self.nameBanks.index(of: selectedBank)
        
        if index != nil {
            self.transsactionData.recipientAccountId = AppDelegate.bankAccounts[index!].id
            return true
        }
        
        return false
    }
    
    @IBAction func QRScan(_ sender: Any) {
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true)
        readerVC.applicationFinishedRestoringState()
    }
    
    func chargeData(data:String) {
        
        if let userData = SessionsModel(JSONString: data){
            // set params recipient in transaction Object //
            self.setAccountInfo(docType: userData.docType, documentId: userData.documentId, bank: userData.account!.name, fullName: userData.firstNames + " " + userData.lastNames, phoneNumber: userData.phoneNumber)
            let bankAccount = AppDelegate.bankAccounts.first { (bank) -> Bool in
                return bank.code == userData.account!.code
            }
            //set bank if exists
            if let bankName = bankAccount?.name {
                self.banco.text = bankName
            }
            // set amount if exists
            if let amountString = userData.amount {
                if let amount = Double(amountString){
                    self.mount = amount
                    self.monto.text = UtilityMethods.formatCurency(number: mount)
                }
            }
            // set description if exists
            if let qrDescript = userData.description {
                self.descripcion.text = qrDescript
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        
        var maxLength = 0
        
        if textField == descripcion {
            maxLength = 40
        }
        
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
        // make sure the result is under 40 characters
        return updatedText.count <= maxLength
      
    }

}

extension AddPaymentViewController: QRCodeReaderViewControllerDelegate{
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        
        if let data = AESMethods.decrypt(message: result.value){
            // QR Valid
            self.chargeData(data: data)
            
            let dataJ = Data(data.utf8)
            var nombre = ""
            var cedula = ""
            var tipoCed = ""
            var telefono = ""
            do {
                if let json = try JSONSerialization.jsonObject(with: dataJ, options : .allowFragments) as? Dictionary<String,Any>
                {
                    nombre = "\(json["firstNames"]!) \(json["lastNames"]!)"
                    cedula = json["documentId"] as! String
                    tipoCed = json["docType"] as! String
                    telefono = json["phoneNumber"] as! String
                    // use the json here
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
            let storyboard = UIStoryboard(name: "AddContactPayment", bundle: nil)
            let addContactPaymentVC = storyboard.instantiateViewController(withIdentifier: "addContactPayment") as? AddContactPaymentViewController
            addContactPaymentVC?.useQR = true
            addContactPaymentVC?.nombreQR = nombre
            addContactPaymentVC?.cedulaQR = cedula
            addContactPaymentVC?.tipoCedQR = tipoCed
            addContactPaymentVC?.telefonoQR = telefono
            self.navigationController?.pushViewController(addContactPaymentVC!, animated: true)
        }else{
            // QR Invalid
            let msg = NSLocalizedString("notification.invalidQR", comment: "QR invalido")
            let title = NSLocalizedString("notification.titleInvalid", comment: "QR invalido")
            let alert = UtilityMethods.createAlert(title: title , message:[msg])
            self.present(alert, animated: true)
        }

    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddPaymentViewController: PaymentVerificationViewDelegate{
   
    func paymentVerificationView(success: Bool) {
        
        if success{
            let atmVC = ATMCodeViewController.createController()
            atmVC.delegate = self
            self.navigationController?.pushViewController(atmVC, animated: true)
        }
    }
}

extension AddPaymentViewController: ATMCodeViewDelegate{
   
    func atmView(with pin: PinModel, and atmCodeViewController: ATMCodeViewController) {
        
        self.transsactionData.security = pin
        let storyboard = UIStoryboard(name: "ResultadoTransaccion", bundle: nil)
        let resultTransactionVC = storyboard.instantiateViewController(withIdentifier: "ResultadoTransaccion") as! ResultadoTransaccionViewController
        resultTransactionVC.transactionData = self.transsactionData
        resultTransactionVC.bankName = self.banco.text!
        self.navigationController?.pushViewController(resultTransactionVC, animated: true)
    }
}
