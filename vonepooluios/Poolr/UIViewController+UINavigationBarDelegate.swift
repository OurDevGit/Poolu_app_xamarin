//
//  UIViewControllerExtensions.swift
//  Poolr
//
//  Created by James Li on 7/16/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UIViewController: UINavigationBarDelegate {
    
    func setPooluNavigationBar() {
        setNavigationBarBackGround()
        setNavigationTitleView()
        setLeftNavigationBackButton()
    }
    
    func setNavigationBarBackGround() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "headerBackground")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    }
    
    func setNavigationTitleView() {
        let logoImageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 37.5))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logoNav")!
        self.navigationItem.titleView = logoImageView
    }
    
    func setLeftNavigationBackButton() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backButtonTapped))
        backButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped() {
         self.navigationController?.popViewController(animated: true)
    }
    
    func clearLeftNavigationBackButton() {
        let backButton = UIBarButtonItem(title: "",
                                         style: UIBarButtonItemStyle.plain,
                                         target: navigationController,
                                         action: nil)
        
        self.navigationItem.leftBarButtonItem = backButton
        
    }
}


