//
//  JoinPoolViewController.swift
//  Poolr
//
//  Created by James Li on 12/1/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import SCLAlertView
import Toast_Swift

class PoolViewController: UIViewController {

    @IBOutlet weak var drawDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentValueView: UIView!
    @IBOutlet weak var numOfTicketsView: UIView!
    
    @IBOutlet weak var joinStatusImageView: UIImageView!
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var countDownLablel: CountDownLabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var winnerShareLabel: UILabel!
    @IBOutlet weak var numberOfTicketLabel: UILabel!
    @IBOutlet weak var poolrShareLabel: UILabel!
    @IBOutlet weak var notJoinedNoticeLabel: UILabel!
    @IBOutlet weak var joinedNoticeLabel: UILabel!
    
    @IBOutlet weak var addTicketButton: UIButton!
    
    var poolId: Int!
    var pool: PoolData!
    
    
    struct TableViewCellIdentifiers {
        static let poolOptionCell = "SettingsCell"
    }
    
    let menuList: [String] = ["Share Pools", "View My Tickets", "View All Players and Tickets"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    @objc func appWillEnterForeground() {
        getPoolData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ViewControllerHelper().removeStatusBarBackgroundForIphoneX()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        getPoolData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        setNavigationBarBackGround()
        setNavigationTitleView()
        setPoolLeftNavigationBackButton()
        
        self.tableView.register(UINib(nibName: TableViewCellIdentifiers.poolOptionCell, bundle: nil),
                                forCellReuseIdentifier: TableViewCellIdentifiers.poolOptionCell)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //ViewControllerHelper().addTopBorderWithColor(self.tableView, color: PlrConstants.poolrLineColor, width: 1.0)
        self.reloadData()

        self.currentValueView.backgroundColor = AppConstants.poolInfoCellColor
        self.numOfTicketsView.backgroundColor = AppConstants.poolInfoCellColor
        
        self.addTicketButton.setCornerRadius()
        
    }
    
    func setupPoolData() {
        self.drawDateLabel.text = pool.drawDate
        self.poolNameLabel.text = pool.poolName
        self.countDownLablel.runCountDown(intervalInSeconds: pool.countDownInterval)
        self.currentValueLabel.text = pool.jackpot
        self.winnerShareLabel.text = pool.winnerShare
        self.numberOfTicketLabel.text = "\(pool.poolerCount)" + "/" + "\(pool.poolSize)"
        self.poolrShareLabel.text = pool.poolerShare
        
        if pool.isJoined {
            self.joinedNoticeLabel.isHidden = false
            self.notJoinedNoticeLabel.isHidden = true
            self.joinStatusImageView.image = self.joinStatusImageView.image?.tinted(with: AppConstants.lightGreen)
            
        } else {
            self.joinStatusImageView.image = UIImage(named: "grayJoy")
            self.joinedNoticeLabel.isHidden = true
            self.notJoinedNoticeLabel.isHidden = false
        }
        
    }
    
    func setPoolLeftNavigationBackButton() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(poolBackButtonTapped))
        backButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func poolBackButtonTapped() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func reloadData(){
        tableView.reloadData()
        DispatchQueue.main.async { () in
            let scrollPoint = CGPoint(x: 0, y: 17)
            self.tableView.setContentOffset(scrollPoint, animated: false)
        }
    }
    
    func pushViewController(rowIndex: Int) {
        switch rowIndex {
        case 0:
            showCopyLink()
        case 1:
            let vc = TicketPhotoViewController()
            vc.pool = pool
            vc.poolerUserId = UserDataPersistenceHelper.userId
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = PhotoViewController()
            vc.pool = self.pool
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    func showCopyLink() {
        let appearance = ViewControllerHelper().getSCLAlertViewAppearance()
        let alert = SCLAlertView(appearance: appearance)
        let linkTextField = alert.addTextField()
        linkTextField.isEnabled = false
        linkTextField.text = AppConstants.poolLink
        
        alert.addButton("Copy Link") {
            UIPasteboard.general.string = linkTextField.text
            self.view.makeToast("Link Copied", duration: 2.0, position: .center)
        }
        
        alert.showNotice("Share the Pool!",
                          subTitle: AppConstants.sharePoolMessage,
                          colorStyle: 0x7ED321,
                          colorTextButton: 0xFFFFFF,
                          animationStyle: .bottomToTop)
    }
    
    func getPoolData() {
        view.makeToastActivity(.center)
        PoolService.poolDataForOpenPools(poolId: self.poolId) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Lottery Pools", errorMessage: error.showError)
            } else if let pools = result {
                strongSelf.pool = pools[0]
                strongSelf.setupPoolData()
            }
        }
    }

    @IBAction func addTicket(_ sender: Any) {
        let ticketCameraVC = TicketCameraViewController()
        ticketCameraVC.pool = self.pool
        self.navigationController?.pushViewController(ticketCameraVC, animated: true)
    }
}

extension PoolViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.poolOptionCell,
                                                 for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.rowIndex = indexPath.row
        cell.optionLabel.text = menuList[indexPath.row]
        cell.optionLabel.textColor = AppConstants.lightGreen
        cell.delegate = self
        
        return cell
        
    }
}

extension PoolViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(rowIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            tableView.scrollToBottom(animated: true)
        }
    }
}

extension PoolViewController: SettingsCellDelegate {
    func SettingsCellLinkImageTapped(_ tableCell: SettingsCell) {
        self.pushViewController(rowIndex: tableCell.rowIndex)
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
            
        }
    }
}


