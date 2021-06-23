//
//  NotificationErrorViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/15/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit

class NotificationErrorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    

    var ErrorsDict : [String] = []
    var errorPlain = ""
    
    class func createController(errors:String) -> NotificationErrorViewController{
        let storyboard = UIStoryboard(name: "NotificationError", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()! as! NotificationErrorViewController
        vc.errorPlain = errors
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.estimatedRowHeight = 150
        self.myTable.rowHeight = UITableViewAutomaticDimension
        self.myTable.allowsSelection = false
        self.myTable.separatorStyle = .none
        UtilityMethods.openModal(view: self.view)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }
  
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ErrorsDict.count == 1 {
            self.topConstraint.constant = (UIScreen.main.bounds.height) / 4
        }
        
        if ErrorsDict.count == 2 {
            self.topConstraint.constant = UIScreen.main.bounds.height / 5
        }
        
        
        if ErrorsDict.count == 3 {
            self.topConstraint.constant = UIScreen.main.bounds.height / 6
        }

        return ErrorsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "errorTableCell", for: indexPath) as! errorTableViewCell
        let errorData = ErrorsDict[indexPath.row]
        cell.content.text = errorData
        return cell
    }
    
    func initData(){
        
        let jsonErrors = UtilityMethods.convertToDictionary(text: errorPlain)

        if ((jsonErrors?["errors"]) == nil){
            // primer modelo numero ya utilizado
            let auxData = jsonErrors?["message"] as! String
            ErrorsDict = [auxData]
            
        }else{
 
            //  numero invalido
            if let invalidNumber = jsonErrors?["errors"] as? Dictionary<String,Any>{
            
                if let phoneNumberError = invalidNumber["PhoneNumber"] as? [String]{
                    // parser errorNumberPhone
                    let notification = NSLocalizedString("notification.numberInvalid", comment: "get Type Error")
                    let error = notification+phoneNumberError[0]
                    self.ErrorsDict  = [error]
                    return
                    
                }
                
                if let phoneNumberError = invalidNumber["Teléfono"] as? [String]{
                    // parser errorNumberPhone
                    let notification = NSLocalizedString("notification.numberInvalid", comment: "get Type Error")
                    let error = notification+phoneNumberError[0]
                    self.ErrorsDict  = [error]
                    return
                    
                }
            }
            
            //tercer modelo documentId invalido
            
            if let invalidDocumentId = jsonErrors?["errors"] as? Dictionary<String,Any>{
                
                if let documentIdError = invalidDocumentId["DocumentId"] as? [String]{
                    // parser errorDocumentId
                    let notification = NSLocalizedString("notification.documentInvalid", comment: "get type Error")
                    let error = notification+documentIdError[0]
                    self.ErrorsDict  = [error]
                    return
                                      
                    
                }
            }
            
            // tercer modelo password invalido
            if let invalidPassword = jsonErrors?["errors"] as? [AnyObject]{
                for passError in invalidPassword{
                    let messageError = ErrorParseableDecorator.decorate(error: passError["description"] as! String)
                    self.ErrorsDict.append(messageError)
                }
            }
            
            // amount invalido
            
            if let data = jsonErrors?["errors"] as? Dictionary<String,Any>{
                
                let amount = data["Amount"] as! [String]
                let error = amount[0]
                self.ErrorsDict  = [error]
            }
            
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
            
        }
    }

}
