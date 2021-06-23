//
//  DirectoryViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 23/12/20.
//  Copyright © 2020 Technifiser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DirectoryViewController: UIViewController {
    
    /* Outlets */
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addContactBtn: UIButton!
    @IBOutlet weak var contactTableView: SelfSizedTableView!
    @IBOutlet weak var viewHeader: UIView!
    
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
    let profile = OAuthManager.shared.profile!
    var user: directoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.contactTableView.addSubview(self.activityIndicator)
                
        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(DirectoryViewController.reload), for: UIControlEvents.valueChanged)
        contactTableView.addSubview(refresh)
        
        searchBar.isTranslucent = true
        searchBar.delegate = self
        
        searchBar.backgroundColor = UIColor.white
        
        user = directoryModel(fullName: profile.firstNames + "  " + profile.lastNames, documentType: profile.docType, documentId: profile.documentId, phoneNumbers: [profile.phoneNumber])
        
        if directory?.count == 0 {
            contactTableView.separatorStyle = .none
        }
        
        contactTableView.separatorStyle = .none

        
//        shouldAdd()
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.activityIndicator.startAnimating()
        
        // load Directory
        
        Task.getDirectory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
            
            if Response != nil {
                
                let result = Response as? [directoryModel]
                let sorted = result?.sorted { $0.fullName!.lowercased() < $1.fullName!.lowercased() }
                self.directory = sorted

//                for i in 0...self.directory!.count {
//                    if self.directory![i].documentId == self.profile.documentId {
//                        usr = self.directory![i]
//                        self.directory?.remove(at: i)
//                    }
////                    self.directory?.insert(usr, at: 0)
//                }

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.contactTableView.reloadData()
                }
            }
        }
    }
    
    func addUser() {
        
        Task.addContact(parameters: user!) { (response) in
            
            print("successfully added user contact")
        }
    }
    
    func shouldAdd() {
        let add: Bool = UserDefaults.standard.bool(forKey: "addUser")
        if add == true  {
            addUser()
            UserDefaults.standard.set(false, forKey: "addUser")
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

//                var usr: directoryModel?
//                for i in 0...self.directory!.count {
//                    if self.directory![i].documentId == self.profile.documentId {
//                        usr = self.directory![i]
//                        self.directory?.remove(at: i)
//                    }
////                    self.directory?.insert(usr!, at: 0)
//                }
                
                DispatchQueue.main.async {
                    self.contactTableView.reloadData()
                }
            }
        }
        
    }
    
    /* Function that connects the navigation button to the Navigation ViewController */
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)

    }

    /* Function that goes to the addContact ViewController when pressed */
    @IBAction func addContactPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddContact", bundle: nil)
        let addContactVC = storyboard.instantiateViewController(withIdentifier: "AddContact") as? AddContactViewController
        self.navigationController?.pushViewController(addContactVC!, animated: true)
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension DirectoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if directory == nil || directory?.count == 0 {
            tableView.isScrollEnabled = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return 0
        }
        
        tableView.isScrollEnabled = true
        tableView.isHidden = false
        tableView.backgroundView?.isHidden = true
        
        if searchActive{
            return filteredData!.count
        }else{
            return (directory?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! contactTableViewCell
        
        let dataHistory = !self.searchActive  ? self.directory?[indexPath.row] : self.filteredData?[indexPath.row]
        
        cell.nombreContactoLabel.text = dataHistory?.fullName
        
//        // PAGINATION //
//        let lastElement = (directory?.count)! - 1
//        if indexPath.row == lastElement && lastElement > refreshElement {
//            print("last row")
//            self.page += 1
//
//            Task.getDirectory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
//
//                if Response != nil{
//
//                    let nextData = Response as? [directoryModel]
//
//                   self.directory! += nextData!
//                    DispatchQueue.main.async {
//
//                        self.contactTableView.reloadData()
//                    }
//                }
//            }
//
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DirectoryViewController.selectedContact = directory?[indexPath.row]
        
        let storyboard = UIStoryboard(name: "DetailContact", bundle: nil)
        let detailContactVC = storyboard.instantiateViewController(withIdentifier: "DetailContact") as? DetailContactViewController
        self.navigationController?.pushViewController(detailContactVC!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension DirectoryViewController: UISearchBarDelegate{

//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        openSearchBar()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
//        self.searchBar.text = ""
//        self.searchActive = false
//        DispatchQueue.main.async { self.contactTableView.reloadData() }
//    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
    
       DispatchQueue.main.async { self.contactTableView.reloadData() }
        

    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
