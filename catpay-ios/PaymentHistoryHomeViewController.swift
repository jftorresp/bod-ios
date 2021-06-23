//
//  PaymentHistoryHomeViewController.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 1/05/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import NVActivityIndicatorView
import  Crashlytics

class PaymentHistoryHomeViewController: UIViewController {
    
    
    @IBOutlet weak var myTable: UITableView!
    //    lazy var searchBar : UISearchBar  = {
//        let search = UISearchBar()
//        search.barStyle = UIBarStyle.default
//        search.showsCancelButton = true
//        search.isTranslucent = true
//        search.delegate = self
//
//        if let textFieldInsideSearchBar = search.value(forKey: "searchField") as? UITextField,
//            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
//            textFieldInsideSearchBar.textColor = UIColor.white
//        }
//
//        return search
//    }()
    
    var paymentHistory: [PaymentHistoryModel]? = nil
//    var filtered:[PaymentHistoryModel]? = []
    
    var page = 0
    let pageSize = 15
    let refreshElement = 15
//    var searchActive : Bool = false
    var refresh = UIRefreshControl()
    var phoneNumber = ""
    var isFullController = false
    var activityIndicator: NVActivityIndicatorView!
    
    
    class func createController() -> PaymentHistoryHomeViewController{
        let storyboard = UIStoryboard(name: "PaymentHistoryHome", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! PaymentHistoryHomeViewController
        controller.isFullController = true
        return controller
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentHistory" ])
        
        // config image emtpy table view //
        let myView =  Bundle.main.loadNibNamed("emptyTableView", owner: self, options: nil)?[0] as! UIView
        myTable.backgroundView = myView
        
        //
        let profile = OAuthManager.shared.profile!
        phoneNumber = profile.phoneNumber
        
        // config animation for lazy load //
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.myTable.addSubview(self.activityIndicator)
        self.myTable.backgroundView?.isHidden = true

        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(PaymentHistoryViewController.reload), for: UIControlEvents.valueChanged)
        myTable.addSubview(refresh)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        // load paymentHistory //
        
        self.activityIndicator.startAnimating()
        self.myTable.backgroundView?.isHidden = true
        
        Task.paymentHistory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
        
            if Response != nil{
                
                self.paymentHistory = Response as? [PaymentHistoryModel]
                
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.myTable.backgroundView?.isHidden = false
                    self.myTable.reloadData()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        if isFullController {
//            self.closeSearchBar()
//        }
    }
    
    private func setupView(){
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.openSearchBar))
        
//        if #available(iOS 11.0, *) {
//            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        }
//
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named:"icDrawer"),
            style: .plain,
            target: self,
            action: #selector(self.navigation)
        )
        
//        viewHeader.backgroundColor = UIColor.principalAppColor
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }
    
    /* Function that connects the navigation button to the Navigation ViewController */
    @objc func navigation() {
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "Navigation") as! NagivationViewController
        self.navigationController?.pushViewController(navigationVC, animated: true)

    }
    
    @objc func reload(){
        
        self.page = 0
        Task.paymentHistory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
            
            self.refresh.endRefreshing()
            
            if Response != nil{
                
                self.paymentHistory = Response as? [PaymentHistoryModel]
                                
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueDetails" {
            // Setup new view controller
            let destination = segue.destination as! PaymentDetailsViewController
            let aux = sender as! PaymentHistoryModel
            destination.details = aux
        }
    }
}


extension PaymentHistoryHomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if paymentHistory == nil || paymentHistory?.count == 0 {
            tableView.isScrollEnabled = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }
        
        tableView.isScrollEnabled = true
        tableView.isHidden = false
        tableView.backgroundView?.isHidden = true
        
//        if searchActive{
//            return filtered!.count
//        }else{
//            return (paymentHistory?.count)!
//        }

        return (paymentHistory?.count)!
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! historyTableViewCell
        
        let dataHistory = self.paymentHistory?[indexPath.row]
