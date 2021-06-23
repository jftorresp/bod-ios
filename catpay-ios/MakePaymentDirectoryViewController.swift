//
//  ScanQRCodeViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 28/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import QRCodeReader

class MakePaymentDirectoryViewController: UIViewController {
    
    @IBOutlet weak var saldoDisponibleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: SelfSizedTableView!    
    
    /* Attributes */
    var directory: [directoryModel]? = nil
    var filteredData: [directoryModel]?
    var searchActive : Bool = false
    var page = 0
    let pageSize = 300
    let refreshElement = 300
    var refresh = UIRefreshControl()
    var filtered = false
    var activityIndicator: NVActivityIndicatorView!
    static var selectedContact: directoryModel?
    static var contactoDirectorio: Bool?
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.tableView.addSubview(self.activityIndicator)
                
        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(DirectoryViewController.reload), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        
        searchBar.isTranslucent = true
        searchBar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.activityIndicator.startAnimating()

        // load Directory
        
        Task.getDirectory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
            
            if Response != nil {
                
                let result = Response as? [directoryModel]
                let sorted = result?.sorted { $0.fullName!.lowercased() < $1.fullName!.lowercased() }
                self.directory = sorted
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBalance()
    }
    
    private func setBalance(){
        //Set balance //
        let balance = UtilityMethods.formatCurency(number:AppDelegate.balance)
        self.saldoDisponibleLabel.text =  balance
    }
    
    func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            searchBar.inputAccessoryView = doneToolbar
        }
    
    @objc func doneButtonAction() {
        searchBar.resignFirstResponder()
        tableView.isHidden = false
    }
    
    @objc func reload() {
        
        // load Directory
        self.page = 0
        Task.getDirectory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
            
            self.refresh.endRefreshing()
            
            if Response != nil {
                
                let result = Response as? [directoryModel]
                let sorted = result?.sorted { $0.fullName!.lowercased() < $1.fullName!.lowercased() }
                self.directory = sorted
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func realizarPagosPressed(_ sender: Any) {
        
    }
    
    @IBAction func agregarContactoPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "AddContactPayment", bundle: nil)
        let addContactPaymentVC = storyboard.instantiateViewController(withIdentifier: "addContactPayment") as? AddContactPaymentViewController
        MakePaymentDirectoryViewController.contactoDirectorio = false
        self.navigationController?.pushViewController(addContactPaymentVC!, animated: true)
        
    }
    
    @IBAction func escanearQRPressed(_ sender: Any) {
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true)
        readerVC.applicationFinishedRestoringState()
    }

}

//MARK: - UITableViewDelegate and UITableViewDataSource Methods

extension MakePaymentDirectoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if directory == nil || directory?.count == 0 {
            tableView.isScrollEnabled = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return 0
        }
        
        tableView.isScrollEnabled = true
        tableView.backgroundView?.isHidden = true
        
        if searchActive{
            return filteredData!.count
        }else{
            return (directory?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellPayment", for: indexPath) as! contactPaymentTableViewCell
        
        let dataHistory = !self.searchActive  ? self.directory?[indexPath.row] : self.filteredData?[indexPath.row]
        
        cell.nombreLabel.text = dataHistory?.fullName

        // PAGINATION //
        let lastElement = (directory?.count)! - 1
        if indexPath.row == lastElement && lastElement > refreshElement {
            print("last row")
            self.page += 1

            Task.getDirectory(refreshed: false, page: page, pageSize: pageSize) { (Response) in

                if Response != nil{

                    let nextData = Response as? [directoryModel]

                   self.directory! += nextData!
                    DispatchQueue.main.async {

                        self.tableView.reloadData()
                    }
                }
            }

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive {
            MakePaymentDirectoryViewController.selectedContact = filteredData?[indexPath.row]
        } else {
            MakePaymentDirectoryViewController.selectedContact = directory?[indexPath.row]
        }
        
        let storyboard = UIStoryboard(name: "MakePaymentDetail", bundle: nil)
        let makePaymentDetailVC = storyboard.instantiateViewController(withIdentifier: "makePaymentDetail") as? MakePaymentDetailViewController
        MakePaymentDirectoryViewController.contactoDirectorio = true
        self.navigationController?.pushViewController(makePaymentDetailVC!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

extension MakePaymentDirectoryViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tableView.isHidden = false
        
        if searchText.count != 0 {
        
            if let data = (self.directory?.filter (
            
                {
                    (
                        $0.fullName!.lowercased().contains(searchText.lowercased())
                    )
                }
                )){
            
                self.filteredData = data
            
            }
        self.searchActive = true
        
        }else{
            
            self.searchActive = false
        }
    
       DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
}

extension MakePaymentDirectoryViewController: QRCodeReaderViewControllerDelegate {
    
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
