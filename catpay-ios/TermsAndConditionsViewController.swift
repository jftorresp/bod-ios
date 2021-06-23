//
//  Terms&ConditionsViewController.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 9/4/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Crashlytics
import WebKit

protocol TermsAndConditionsViewDelegate:class{
    func termsAndConditions(isAccepted:Bool)
}

class TermsAndConditionsViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet weak var optionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var confirmText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var checked = false
    var sizeToWebView = CGFloat(0.0)
    let optionsViewHeightConstant = CGFloat(80)
    var checkedVisibilityRange: CGFloat {
        get {
            return self.sizeToWebView / 3
        }
    }
    weak var delegate:TermsAndConditionsViewDelegate?
    
    class func createController() -> TermsAndConditionsViewController{
        let storyboard = UIStoryboard(name: "TermsAndConditions", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! TermsAndConditionsViewController
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "ScreenView", customAttributes: ["Screen":"TermsAndConditions"])
        setupView()
        setupWebView()
    }
    
    private func setupView() {
        UtilityMethods.openModal(view: view)
        confirmText.font = UIFont(name: "OpenSans" , size: 11.0)
        optionsViewHeight.constant = 0
        self.view.layoutIfNeeded()
    }
   
    private func setupWebView() {
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        guard let file = Bundle.main.path(forResource: "termsAndConditions", ofType: "html") else { return }
        let url = URL(fileURLWithPath: file)
        webView.load(URLRequest(url: url))
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }

    
    // implement protocol webView //
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        sizeToWebView = webView.scrollView.contentSize.height
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }

    // animations //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sizeToWebView = scrollView.contentSize.height
        guard scrollView.contentOffset.y > 0 else { return }
        let height: CGFloat = scrollView.contentOffset.y >=  checkedVisibilityRange ? optionsViewHeightConstant : 0
        guard height != self.optionsViewHeight.constant else { return }
        self.optionsView.alpha = 0
        UIView.animate(withDuration: 0.75, animations: {
            self.optionsViewHeight.constant = height
            self.optionsView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func checkButton(_ sender: Any) {
        
        self.checked = !self.checked
        let icon = self.checked ? "seleccion01Bod01":"checkboxEmpty"
        
        let button = sender as! UIButton
        button.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            
            button.alpha = 1
            button.setImage(UIImage(named:icon), for: .normal)
        
        })
    }
   
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func AcceptButton(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.termsAndConditions(isAccepted: self.checked)
        }
    }
}
