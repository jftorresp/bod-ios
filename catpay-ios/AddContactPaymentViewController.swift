//
//  AddContactPaymentViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 13/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit
import QRCodeReader

class AddContactPaymentViewController: UIViewController {
    
    
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var nombreTxtField: UITextField!
    @IBOutlet weak var cedulaTxtField: UITextField!
    @IBOutlet weak var telefonoTxtField: UITextField!
    @IBOutlet weak var tipoCedulaTxtField: UITextField!
    @IBOutlet weak var tipoCedulaBtn: UIButton!
    
    let picker = UIPickerView()
    var pickerData = ["V","J","E","P","M"]
    var dataPicker: String = ""
    let regexValidationDocumentId = "^[0-9]*$"
    var dirModel: directoryModel?
    static var selectedPhone: String?
    
    var useQR: Bool = false
    var nombreQR: String?
    var cedulaQR: String?
    var tipoCedQR: String?
    var telefonoQR: String?
    
    // implements protocol QRCoreReader
    lazy var readerVC: QRCodeReaderViewController = {
        
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        let vc = QRCodeReaderViewController(builder: builder)
        vc.delegate = self
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        tipoCedulaBtn.layer.cornerRadius = 5
        
        picker.dataSource = self
        picker.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()
        
        if useQR == true {
            nombreTxtField.text = nombreQR
            cedulaTxtField.text = cedulaQR
            tipoCedulaTxtField.text = tipoCedQR
            telefonoTxtField.text = telefonoQR
        }

    }
    
    private func setBalance() {
        //Set balance //
        let balance = UtilityMethods.formatCurency(number:AppDelegate.balance)
        self.saldoLabel.text =  balance
    }
    
    func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            nombreTxtField.inputAccessoryView = doneToolbar
            cedulaTxtField.inputAccessoryView = doneToolbar
            tipoCedulaTxtField.inputAccessoryView = doneToolbar
            telefonoTxtField.inputAccessoryView = doneToolbar

        }

    
    @objc func doneButtonAction() {
        nombreTxtField.resignFirstResponder()
        cedulaTxtField.resignFirstResponder()
        tipoCedulaTxtField.resignFirstResponder()
        telefonoTxtField.resignFirstResponder()
    }
    
    func setupView() {
        
        self.cedulaTxtField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        tipoCedulaTxtField.inputView = picker
        tipoCedulaTxtField.text = pickerData[0]
        
        let backButton = UIBarButtonItem()
        backButton.title = "Realizar Pagos"
        self.navigationItem.backBarButtonItem = backButton
    }
    
    //MARK: - IBActions for the interface
    
    @IBAction func escanearQRPressed(_ sender: Any) {
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true)
        readerVC.applicationFinishedRestoringState()
    }
    
    @IBAction func tipoCedulaPressed(_ sender: Any) {
        
        self.tipoCedulaTxtField.becomeFirstResponder()
    }
    
    @IBAction func continuarSinGuardarPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "AddPayment", bundle: nil)
        let makePaymentPhoneVC = storyboard.instantiateViewController(withIdentifier: "AddPayment") as? AddPaymentViewController
        AddContactPaymentViewController.selectedPhone = telefonoTxtField.text!
        let data = directoryModel(fullName: nombreTxtField.text!, documentType: tipoCedulaTxtField.text!, documentId: cedulaTxtField.text!, phoneNumbers: [telefonoTxtField.text!])
        makePaymentPhoneVC?.contact = data
        makePaymentPhoneVC?.savedContact = false
        self.navigationController?.pushViewController(makePaymentPhoneVC!, animated: true)
    }
    
    @IBAction func continuarGuardarPressed(_ sender: Any) {
        
        if nombreTxtField.text! == "" || tipoCedulaTxtField.text! == "" || cedulaTxtField.text! == "" || telefonoTxtField.text! == "" {
            
            let alert = UtilityMethods.createAlert(title: "Opción inválida", message: ["Por favor llena todos los campos antes de guardar"])
            self.present(alert, animated:true,completion:nil)
        } else {
            
            let data = directoryModel(fullName: nombreTxtField.text!, documentType: tipoCedulaTxtField.text!, documentId: cedulaTxtField.text!, phoneNumbers: [telefonoTxtField.text!])
            
            self.dirModel = data
            
            guard let dir = self.dirModel else {
                return
            }
            
            Task.addContact(parameters: dir) { (response) in
                
                if response is String {
                    let dataResponse = UtilityMethods.convertToDictionary(text: response as! String)
                    
                    if let dataError = dataResponse?["message"] as? String {
                        
                        if (dataError == "Contacto ya existe") {

                            let alert = UtilityMethods.createAlert(title: "¡Atención!", message: ["Un contacto con esos datos ya existe"])
                            self.present(alert, animated:true,completion:nil)
                        } else if (dataError == "Bad Request") {
                            
                            let alert = UtilityMethods.createAlert(title: "¡Atención!", message: ["El teléfono debe tener 11 dígitos"])
                            self.present(alert, animated:true,completion:nil)
                        }
                    }
                } else if (response is directoryModel) {
                    print("successfully added contact")
                    
                    self.dirModel = data
                    
                    let storyboard = UIStoryboard(name: "AddPayment", bundle: nil)
                    let makePaymentPhoneVC = storyboard.instantiateViewController(withIdentifier: "AddPayment") as? AddPaymentViewController
                    AddContactPaymentViewController.selectedPhone = self.telefonoTxtField.text!
                    makePaymentPhoneVC?.contact = self.dirModel
                    makePaymentPhoneVC?.savedContact = true
                    self.navigationController?.pushViewController(makePaymentPhoneVC!, animated: true)
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField:UITextField) {
    
        let doctype = self.tipoCedulaTxtField.text!
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
}

//MARK: - UIPickerViewDelegate and UIPickerViewDataSource methods

extension AddContactPaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipoCedulaTxtField.text = pickerData[row]
        self.cedulaTxtField.text = ""
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

//MARK: - QRCodeReaderDelegate methods

extension AddContactPaymentViewController: QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        
        if let data = AESMethods.decrypt(message: result.value){
            // QR Valid
            
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
