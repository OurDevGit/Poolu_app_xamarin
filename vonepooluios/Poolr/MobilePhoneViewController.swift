//
//  MobilePhoneViewController.swift
//  Poolr
//
//  Created by James Li on 3/8/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit
import SCLAlertView

class MobilePhoneViewController: UIViewController {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var textFieldsStackView: UIStackView!
    @IBOutlet var submitButton: UIButton!
    
    let phoneNumberTextField = TextInputViewController(title: "Mobile phone number")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        self.navigationController?.isNavigationBarHidden = false
        setPooluNavigationBar()
        
        instructionLabel.text = "To ensure security of your account, we will send the verification code to your phone via SMS."
        
        submitButton.setCornerRadius()
        
       
        textFieldsStackView.addArrangedSubview(phoneNumberTextField.view)
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillEqually
        
        phoneNumberTextField.textField.placeholder = "(222) 222-2222"
        phoneNumberTextField.textField.keyboardType = .numberPad
        phoneNumberTextField.textField.delegate = self
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self, action: #selector(barBtnDoneTapped))
        
        toolbarDone.items = [flexSpace, barBtnDone]
        phoneNumberTextField.textField.inputAccessoryView = toolbarDone
    }
    
    @objc func barBtnDoneTapped() {
        if phoneNumberTextField.text != "" {
            phoneNumberTextField.validateUSPhoneNumber()
        } else {
            phoneNumberTextField.clearError()
        }
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        if phoneNumberTextField.validateUSPhoneNumber() {
            SignUpData.sharedInstance.phoneNumber = phoneNumberTextField.text
            submitMobilePhone()
        }
    }

    func submitMobilePhone() {
        view.makeToastActivity(.center)
        AccountService.sendVerificationCodeToMobilePhone(phoneNumber: self.phoneNumberTextField.text) {
            [weak self] (error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Invalid Phone Number", errorMessage: error.showError)
            } else {
                let vc = MobileVerifyViewController()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension MobilePhoneViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

            if  !textField.isLengthInLimitedRange(string, range, lengthLimit: 14) ||
                !textField.isNumber(string) {
                return false
            }
            textField.formatPhoneNumber()
        
        return true
    }
}