//        let dataHistory = !self.searchActive  ? self.paymentHistory?[indexPath.row] : self.filtered?[indexPath.row]
        
        if (dataHistory?.succeeded)!  {
            dataHistory?.feedBack = NSLocalizedString("notification.transactionTrueInHistory", comment: " ")
        }
        
        cell.state.text = dataHistory?.feedBack
        cell.date.text = UtilityMethods.format_date(fecha: (dataHistory?.created)!)
        var accountId = 0

        if dataHistory?.payer?.phoneNumber == self.phoneNumber {
            
            // Pago Enviado
            dataHistory?.referencesHistoryName = (dataHistory?.recipient?.name)!
            let send = NSLocalizedString("notification.youSent", comment: " ")
            cell.concept.text = send
            cell.mount.textColor = UIColor.red
            cell.name.text = dataHistory?.referencesHistoryName
            let mountString = UtilityMethods.formatCurency(number: Double((dataHistory?.amount)!))
            let mountSplit = mountString.split(separator: ".")
            cell.mount.text = "\(mountSplit[0]). -\(mountSplit[1])"
            
            accountId = (dataHistory?.recipientAccountId)!

        } else {
            
            // Pago recibido
            dataHistory?.referencesHistoryName = (dataHistory?.payer?.name)!
            let received = NSLocalizedString("notification.sentYou", comment: " ")
            cell.concept.text = received
            cell.mount.textColor = UtilityMethods.getBackgroundColor()
            cell.name.text = dataHistory?.referencesHistoryName
            cell.mount.text = "\(UtilityMethods.formatCurency(number: Double((dataHistory?.amount)!)))"
            
            accountId = (dataHistory?.senderAccountId)!
        }
        
        // set bankAccount
        for bank in AppDelegate.bankAccounts {
            if bank.id == accountId {
               dataHistory!.nameBank = bank.name
            }
        }
                 
         // PAGINATION //
         let lastElement = (paymentHistory?.count)! - 1
         if indexPath.row == lastElement && lastElement > refreshElement {
             print("last row")
             self.page += 1
             
             Task.paymentHistory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
                 
                 if Response != nil{
                     
                     let nextData = Response as? [PaymentHistoryModel]
                  
                    self.paymentHistory! += nextData!
                     DispatchQueue.main.async {
                         
                         self.myTable.reloadData()
                     }
                 }
             }
             
         }
        
         return cell
     }
     
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let dataHistory = self.paymentHistory?[indexPath.row]
//         let dataHistory = !self.searchActive ? self.paymentHistory?[indexPath.row] : self.filtered?[indexPath.row]
         
         let storyboard = UIStoryboard(name: "TransferSend", bundle: nil)
         let detailsVC = storyboard.instantiateViewController(withIdentifier: "TransferSend") as! PaymentDetailsViewController
         detailsVC.details = dataHistory
         self.navigationController?.pushViewController(detailsVC, animated: true)
         tableView.deselectRow(at: indexPath, animated: true)
     }
    
}

//extension PaymentHistoryViewController: UISearchBarDelegate{
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        openSearchBar()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        closeSearchBar()
//        self.searchBar.endEditing(true)
//        self.searchBar.text = ""
//        self.searchActive = false
//        DispatchQueue.main.async { self.mytable.reloadData() }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchText.count != 0{
//
//            if let data = (self.paymentHistory?.filter(
//
//                {
//                    (
//                        $0.referencesHistoryName.contains(searchText) ||
//                        $0.nameBank.contains(searchText) ||
//                        $0.description.contains(searchText) ||
//                        $0.feedBack.contains(searchText) ||
//                        $0.operationId.contains(searchText) ||
//                        String(describing: $0.amount).contains(searchText)
//
//                    )
//
//                }
//                )){
//
//                self.filtered = data
//
//            }
//        self.searchActive = true
//
//        }else{
//
//            self.searchActive = false
//        }
//
//       DispatchQueue.main.async { self.mytable.reloadData() }
//    }
//}

