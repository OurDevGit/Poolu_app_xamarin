//
//  DocumentWebViewController.swift
//  Poolr
//
//  Created by James Li on 9/7/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class DocumentWebViewController: UIViewController {

    var documentUrlString : String?
    
    var webView : UIWebView {
        return self.view as! UIWebView
    }
    
    override func loadView() {
        let webView = UIWebView()
        self.view = webView
        webView.delegate = self
        
        let swipe = UISwipeGestureRecognizer(target: self, action: nil)
        swipe.direction = .down
        webView.scrollView.addGestureRecognizer(swipe)
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let docUrl = self.documentUrlString,
           let url = URL(string: docUrl) {
            self.webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPooluNavigationBar()
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.delegate = nil
    }

}

extension DocumentWebViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.makeToastActivity(.center)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideToastActivity()
    }
}
