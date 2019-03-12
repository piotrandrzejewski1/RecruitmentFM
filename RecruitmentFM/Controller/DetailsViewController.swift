//
//  DetailsViewController.swift
//  RecruitmentFM
//
//  Created by Piotr Andrzejewski on 12/03/2019.
//  Copyright © 2019 Piotr Andrzejewski. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD

class DetailsViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var selectedItem : Item? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        // Do any additional setup after loading the view.
        // Place the URL in a URL Request.
        if let url = selectedItem?.desc?.embededUrl {
            let request = URLRequest(url: url)
            ProgressHUD.show()
            webView.load(request)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.showError("Could not load the page")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.showError("Could not load the page")
    }
}
