//
//  PaymentHistoryViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import KeychainSwift
import NVActivityIndicatorView
import  Crashlytics

class PaymentHistoryViewController: UIViewController {
    
    @IBOutlet weak var ingresosBtn: UIButton!
    @IBOutlet weak var egresosBtn: UIButton!
    @IBOutlet weak var opFallidasBtn: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var mytable: UITableView!
    
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
    var ingresosHistory: [PaymentHistoryModel]? = []
    var egresosHistory:  [PaymentHistoryModel]? = []
    var fallidasHistory:  [PaymentHistoryModel]? = []
    var ingresosPressed = true
    var egresosPressed = true
    var fallidasPressed = true
    
    
    var page = 0
    let pageSize = 15
    let refreshElement = 15
//    var searchActive : Bool = false
    var refresh = UIRefreshControl()
    var phoneNumber = ""
    var isFullController = false
    var activityIndicator: NVActivityIndicatorView!
    
    
    class func createController() -> PaymentHistoryViewController{
        let storyboard = UIStoryboard(name: "PaymentHistory", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! PaymentHistoryViewController
        controller.isFullController = true
        return controller
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"PaymentHistory" ])
        
        // config image emtpy table view //
        let myView =  Bundle.main.loadNibNamed("emptyTableView", owner: self, options: nil)?[0] as! UIView
        mytable.backgroundView = myView
        
        //
        let profile = OAuthManager.shared.profile!
        phoneNumber = profile.phoneNumber
        
