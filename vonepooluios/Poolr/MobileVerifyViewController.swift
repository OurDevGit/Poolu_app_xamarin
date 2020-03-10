//
//  MobileVerifyViewController.swift
//  Poolr
//
//  Created by James Li on 3/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit

class MobileVerifyViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var textFieldsStackView: UIStackView!
    @IBOutlet var continueButton: UIButton!

    let verificationCodeTextField = TextInputViewController(title: "Verification Code")

    var phoneNumber = SignUpData.sharedInstance.phoneNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    func setupViews() {
        self.setNavigationTitleView()
        self.clearLeftNavigationBackButton()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        continueButton.setCornerRadius()
        
        instructionLabel.text = "Please enter the verification code that we just sent via SMS to " + phoneNumber + "."
        
        textFieldsStackView.addArrangedSubview(verificationCodeTextField.view)
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillEqually
        
        verificationCodeTextField.textField.keyboardType = .numberPad

        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self, action: #selector(barBtnDoneTapped))
        
        toolbarDone.items = [flexSpace, barBtnDone]
        verificationCodeTextField.textField.inputAccessoryView = toolbarDone
    }
    
    @objc func cancelTapped() {
        if let vc = getHomeViewController() {
            navigationController?.popToViewController(vc, animated: true)
        }     
    }
    
    func getHomeViewController() -> HomeViewController? {
        let allVC = self.navigationController?.viewControllers
        
        if  let homeVC = allVC![1] as? HomeViewController {
            return homeVC;
        }
        return nil
    }
    
    @objc func barBtnDoneTapped() {
        if verificationCodeTextField.text != "" {
            verificationCodeTextField.validateVerificationCode()
        } else {
            verificationCodeTextField.clearError()
        }
        self.view.endEditing(true)
    }
    
    @IBAction func next(_ sender: Any) {
        if verificationCodeTextField.validateVerificationCode() {
            moveNext()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func moveNext() {
        view.makeToastActivity(.center)
        
        AccountService.checkVerificationCode(phoneNumber: self.phoneNumber,
                                             totp: self.verificationCodeTextField.text) {
            [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.view.hideToastActivity()
            
            if let error = error {
                strongSelf.view.hideToastActivity()
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Invalid Verification Code", errorMessage: error.showError)
            } else if let accountData = result {
                if let _ = accountData.userId,
                    UserDataPersistenceHelper.persistAccountData(accountData) {
                    UserDataPersistenceHelper.profilePhoto = nil
                    strongSelf.downloadProfilePhoto()
                } else {
                    strongSelf.navigationController?.pushViewController(ContactViewController(), animated: true)
                }
            }
        }
    }
    
    func downloadProfilePhoto() {
        PhotoService.downloadProfilePhoto() {
            [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print(error)
            } else if let data = result {
                UserDataPersistenceHelper.profilePhoto = UIImage(data: data)
                strongSelf.navigationController?.pushViewController(PlrTabBarController(), animated: true)
            }
        }
    }
    
}




