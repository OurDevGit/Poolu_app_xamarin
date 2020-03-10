//
//  UserPhotoViewController.swift
//  Poolr
//
//  Created by James Li on 2/5/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit
import Foundation

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    var pool: PoolData!
    var photoData: [PoolerPhotoData] = []
    
    struct CollectionViewCellIdentifiers {
        static let photoCell = "PhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let header = PhotoHeaderViewController(pool: pool)
        headerView.addSubview(header.view)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        setPooluNavigationBar()
        getPoolerPhotoData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        collectionView.register(UINib(nibName: CollectionViewCellIdentifiers.photoCell, bundle:nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifiers.photoCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func getPoolerPhotoData() {
        PoolService.photoDataForPoolers(poolId: pool.poolID) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Poolr Photo", errorMessage: error.showError)
            } else if let data = result {
                strongSelf.photoData = data
                strongSelf.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }

}

extension PhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let photo = photoData[indexPath.row]
        
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
            } else if let image = result,
                let cell = strongSelf.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                cell.update(with: image)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoData[indexPath.row]
        let vc = PoolerPhotoViewController()
        vc.pool = pool
        vc.photo = photo
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photoData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.photoCell,
                                                  for: indexPath) as! PhotoCell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width) / 3
        let height = width
        return CGSize(width: width, height: height);
    }
}

