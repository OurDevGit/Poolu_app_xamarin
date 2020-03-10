//
//  PoolUpdateViewController.swift
//  Poolr
//
//  Created by James Li on 10/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class PoolResultsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCityStateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var poolResults : [PoolResult]?
 
    struct TableViewCellIdentifiers {
        static let poolResultCell = "PoolResultCell"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Pool Results", image: UIImage(named: "iconPoolUpdate"), tag: 2)
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -3.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        setupHeader()
        
        getPoolResults()
        ViewControllerHelper().addStatusBarBackgroundForIphoneX()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func getPoolResults() {
        view.makeToastActivity(.center)
        
        PoolService.poolResultsForClosedPools { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Pool Results", errorMessage: error.showError)
            } else if let result = result {
                strongSelf.poolResults = result
                if  strongSelf.tableView.isHidden {
                    strongSelf.tableView.isHidden = false
                }
                strongSelf.tableView.register(UINib(nibName: TableViewCellIdentifiers.poolResultCell, bundle: nil),
                                        forCellReuseIdentifier: TableViewCellIdentifiers.poolResultCell)
                
                strongSelf.tableView.dataSource = self
                strongSelf.tableView.reloadData()
            }
        }
    }
    
}

extension PoolResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poolResults!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.poolResultCell,
                                                 for: indexPath) as! PoolResultCell
        cell.configure(for: poolResults![indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension PoolResultsViewController: PoolResultCellDelegate {
    func PoolResultCellViewMyTicketsTapped(_ sender: PoolResultCell) {
        let vc = TicketPhotoViewController()
        vc.pool = getPool(cell: sender)
        vc.poolerUserId = UserDataPersistenceHelper.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func poolResultCellViewPlayerAndTicketsTapped(_ sender: PoolResultCell) {
        let vc = PhotoViewController()
        vc.pool = getPool(cell: sender)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getPool(cell: PoolResultCell) -> PoolData {
        let poolData = poolResults![(tableView.indexPath(for: cell)?.row)!]
        let pool = PoolData(poolId: poolData.poolId,
                            poolName: poolData.poolName,
                            drawDate: poolData.drawDate,
                            isJoined: true,
                            isOpenPool: false)
        return pool
    }
}

