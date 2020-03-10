//
//  TicketPhotoViewController.swift
//  Poolr
//
//  Created by James Li on 2/10/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class TicketPhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    var pool: PoolData!
    var photoData: [TicketPhotoData] = []
    var poolerUserId: String!
    
    struct CollectionViewCellIdentifiers {
        static let photoCell = "PhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        setPooluNavigationBar()
        
        getPoolerTicketPhotoData()
        
        let header = PhotoHeaderViewController(pool: pool)
        headerView.addSubview(header.view)        
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
    
    func getPoolerTicketPhotoData() {
        PoolService.photoDataForTickets(poolId: pool.poolID,
                                        poolerUserId: poolerUserId) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Ticket Photo", errorMessage: error.showError)
            } else if let result = result {
                strongSelf.photoData = result
                strongSelf.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
}

extension TicketPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let photo = photoData[indexPath.row]
        
        let urlString: String = AppConstants.poolerTicketPhotoBaseURLString + photo.photoName
        
        PhotoService.downloadPhoto(urlString) {[weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                    print(error)
            } else if let photoIndex = strongSelf.photoData.index(of: photo),
                      let image = result,
                      let cell = strongSelf.collectionView.cellForItem(at: IndexPath(item: photoIndex, section: 0)) as? PhotoCell {
                    cell.update(with: image)
                    cell.showTicketStats(ticketStatus: photo.ticketStatus)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PoolerTicketPhotoViewController()
        vc.pool = pool
        vc.photo = photoData[indexPath.row]
        vc.photoCount = photoData.count
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TicketPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photoData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.photoCell,
                                                  for: indexPath) as! PhotoCell
    }
}

extension TicketPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width) / 3
        let height = width
        return CGSize(width: width, height: height);
    }
}

