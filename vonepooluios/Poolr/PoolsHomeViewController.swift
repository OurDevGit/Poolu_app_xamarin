//
//  PoolsViewController.swift
//  Poolr
//
//  Created by James Li on 10/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class PoolsHomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCityStateLabel: UILabel!
    
    @IBOutlet var pool1JoinButton: UIButton!
    @IBOutlet var pool2JoinButton: UIButton!
    
    //@IBOutlet weak var pool1CountDown: UILabel!
    
    @IBOutlet weak var pool1CountDown: CountDownLabel!
    @IBOutlet weak var pool1StatusIcon: UIImageView!
    @IBOutlet weak var pool1Name: UILabel!
    
    @IBOutlet weak var pool1Jackpot: UILabel!
    @IBOutlet weak var pool1PoolerCount: UILabel!
    @IBOutlet weak var pool1WinnerShare: UILabel!
    @IBOutlet weak var pool1PoolerShare: UILabel!
    
    @IBOutlet weak var pool2StatusIcon: UIImageView!
    @IBOutlet weak var pool2Name: UILabel!
    @IBOutlet weak var pool2CountDown: CountDownLabel!
    @IBOutlet weak var pool2Jackpot: UILabel!
    @IBOutlet weak var pool2PoolerCount: UILabel!
    @IBOutlet weak var pool2WinnerShare: UILabel!
    @IBOutlet weak var pool2PoolerShare: UILabel!
    
    @IBOutlet weak var pool1DrawDate: UILabel!
    @IBOutlet weak var pool2DrawDate: UILabel!
    
    
    var image: UIImage?
    var ticketTypeId: Int?
    var pools: [PoolData]?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Live Pools", image: UIImage(named: "iconPools"), tag: 1)
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -3.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pool1JoinButton.setCornerRadius()
        pool2JoinButton.setCornerRadius()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        headerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc func appWillEnterForeground() {
        getOpenPools()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupHeader()
        getOpenPools()
        ViewControllerHelper().addStatusBarBackgroundForIphoneX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func setupHeader() {
        if let photo = UserDataPersistenceHelper.profilePhoto {
            showUserPhoto(photo)
        }
        
        userNameLabel.text = UserDataPersistenceHelper.userName
        if  UserDataPersistenceHelper.city != "",
            UserDataPersistenceHelper.state != "",
            let city = UserDataPersistenceHelper.city,
            let state = UserDataPersistenceHelper.state {
            
            userCityStateLabel.text = city + ", " + state
        }
        
        self.headerView.backgroundColor = UIColor(patternImage: UIImage(named: "phBackground")!)
 
    }

    func showUserPhoto(_ photo: UIImage) {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.bounds.size.width / 2.0
        userPhotoImageView.layer.borderWidth = 1.0
        userPhotoImageView.layer.borderColor = AppConstants.lightGreen.cgColor
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.image = photo.resizedImage(withBounds: CGSize(width: 64.0, height: 64.0))
        
    }
    
    func setupPoolsData(pools: [PoolData]) {
        self.pool1DrawDate.text = pools[0].drawDate
        self.pool1Name.text = pools[0].poolName
        self.pool1Jackpot.text = pools[0].jackpot
        self.pool1PoolerCount.text = "\(pools[0].poolerCount)" + " out of " + "\(pools[0].poolSize)"
        self.pool1WinnerShare.text = pools[0].winnerShare
        self.pool1PoolerShare.text = pools[0].poolerShare
        self.pool1CountDown.runCountDown(intervalInSeconds: pools[0].countDownInterval)
        
        self.pool2DrawDate.text = pools[1].drawDate
        self.pool2Name.text = pools[1].poolName
        self.pool2Jackpot.text = pools[1].jackpot
        self.pool2PoolerCount.text = "\(pools[1].poolerCount)" + " out of " + "\(pools[1].poolSize)"
        self.pool2WinnerShare.text = pools[1].winnerShare
        self.pool2PoolerShare.text = pools[1].poolerShare
        self.pool2CountDown.runCountDown(intervalInSeconds: pools[1].countDownInterval)
        
        if pools[0].isJoined {
            self.pool1StatusIcon.image = self.pool1StatusIcon.image?.tinted(with: AppConstants.lightGreen)
            self.pool1JoinButton.backgroundColor = UIColor.white
            self.pool1JoinButton.setTitle("View Pool Info", for: .normal)
            self.pool1JoinButton.setTitleColor(AppConstants.lightGreen, for: .normal)
            self.pool1JoinButton.layer.borderColor = AppConstants.lightGreen.cgColor
            self.pool1JoinButton.layer.borderWidth = 1
        } else {
            self.pool1StatusIcon.image = UIImage(named: "grayJoy")
            self.pool1JoinButton.backgroundColor = AppConstants.lightGreen
            self.pool1JoinButton.setTitle("Join Pool", for: .normal)
            self.pool1JoinButton.setTitleColor(UIColor.white, for: .normal)
            self.pool1JoinButton.layer.borderColor = UIColor.clear.cgColor
            self.pool1JoinButton.layer.borderWidth = 0
        }
        
        if pools[1].isJoined {
            self.pool2StatusIcon.image = self.pool2StatusIcon.image?.tinted(with: AppConstants.lightGreen)
            self.pool2JoinButton.backgroundColor = UIColor.white
            self.pool2JoinButton.setTitle("View Pool Info", for: .normal)
            self.pool2JoinButton.setTitleColor(AppConstants.lightGreen, for: .normal)
            self.pool2JoinButton.layer.borderColor = AppConstants.lightGreen.cgColor
            self.pool2JoinButton.layer.borderWidth = 1
        } else {
            self.pool2StatusIcon.image = UIImage(named: "grayJoy")
            self.pool2JoinButton.backgroundColor = AppConstants.lightGreen
            self.pool2JoinButton.setTitle("Join Pool", for: .normal)
            self.pool2JoinButton.setTitleColor(UIColor.white, for: .normal)
            self.pool2JoinButton.layer.borderColor = UIColor.clear.cgColor
            self.pool2JoinButton.layer.borderWidth = 0
        }

    }
    
    func pushPoolViewController(_ poolId: Int) {
        let poolVC = PoolViewController()
        poolVC.poolId = poolId
        navigationController?.pushViewController(poolVC, animated: true)
    }
    
    @IBAction func joinPool1(_ sender: Any) {
        if let pool = pools?[0] {
            pushPoolViewController(pool.poolID)
        }
       
    }
    
    @IBAction func joinPool2(_ sender: Any) {
        if let pool = pools?[1] {
            pushPoolViewController(pool.poolID)
        }
      
    }
    
    func getOpenPools() {
        view.makeToastActivity(.center)
        PoolService.poolDataForOpenPools { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Lottery Pools", errorMessage: error.showError)
            } else if let pools = result {
                strongSelf.pools = pools
                strongSelf.setupPoolsData(pools: pools)
            }
        }
    }
    
}






