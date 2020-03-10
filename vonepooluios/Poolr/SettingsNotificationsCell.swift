//
//  PushNotificationsCell.swift
//  Poolr
//
//  Created by James Li on 10/13/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class SettingsNotificationsCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let isOn = UserDataPersistenceHelper.isNotificationOn {
            notificationSwitch.isOn = isOn
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func notificationChanged(_ sender: Any) {
        if self.notificationSwitch.isOn {
            UserDataPersistenceHelper.isNotificationOn = true
        } else {
            UserDataPersistenceHelper.isNotificationOn = false
        }
    }
}
