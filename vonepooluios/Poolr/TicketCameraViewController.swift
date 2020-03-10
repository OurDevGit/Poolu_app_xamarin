//
//  TicketCameraViewController.swift
//  Poolr
//
//  Created by James Li on 11/30/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import SCLAlertView


class TicketCameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: IRLCameraView!
    @IBOutlet var backImageView: UIImageView!
    
    var pool: PoolData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupBackImageTapAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        showInstruction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraView.stop()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        cameraView.prepareForOrientationChange()
        
        weak var weakSelf = self
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // we just want the completion handler
        }, completion: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            weakSelf?.cameraView.finishedOrientationChange()
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupBackImageTapAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backImageTapped(gesture:)))
        
        backImageView.addGestureRecognizer(tapGesture)
        backImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func backImageTapped(gesture: UIGestureRecognizer) {
        if gesture.view as? UIImageView != nil {
            self.cameraView.stop()
            
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCameraView() {
        cameraView.setupCameraView()
        cameraView.delegate = self
        cameraView.overlayColor = AppConstants.lightGreen
        cameraView.detectorType = IRLScannerDetectorType.accuracy
        cameraView.cameraViewType = IRLScannerViewType.normal
        cameraView.isShowAutoFocusEnabled = true
        cameraView.isBorderDetectionEnabled = true
        cameraView.isTorchEnabled = true
         //self.cameraView.start()
    }
    
    func showInstruction() {
        let appearance = ViewControllerHelper().getSCLAlertViewAppearance()
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Close") {
            self.setupCameraView()
            self.cameraView.start()
        }
        
        alert.showInfo ("Attention!",
                          subTitle: AppConstants.photoTakenInstruction,
                          colorStyle: 0x7ED321,
                          colorTextButton: 0xFFFFFF,
                          animationStyle: .bottomToTop)
    }

}

extension TicketCameraViewController: IRLCameraViewProtocol {

    func didDetectRectangle(_ view: IRLCameraView!, withConfidence confidence: UInt) {
        
    }
    
    func didGainFullDetectionConfidence(_ view: IRLCameraView!) {

        self.cameraView.captureImage() {
            [weak self] image in
            
            guard let strongSelf = self else {
                return
            }
            
            if let photo = image {
                 strongSelf.cameraView.stop()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.01 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    let submitTicketVC = AddTicketViewController()
                    submitTicketVC.ticketPhoto = photo
                    submitTicketVC.pool = strongSelf.pool
                    strongSelf.navigationController?.pushViewController(submitTicketVC, animated: true)
                })
            }
        }
    }

}

