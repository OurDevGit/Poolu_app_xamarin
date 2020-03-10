//
//  SettingsCell.swift
//  Poolr
//
//  Created by James Li on 10/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate: class {
    func SettingsCellLinkImageTapped(_ tableCell: SettingsCell)
}

class SettingsCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    
    var rowIndex: Int = 0
    
    weak var delegate: SettingsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = UIImage(named: "backChevron")
        linkImageView.image =  image?.maskWithColor(color: AppConstants.lightGreen)
        linkImageView.transform = linkImageView.transform.rotated(by: CGFloat(Double.pi))
        
        setupBackImageTapAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupBackImageTapAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backImageTapped(gesture:)))
        
        linkImageView.addGestureRecognizer(tapGesture)
        linkImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func backImageTapped(gesture: UIGestureRecognizer) {
        if gesture.view as? UIImageView != nil {
            delegate?.SettingsCellLinkImageTapped(self)
        }
    }
    
}
