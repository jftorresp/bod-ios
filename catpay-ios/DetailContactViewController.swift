//
//  DetailContactViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 23/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DetailContactViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var cedulaLabel: UILabel!
    @IBOutlet weak var phoneTableview: UITableView!
    
    @IBOutlet weak var eliminarBtn: UIButton!
    @IBOutlet weak var agregarBtn: UIButton!
    
    
    let refreshElement = 15
    var refresh = UIRefreshControl()
    var activityIndicator: NVActivityIndicatorView!
    static var selectedPhone: String?
    static var phoneIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupForm()
        
        phoneTableview.delegate = self
        phoneTableview.dataSource = self
        
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.phoneTableview.addSubview(self.activityIndicator)
        
        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(DetailContactViewController.reload), for: UIControlEvents.valueChanged)
        phoneTableview.addSubview(refresh)
    }
    
    var directoryData: directoryModel?
    
    override func viewDidAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        
        if let id = DirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                self.refresh.endRefreshing()
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    self.directoryData = response as? directoryModel
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.phoneTableview.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func reload() {
        
        // load Directory phones
        
        if let id = DirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                self.refresh.endRefreshing()
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    self.directoryData = response as? directoryModel
                    DispatchQueue.main.async {
                        self.phoneTableview.reloadData()
                    }
                    
                }
            }
        }
    }

    /* Setup the view for the navigation button above the banner view */
    private func setupView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
        viewHeader.backgroundColor = UIColor.principalAppColor
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
        eliminarBtn.titleEdgeInsets.left = 12
        agregarBtn.titleEdgeInsets.left = 12
    }
    
    /* Function that connects the navigation button to the Navigation ViewController */
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)
    }
    
    private func setupForm() {
        
        if let id = DirectoryViewController.selectedContact?.id {
            Task.getDirectoryById(refreshed: false, directoryId: id) { (response) in
                
                if response == nil { return }
                
                if response != nil && !(response is String) {
                
                    // response valid
                    self.directoryData = response as? directoryModel
                    
                    if let directoryCorrect = self.directoryData {
                        self.nombreLabel.text = directoryCorrect.fullName
                        self.cedulaLabel.text = "\(directoryCorrect.documentType!)-\(directoryCorrect.documentId!)"
                    }
                }
            }
        }
        
    }
    
    @IBAction func eliminarContacto(_ sender: Any) {
        
            let alertOne = UIAlertController(title: "", message: "¿Está seguro de eliminar este contacto?", preferredStyle: UIAlertControllerStyle.alert)
        
            self.present(alertOne, animated:true,completion:nil)

            
            alertOne.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                
                if let id = DirectoryViewController.selectedContact?.id {
                    
                    Task.deleteDirectory(directoryId: id) { (response) in
                        
                        let storyboard = UIStoryboard(name: "Directory", bundle: nil)
                        let directoryVC = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController
                        self.navigationController?.pushViewController(directoryVC!, animated: true)
                        
                        let alert = UtilityMethods.createAlert(title: "", message: ["Contacto eliminado satisfactoriamente."])
                        self.present(alert, animated:true,completion:nil)
                    }
                }
            }))

            alertOne.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
    }
    
    @IBAction func agregarTelefono(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "AddContactPhone", bundle: nil)
        let addPhonesVC = storyboard.instantiateViewController(withIdentifier: "AddPhones") as? AddContactPhoneViewController
        self.navigationController?.pushViewController(addPhonesVC!, animated: true)
    }
    
    @IBAction func modificarNombreCedula(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "EditContactInfo", bundle: nil)
        let editInfoVC = storyboard.instantiateViewController(withIdentifier: "EditInfo") as? EditContactInfoViewController
        self.navigationController?.pushViewController(editInfoVC!, animated: true)
    }
    
    
    @IBAction func irDirectorio(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Directory", bundle: nil)
        let directoryVC = storyboard.instantiateViewController(withIdentifier: "Directory") as? DirectoryViewController
        self.navigationController?.pushViewController(directoryVC!, animated: true)
    }
    
}

extension DetailContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((DirectoryViewController.selectedContact?.phoneNumbers?.count)! == 5) {
            agregarBtn.isEnabled = false
            agregarBtn.tintColor = UIColor(named: "Gray")
            agregarBtn.titleLabel?.textColor = UIColor(named: "Gray")
        } else {
            
            agregarBtn.isEnabled = true
            agregarBtn.tintColor = UIColor(named: "PrimaryColor")
            agregarBtn.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return (DirectoryViewController.selectedContact?.phoneNumbers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactPhoneCell", for: indexPath) as! contactPhonesTableViewCell
        
        let phone = DirectoryViewController.selectedContact?.phoneNumbers?[indexPath.row]
        
        cell.phoneNumberLabel.text = phone
        
        if ((DirectoryViewController.selectedContact?.phoneNumbers?.count)! <= 1) {
            cell.deletePhoneBtn.isHidden = true
        } else {
        cell.deletePhoneBtn.isHidden = false
        }
        
        cell.editPhone = { [unowned self] in
            DetailContactViewController.selectedPhone = DirectoryViewController.selectedContact?.phoneNumbers?[indexPath.row]
            DetailContactViewController.phoneIndex = indexPath.row
            
            let storyboard = UIStoryboard(name: "EditContactPhone", bundle: nil)
            let editPhonesVC = storyboard.instantiateViewController(withIdentifier: "EditPhones") as? EditContactPhoneViewController
            self.navigationController?.pushViewController(editPhonesVC!, animated: true)
        }
        
        
        cell.deletePhone = { [unowned self] in
            DetailContactViewController.selectedPhone = DirectoryViewController.selectedContact?.phoneNumbers?[indexPath.row]
            DetailContactViewController.phoneIndex = indexPath.row
            
            let alert = UIAlertController(title: "", message: "¿Estás seguro que quieres eliminar este teléfono?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                
                if let id = DirectoryViewController.selectedContact?.id {
                    
                    DirectoryViewController.selectedContact?.phoneNumbers?.remove(at: indexPath.row)
                    
                    Task.updateDirectoryPhones(refreshed: false, directoryId: id, phoneNumbers: (DirectoryViewController.selectedContact?.phoneNumbers)!) { (response) in
                        
                        DispatchQueue.main.async {
                            phoneTableview.reloadData()
                        }
                    }
                    
                    let alert = UtilityMethods.createAlert(title: "", message: ["Teléfono eliminado satisfactoriamente"])
                    self.present(alert, animated:true,completion:nil)
                }
            }))

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated:true,completion:nil)
        }
        
        return cell
    }
}
