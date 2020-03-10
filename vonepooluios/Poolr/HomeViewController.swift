//
//  HomeViewController.swift
//  Poolr
//
//  Created by James Li on 9/24/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       self.setupViews()
    }

    func setupViews() {
        ViewControllerHelper().loadViewBackground(self.view, imageName: "background")
        self.signUpButton.setCornerRadius();
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.setupPageControlContent() 
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

  
    // MARK: - Navigation

    @IBAction func signUp(_ sender: Any) {
        self.navigationController?.pushViewController(MobilePhoneViewController(), animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        self.navigationController?.pushViewController(MobilePhoneViewController(), animated: true)
    }

}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func setupPageControlContent() {
        var startPosition: CGFloat = 0
        var content = [[String]]()
        
        content.append(["Hassle Free Lottery Pooling", "You Supply One Ticket, We Supply Thousands Of Poolers"])
        content.append(["Better Odds of Winning", "Larger Pools Mean More Chances To Win Lots Of Money"])
        content.append(["Winning Notifications", "Get Notifications Of Your Winnings Sent Directly To Your Phone."])
        
        for texts in content {
            addLabelToScrollView(labelTexts: texts, startPosition: startPosition)
            startPosition += scrollView.bounds.size.width
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * 3,
                                        height: scrollView.bounds.size.height)
        
    }
    
    func addLabelToScrollView(labelTexts: [String], startPosition: CGFloat) {
        let headerLabel = getPageContentLabel(text: labelTexts[0])
        
        scrollView.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: startPosition) .isActive = true
        headerLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Avenir-Heavy", size: 18.0)
        headerLabel.textColor = UIColor.white
        
        
        let bodyLabel = getPageContentLabel(text: labelTexts[1])
        scrollView.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2.0).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: startPosition).isActive = true
        bodyLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        bodyLabel.numberOfLines = 2
        bodyLabel.textAlignment = .center
        bodyLabel.font = UIFont(name: "Avenir-Roman", size: 16.0)
        bodyLabel.textColor = UIColor.white
        
    }
    
    func getPageContentLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
