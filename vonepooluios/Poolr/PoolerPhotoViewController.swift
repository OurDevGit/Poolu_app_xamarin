//
//  PoolerPhotoViewController.swift
//  Poolr
//
//  Created by James Li on 2/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class PoolerPhotoViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var poolerPhotoImage: UIImageView!
    @IBOutlet weak var poolerNameLabel: UILabel!
    @IBOutlet weak var PoolerStateLabel: UILabel!
    
    var pool: PoolData!
    var photo: PoolerPhotoData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        setPooluNavigationBar()
        
        let header = PhotoHeaderViewController(pool: pool)
        headerView.addSubview(header.view)
        
        poolerNameLabel.text = photo.userName
        PoolerStateLabel.text = photo.stateName
        
        var urlString: String = AppConstants.poolerPhotoBaseURLString
        if photo.photoName.isEmpty {
            let imagePath =  Bundle.main.path(forResource: "iconPicture", ofType: "png")!
            let url = URL.init(fileURLWithPath: imagePath)
            urlString = url.relativeString
        } else {
            urlString.append(photo.photoName)
        }
        
        PhotoService.downloadPhoto(urlString) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                    print(error)
                } else if let image = result {
                    strongSelf.poolerPhotoImage.image = image
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func viewPoolerTickets(_ sender: Any) {
        let vc = TicketPhotoViewController()
        vc.pool = pool
        vc.poolerUserId = photo.userId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
