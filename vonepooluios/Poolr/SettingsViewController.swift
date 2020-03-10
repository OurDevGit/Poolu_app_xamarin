//
//  SettingsViewController.swift
//  Poolr
//
//  Created by James Li on 10/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct TableViewCellIdentifiers {
        static let settingsCell = "SettingsCell"
        static let settingsNotificationsCell = "SettingsNotificationsCell"
    }
    
    let menuList : [String] = ["Edit Profile",
                               "Enable Notification",
                               "Terms and Conditions",
                               "Poolu in Plain Talk",
                               "Rules to The Pool",
                               "Privacy Policy",
                               "Contact Us"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "iconMore"), tag: 3)
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -3.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ViewControllerHelper().removeStatusBarBackgroundForIphoneX()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        setNavigationBarBackGround()
        setNavigationTitleView()
        setSettingsLeftNavigationBackButton()
        
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: TableViewCellIdentifiers.settingsCell, bundle: nil),
                                        forCellReuseIdentifier: TableViewCellIdentifiers.settingsCell)
        
        self.tableView.register(UINib(nibName: TableViewCellIdentifiers.settingsNotificationsCell, bundle: nil),
                                forCellReuseIdentifier: TableViewCellIdentifiers.settingsNotificationsCell)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setSettingsLeftNavigationBackButton() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsBackButtonTapped))
        backButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func settingsBackButtonTapped() {
      self.present(PlrTabBarController(), animated: true, completion: nil)
    }
    
    func pushViewController(rowIndex: Int) {
        var controller = UIViewController()

        switch rowIndex {
        case 0:
            controller = UpdateProfileViewController()
            break
        case 2:
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.termsAndConditionsUrlString)
            break
        case 3:
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.plainTalkUrlString)
            break
        case 4:
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.rulesToPoolUrlString)
            break
        case 5:
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.privacyPolicyUrlString)
            break
        case 6:
            controller = ContactUsViewController()
            break
        default:
            break
        }
        
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    private func loadDocumentInWebView(withUrlString urlString: String) -> UIViewController {
//        let vc = DocumentWebViewController()
//        vc.documentUrlString = urlString
//        return vc
//    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.settingsNotificationsCell,
                                                     for: indexPath) as! SettingsNotificationsCell
            cell.selectionStyle = .none
            cell.optionLabel.text = menuList[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.settingsCell,
                                                 for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.rowIndex = indexPath.row
        cell.optionLabel.text = menuList[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(rowIndex: indexPath.row)
    }
}

extension SettingsViewController: SettingsCellDelegate {
    func SettingsCellLinkImageTapped(_ tableCell: SettingsCell) {
       self.pushViewController(rowIndex: tableCell.rowIndex)
    }
}

