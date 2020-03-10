//
//  UIViewController+Spinner.swift
//  Poolr
//
//  Created by James Li on 10/24/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideSpinner() {
        self.view.viewWithTag(99999)?.removeFromSuperview()
    }
    
    func showSpinner(color: UIColor? = nil) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        if let color = color {
            spinner.color = color
        }
        
        spinner.center = CGPoint(x: view.bounds.midX,
                                 y: view.bounds.midY + 100)
        spinner.tag = 99999
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
}
