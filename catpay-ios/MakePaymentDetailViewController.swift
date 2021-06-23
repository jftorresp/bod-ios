//
//  MakePaymentDetailViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 28/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MakePaymentDetailViewController: UIViewController {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var cedulaLabel: UILabel!
    @IBOutlet weak var phoneTableView: UITableView!
    
    let refreshElement = 15
    var refresh = UIRefreshControl()
    var activityIndicator: NVActivityIndicatorView!
    static var directoryData: directoryModel?
    static var selectedPhone: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupForm()
        
        phoneTableView.delegate = self
        phoneTableView.dataSource = self
        
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.phoneTableView.addSubview(self.activityIndicator)
        
        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(MakePaymentDirectoryViewController.reload), for: UIControlEvents.valueChanged)
        phoneTableView.addSubview(refresh)
    }
    
    private func setupForm() {
        
        if let id = MakePaymentDirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    MakePaymentDetailViewController.directoryData = response as? directoryModel
                    
                    if let directoryCorrect = MakePaymentDetailViewController.directoryData {
                        self.contactNameLabel.text = directoryCorrect.fullName
                        self.cedulaLabel.text = "\(directoryCorrect.documentType!)-\(directoryCorrect.documentId!)"
                    }
                }
            }
        }
        
    }
    
    @objc func reload() {
        
        // load Directory phones
        
        if let id = MakePaymentDirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                self.refresh.endRefreshing()
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    MakePaymentDetailViewController.directoryData = response as? directoryModel
                    DispatchQueue.main.async {
                        self.phoneTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        
        if let id = MakePaymentDirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                self.refresh.endRefreshing()
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    MakePaymentDetailViewController.directoryData = response as? directoryModel
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.phoneTableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func escanearQRPressed(_ sender: Any) {
        
    }
    
    @IBAction func vovlerPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MakePaymentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (MakePaymentDirectoryViewController.selectedContact?.phoneNumbers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactPhonePaymentCell", for: indexPath) as! contactPhonesPaymentTableViewCell
        
        let phone = MakePaymentDirectoryViewController.selectedContact?.phoneNumbers?[indexPath.row]
        
        cell.phoneLabel.text = phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MakePaymentDetailViewController.selectedPhone = MakePaymentDirectoryViewController.selectedContact?.phoneNumbers?[indexPath.row]
        
        let storyboard = UIStoryboard(name: "AddPayment", bundle: nil)
        let makePaymentPhoneVC = storyboard.instantiateViewController(withIdentifier: "AddPayment") as? AddPaymentViewController
        
        makePaymentPhoneVC?.contact = MakePaymentDetailViewController.directoryData
        makePaymentPhoneVC?.savedContact = true
        
        self.navigationController?.pushViewController(makePaymentPhoneVC!, animated: true)
    }
}
