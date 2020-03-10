//
//  SettingsContentViewController.swift
//  Poolr
//
//  Created by James Li on 4/27/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class SettingsContentViewController: UIViewController {
    var contentHeight: CGFloat!
    var contentText: NSAttributedString!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleView()
        setLeftNavigationBackButton()
        setupContent()
    }
    
    func setupContent() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo:self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
        ])
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
    
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.attributedText = contentText
        contentLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(contentLabel)
        
        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32).isActive = true
        contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 32).isActive = true
        contentLabel.widthAnchor.constraint(equalToConstant: 323).isActive = true
        
        let minsz = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        contentView.frame = CGRect(origin:.zero, size:minsz)
        scrollView.contentSize.height = contentHeight
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
