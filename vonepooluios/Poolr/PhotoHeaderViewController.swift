//
//  PhotoHeaderViewController.swift
//  Poolr
//
//  Created by James Li on 2/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class PhotoHeaderViewController: UIViewController {

    @IBOutlet weak var joinStatusImageView: UIImageView!
    @IBOutlet weak var poolNameLabel: UILabel!
    @IBOutlet weak var countDownLablel: UILabel!
    
    private var pool: PoolData
    
    init(pool: PoolData) {
        
        self.pool = pool
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.poolNameLabel.text = pool.poolName
        self.countDownLablel.text = pool.drawDate
       
        if pool.isJoined {
            self.joinStatusImageView.image = self.joinStatusImageView.image?.tinted(with: AppConstants.lightGreen)
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
