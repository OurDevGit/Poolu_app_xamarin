//
//  PoolCameraViewController.swift
//  Poolr
//
//  Created by James Li on 10/25/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import Toast_Swift
import SCLAlertView

class AddTicketViewController: UIViewController {
    
    @IBOutlet weak var ticketPhotoImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var ticketPhoto: UIImage?
    var pool: PoolData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.submitButton.setCornerRadius()
        
        if let photo = ticketPhoto {
            self.ticketPhotoImageView.image = photo
        }
    }
    
    func getPoolViewController() -> PoolViewController? {
        let allVC = self.navigationController?.viewControllers
        
        if  let poolVC = allVC![1] as? PoolViewController {
            return poolVC;
        }
        return nil
    }
    
    func getUploadSuccessMessage() -> String {
        return "You have successfully submitted your ticket to the Poolu " + pool.poolName + " pool! " + AppConstants.lotteryTicketUploadSuccessMessage
    }

    @IBAction func cancel(_ sender: Any) {
        if  let poolVC = getPoolViewController() {
            self.navigationController!.popToViewController(poolVC, animated: true)
        }
    }
    
    @IBAction func retakePhoto(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submit(_ sender: Any) {
        self.uploadLotteryTicket()
    }
    
    private func uploadLotteryTicket() {
        if let photo = self.ticketPhotoImageView.image {
            view.makeToastActivity(.center)
            let photoSize = CGSize(width: AppConstants.lotteryPhotoUploadWidth,
                                   height: AppConstants.lotteryPhotoUploadHeight)
            let resizedPhoto = photo.resizedImage(withBounds: photoSize)
            
            if let compressedPhoto = UIImagePNGRepresentation(resizedPhoto) {
                PhotoService.uploadLotteryTicket(poolId: pool.poolID,
                                                 photoData: compressedPhoto) {
                                                    [weak self] (result, error)  in
                                                    guard let strongSelf = self else {
                                                        return
                                                    }
                                                    strongSelf.view.hideToastActivity()
                                                    strongSelf.didTicketUploaded(result: result, error: error)
                }
            }
        }
    }
    
    private func didTicketUploaded(result: String?, error: ServiceError?) {
        if let error = error {
            print(error)
            ViewControllerHelper().showSCLErrorAlert(title: "Ticket Submit", errorMessage: error.showError)
        } else if let _ = result {
            let appearance = ViewControllerHelper().getSCLAlertViewAppearance()
            let alert = SCLAlertView(appearance: appearance)
            let timeInterval = self.pool.countDownInterval +  self.pool.notificationInterval
            alert.addButton("Close") {
                ViewControllerHelper().scheduleLocalNotification(poolName: self.pool.poolName,
                                                                 timeInterval: Double(timeInterval))
                if  let poolVC = self.getPoolViewController() {
                    self.navigationController!.popToViewController(poolVC, animated: true)
                }
            }
            alert.showSuccess("Congratulations!",
                              subTitle: self.getUploadSuccessMessage(),
                              colorStyle: 0x7ED321,
                              colorTextButton: 0xFFFFFF,
                              animationStyle: .bottomToTop)
        }
    }
    
}


