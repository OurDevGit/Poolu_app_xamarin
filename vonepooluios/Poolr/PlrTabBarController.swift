//
//  PlrTabBarController.swift
//  Poolr
//
//  Created by James Li on 10/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class PlrTabBarController: UITabBarController {
    
    var image: UIImage?
    var tabIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = AppConstants.lightGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let poolsVC = PlrNavigationController(rootViewController: PoolsHomeViewController())
        let poolResultsVC = PlrNavigationController(rootViewController: PoolResultsViewController())
        let settingsVC = PlrNavigationController(rootViewController: SettingsViewController())
        self.viewControllers = [poolsVC, poolResultsVC, settingsVC]
        self.selectedIndex = self.tabIndex
    }

}