        // config animation for lazy load //
        let frame =  CGRect(x: (UIScreen.main.bounds.width / 2) - 15 , y: 10, width: 30, height: 30)
        
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UtilityMethods.getBackgroundColor(), padding: 0)
        
        self.mytable.addSubview(self.activityIndicator)
        self.mytable.backgroundView?.isHidden = true

        // autoRefresh //
        let notification = NSLocalizedString("notification.loading", comment: "get Type Error")
        refresh.attributedTitle = NSAttributedString(string: notification)
        
        refresh.addTarget(self, action: #selector(PaymentHistoryViewController.reload), for: UIControlEvents.valueChanged)
        mytable.addSubview(refresh)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        // load paymentHistory //
        
        self.activityIndicator.startAnimating()
        self.mytable.backgroundView?.isHidden = true
        
        Task.paymentHistory(refreshed: false, page: page, pageSize: pageSize) { (Response) in
        
            if Response != nil{
                
                self.paymentHistory = Response as? [PaymentHistoryModel]
                self.ingresosHistory = []
                self.egresosHistory = []
                self.fallidasHistory = []
                
                for i in 0..<self.paymentHistory!.count {
                    
                    if self.paymentHistory![i].succeeded == false {
                        self.fallidasHistory?.append(self.paymentHistory![i])
                    } else {
                        if self.paymentHistory![i].payer?.phoneNumber != self.phoneNumber {
                            self.ingresosHistory?.append(self.paymentHistory![i])
                        } else if self.paymentHistory![i].payer?.phoneNumber == self.phoneNumber {
                            self.egresosHistory?.append(self.paymentHistory![i])
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.mytable.backgroundView?.isHidden = false
                    self.mytable.reloadData()
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
                self.ingresosHistory = []
                self.egresosHistory = []
                self.fallidasHistory = []
                
                for i in 0..<self.paymentHistory!.count {
                    
                    if self.paymentHistory![i].succeeded == false {
                        self.fallidasHistory?.append(self.paymentHistory![i])
                    } else {
                        if self.paymentHistory![i].payer?.phoneNumber != self.phoneNumber {
                            self.ingresosHistory?.append(self.paymentHistory![i])
                        } else if self.paymentHistory![i].payer?.phoneNumber == self.phoneNumber {
                            self.egresosHistory?.append(self.paymentHistory![i])
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.mytable.reloadData()
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
        
//        if segue.identifier == "backSegue"{
//            closeSearchBar()
//        }
    }
    

    
//    @objc func openSearchBar(){
//        
//        self.navigationItem.titleView = self.searchBar
//        self.searchBar.becomeFirstResponder()
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.navigationItem.rightBarButtonItem = nil
//    }

//    func closeSearchBar (){
//
//        self.searchBar.text = ""
//        self.searchActive = false
//        self.searchBar.resignFirstResponder()
//        self.navigationItem.titleView = nil
//        self.navigationItem.setHidesBackButton(false, animated: true)
//        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.openSearchBar))
//
//    }
    
    @IBAction func ingresosPressed(_ sender: Any) {
        ingresosPressed = true
        egresosPressed = false
        fallidasPressed = false
        
        DispatchQueue.main.async {
            
            self.ingresosBtn.setTitleColor(UIColor.principalAppColor, for: .normal)
            self.ingresosBtn.backgroundColor = .white
            self.egresosBtn.setTitleColor(.white, for: .normal)
            self.egresosBtn.backgroundColor = UIColor.principalAppColor
            self.opFallidasBtn.setTitleColor(.white, for: .normal)
            self.opFallidasBtn.backgroundColor = UIColor.principalAppColor
            self.mytable.reloadData()
        }
    }
    
    @IBAction func egresosPressed(_ sender: Any) {
        ingresosPressed = false
        egresosPressed = true
        fallidasPressed = false
        
        DispatchQueue.main.async {
            
            self.egresosBtn.setTitleColor(UIColor.principalAppColor, for: .normal)
            self.egresosBtn.backgroundColor = .white
            self.ingresosBtn.setTitleColor(.white, for: .normal)
            self.ingresosBtn.backgroundColor = UIColor.principalAppColor
            self.opFallidasBtn.setTitleColor(.white, for: .normal)
            self.opFallidasBtn.backgroundColor = UIColor.principalAppColor
            self.mytable.reloadData()
        }
    }
    
    @IBAction func opFallidasPressed(_ sender: Any) {
        ingresosPressed = false
        egresosPressed = false
        fallidasPressed = true
        
        DispatchQueue.main.async {
            
            self.opFallidasBtn.setTitleColor(UIColor.principalAppColor, for: .normal)
            self.opFallidasBtn.backgroundColor = .white
            self.ingresosBtn.setTitleColor(.white, for: .normal)
            self.ingresosBtn.backgroundColor = UIColor.principalAppColor
            self.egresosBtn.setTitleColor(.white, for: .normal)
            self.egresosBtn.backgroundColor = UIColor.principalAppColor
            self.mytable.reloadData()
        }
    }
}


extension PaymentHistoryViewController: UITableViewDataSource,UITableViewDelegate{
    
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
        
        if ingresosPressed == true {
            return (ingresosHistory?.count)!

        } else if egresosPressed == true {
            return (egresosHistory?.count)!
        } else {
            return (fallidasHistory?.count)!
        }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! historyTableViewCell
        
        let dataHistory: PaymentHistoryModel?
//        let dataHistory = !self.searchActive  ? self.paymentHistory?[indexPath.row] : self.filtered?[indexPath.row]
        var accountId = 0
        
        if ingresosPressed == true {
            dataHistory = self.ingresosHistory?[indexPath.row]
            if (dataHistory?.succeeded)!  {
                dataHistory?.feedBack = NSLocalizedString("notification.transactionTrueInHistory", comment: " ")
            }
            
            cell.state.text = dataHistory?.feedBack
            cell.date.text = UtilityMethods.format_date(fecha: (dataHistory?.created)!)
            
            // Pago recibido
            dataHistory?.referencesHistoryName = (dataHistory?.payer?.name)!
            let received = NSLocalizedString("notification.sentYou", comment: " ")
            cell.concept.text = received
            cell.mount.textColor = UtilityMethods.getBackgroundColor()
            cell.name.text = dataHistory?.referencesHistoryName
            cell.mount.text = "\(UtilityMethods.formatCurency(number: Double((dataHistory?.amount)!)))"
            
            accountId = (dataHistory?.senderAccountId)!
            // set bankAccount
            for bank in AppDelegate.bankAccounts {
                if bank.id == accountId {
                   dataHistory!.nameBank = bank.name
                }
            }
            
        } else if egresosPressed == true {
            dataHistory = self.egresosHistory?[indexPath.row]
            if (dataHistory?.succeeded)!  {
                dataHistory?.feedBack = NSLocalizedString("notification.transactionTrueInHistory", comment: " ")
            }
            
            cell.state.text = dataHistory?.feedBack
            cell.date.text = UtilityMethods.format_date(fecha: (dataHistory?.created)!)
            
            // pago Enviado
            dataHistory?.referencesHistoryName = (dataHistory?.recipient?.name)!
            let send = NSLocalizedString("notification.youSent", comment: " ")
            cell.concept.text = send
            cell.mount.textColor = UIColor.red
            cell.name.text = dataHistory?.referencesHistoryName
            let mountString = UtilityMethods.formatCurency(number: Double((dataHistory?.amount)!))
            let mountSplit = mountString.split(separator: ".")
            cell.mount.text = "\(mountSplit[0]). -\(mountSplit[1])"
            
            accountId = (dataHistory?.recipientAccountId)!
            // set bankAccount
            for bank in AppDelegate.bankAccounts {
                if bank.id == accountId {
                   dataHistory!.nameBank = bank.name
                }
            }
            
        } else if fallidasPressed == true {
            dataHistory = self.fallidasHistory?[indexPath.row]
            if (dataHistory?.succeeded)!  {
                dataHistory?.feedBack = NSLocalizedString("notification.transactionTrueInHistory", comment: " ")
            }
            cell.state.text = dataHistory?.feedBack
            cell.date.text = UtilityMethods.format_date(fecha: (dataHistory?.created)!)
            // set bankAccount
            for bank in AppDelegate.bankAccounts {
                if bank.id == accountId {
                   dataHistory!.nameBank = bank.name
                }
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
                         
                         self.mytable.reloadData()
                     }
                 }
             }
             
         }
        
         return cell
     }
     
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let dataHistory: PaymentHistoryModel?
        let storyboard = UIStoryboard(name: "TransferSend", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "TransferSend") as! PaymentDetailsViewController
        
        if ingresosPressed == true {
            dataHistory = self.ingresosHistory?[indexPath.row]
            detailsVC.details = dataHistory
            
        } else if egresosPressed == true {
            dataHistory = self.egresosHistory?[indexPath.row]
            detailsVC.details = dataHistory

        } else if fallidasPressed == true {
            dataHistory = self.fallidasHistory?[indexPath.row]
            detailsVC.details = dataHistory

        }
//         let dataHistory = !self.searchActive ? self.paymentHistory?[indexPath.row] : self.filtered?[indexPath.row]
         
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
