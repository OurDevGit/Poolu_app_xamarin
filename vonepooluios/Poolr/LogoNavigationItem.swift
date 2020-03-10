//
//  LogoNavigationItem.swift
//  Poolr
//
//  Created by James Li on 7/10/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class LogoNavigationItem: UINavigationItem {
    
    private let fixedImage : UIImage = UIImage(named: "logoNav")!
    private let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 37.5))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tView = imageView
        tView.contentMode = .scaleAspectFit
        tView.image = fixedImage
        self.titleView = tView
    }

}
