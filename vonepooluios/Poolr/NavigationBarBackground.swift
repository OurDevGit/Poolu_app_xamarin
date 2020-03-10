//
//  NavigationBarBackground.swift
//  Poolr
//
//  Created by James Li on 7/10/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

class NavigationBarBackground: UINavigationBar {

    private let backgroundImage : UIImage = UIImage(named: "headerBackground")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.setBackgroundImage(backgroundImage, for: .default)
    }

    
}
