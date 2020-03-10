//
//  TextInputViewController.swift
//  Poolr
//
//  Created by James Li on 7/15/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

protocol TextInputViewControllerDelegate: class {
    func TextInputViewControllerDone(_ controller: TextInputViewController)
}

class TextInputViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate: TextInputViewControllerDelegate?
    
    var text: String {
        get {
            if let txt = textField.text {
                return txt
            } else {
                return ""
            }
        }
        set {
            textField.text = newValue
        }
    }
    
    private var TextFieldTitle: String
    
    init(title: String) {
        TextFieldTitle = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.setBottomBorder()
        self.titleLabel.text = TextFieldTitle
        self.titleLabel.setTextSpacing(0.3)
    }

    @IBAction func done(_ sender: Any) {
        delegate?.TextInputViewControllerDone(self)
    }
    
   @discardableResult func validateEmailAddress() -> Bool {
        if textField.validateEmailAddress() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.emailValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validatePassword() -> Bool {
        if textField.validatePassword() {
            clearError()
            return true;
        } else {
            setErrorMessage(AppConstants.passwordValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateReEnterPassword(_ password: String) -> Bool {
        if textField.validateReEnterPassword(password)  {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.reEnterPasswordValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateFirstName() -> Bool {
        if textField.validateName() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.firstNameValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateLastName() -> Bool {
        if textField.validateName() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.lastNameValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateUSZipCode() -> Bool {
        if textField.validateUSZipCode() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.zipCodeValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateUSPhoneNumber() -> Bool {
        if textField.validateUSPhone() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.phoneNumberValidationErrorMessage)
            return false
        }
    }
    
    @discardableResult func validateVerificationCode() -> Bool {
        if textField.validateVerificationCode() {
            clearError()
            return true
        } else {
            setErrorMessage(AppConstants.verificationCodeValidationErrorMessage)
            return false
        }
    }
    
    
    func setErrorMessage(_ errorMessage: String) {
        errorLabel.text = errorMessage
        textField.setBottomBorder(cgColor: AppConstants.textFieldBottomBoarderErrorColor)
    }
    
    func clearError() {
        errorLabel.text = ""
        textField.setBottomBorder(cgColor: AppConstants.textFieldBottomBoarderNormalColor)
    }

}




