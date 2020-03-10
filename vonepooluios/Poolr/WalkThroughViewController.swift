//
//  WalkThroughViewController.swift
//  Poolr
//
//  Created by James Li on 4/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    let imageNames = ["walkthroughFigure1", "walkthroughFigure2", "walkthroughFigure3",
                      "walkthroughFigure4", "walkthroughFigure5", "walkthroughFigure6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.headerView.backgroundColor = UIColor(patternImage: UIImage(named: "phBackground")!)
        //self.headerView.translatesAutoresizingMaskIntoConstraints = true
        
        ViewControllerHelper().addStatusBarBackgroundForIphoneX()
        
        continueButton.setCornerRadius()

        scrollView.contentSize.width = self.frame.size.width
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        setupPageControl()
        setupPageControlContent()
    }
    
    func setupPageControl() {
        pageControl.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = AppConstants.lightGreen
        
    }
    
    func setupPageControlContent() {
        for index in 0..<imageNames.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: imageNames[index])
            imageView.contentMode = UIViewContentMode.scaleAspectFit

            self.scrollView.addSubview(imageView)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width  * CGFloat(imageNames.count), height: self.scrollView.frame.size.height)
        
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        //present(HomeViewController(), animated: true, completion: nil)
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @IBAction func skip(_ sender: Any) {
        let x = CGFloat(pageControl.numberOfPages - 1) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
}

extension WalkThroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        if pageNumber == CGFloat(imageNames.count - 1) {
            skipButton.isHidden = true
            continueButton.setCornerRadius()
            continueButton.isHidden = false
        } else {
            skipButton.isHidden = false
            continueButton.isHidden = true
        }
        
    }
    
}


