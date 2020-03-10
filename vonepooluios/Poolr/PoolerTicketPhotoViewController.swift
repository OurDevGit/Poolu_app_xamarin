//
//  PoolerTicketPhotoViewController.swift
//  Poolr
//
//  Created by James Li on 2/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit
import SCLAlertView

class PoolerTicketPhotoViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var poolerTicketPhotoImage: UIImageView!
    @IBOutlet weak var poolerNameLabel: UILabel!
    @IBOutlet weak var PoolerTicketUploadDateTimeLabel: UILabel!
    @IBOutlet weak var removeTicketButton: UIButton!
    @IBOutlet weak var viewTicketNumberButton: UIButton!

    var pool: PoolData!
    var photo: TicketPhotoData!
    var photoCount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews() {
        setPooluNavigationBar()
        
        let header = PhotoHeaderViewController(pool: pool)
        headerView.addSubview(header.view)
        
        poolerNameLabel.text = photo.userName
        
        var uploadDateTime: String = "Uploaded at "
        uploadDateTime.append(photo.uploadTime)
        uploadDateTime.append(" PST")
        uploadDateTime.append(" on ")
        uploadDateTime.append(photo.uploadDate)

        PoolerTicketUploadDateTimeLabel.text = uploadDateTime
        
        if photo.userId == UserDataPersistenceHelper.userId && pool.isOpenPool {
            removeTicketButton.isHidden = false
        }
        
        if pool.isJoined || photo.userId != UserDataPersistenceHelper.userId {
            viewTicketNumberButton.isEnabled = true
            viewTicketNumberButton.tintColor = AppConstants.lightGreen
        } else {
            viewTicketNumberButton.isEnabled = false
            
        }
        
        let urlString: String = AppConstants.poolerTicketPhotoBaseURLString + photo.photoName
      
        view.makeToastActivity(.center)
        PhotoService.downloadPhoto(urlString) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                    print(error)
            } else if let image = result {
                strongSelf.poolerTicketPhotoImage.image = image
            }
                
        }
    }

    @IBAction func removeTicket(_ sender: Any) {
        view.makeToastActivity(.center)
        if photoCount > 1 {
           removeTicket()
        } else {
            removeUserFromPool()
        }
        
    }
    
    func removeTicket() {
        TicketService.removeTicket(ticketId: photo.ticketId) { [weak self] (error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Remove Ticket", errorMessage: error.showError)
            } else {
                strongSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func removeUserFromPool() {
        self.view.hideToastActivity()
        let appearance = ViewControllerHelper().getSCLAlertViewAppearance()
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Leave Pool", target:self, selector:#selector(leavePoolButtonTapped))
        alert.addButton("Cancel"){}
        
        alert.showWarning("Leave the Pool",
                          subTitle: AppConstants.leavePoolMessage,
                          colorStyle: 0x7ED321,
                          colorTextButton: 0xFFFFFF,
                          animationStyle: .bottomToTop)
    }
    
    @objc func leavePoolButtonTapped() {
        TicketService.removeTicket(ticketId: photo.ticketId) { [weak self] (error)  in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Leave Pool", errorMessage: error.showError)
            } else if let poolVC = strongSelf.getPoolViewController() {
                ViewControllerHelper().removeNotification(poolName: strongSelf.pool.poolName)
                poolVC.poolId = strongSelf.pool.poolID
                strongSelf.navigationController!.popToViewController(poolVC, animated: true)
            }
        }
    }
    
    func getPoolViewController() -> PoolViewController? {
        let allVC = self.navigationController?.viewControllers
        
        if  let poolVC = allVC![1] as? PoolViewController {
            return poolVC;
        }
        return nil
    }
    
    @IBAction func viewTicketNumbers(_ sender: Any) {
        view.makeToastActivity(.center)
        TicketService.LotteryNumbersForTicket(ticketId: photo.ticketId) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
               if let error = error {
                    print(error)
                    ViewControllerHelper().showSCLErrorAlert(title: "Leave Pool", errorMessage: error.showError)
                } else if let numbers = result {
                    strongSelf.showTicketNumbers(numbers: numbers)
            }
        }
    }
    
    func showTicketNumbers(numbers: [String]) {
        var ticketNumbers: String = ""
        for num in numbers {
            ticketNumbers.append(num)
            ticketNumbers.append("\n")
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 320,
            kTitleFont: UIFont(name: "Avenir-Roman", size: 17)!,
            kTextFont: UIFont(name: "Avenir-Roman", size: 15)!,
            kButtonFont: UIFont(name: "Avenir-Roman", size: 17)!,
            showCloseButton: false,
            contentViewCornerRadius: 4,
            buttonCornerRadius: 4
        )
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Close"){}
        
        alert.showInfo("Ticket Numbers",
                          subTitle: ticketNumbers,
                          colorStyle: 0x7ED321,
                          colorTextButton: 0xFFFFFF,
                          animationStyle: .bottomToTop)
    }
    
    
    
}


