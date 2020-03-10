//
//  ContactViewController.swift
//  Poolr
//
//  Created by James Li on 3/10/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit
import SCLAlertView

class ContactViewController: UIViewController {

    @IBOutlet var continueButton: UIButton!
    @IBOutlet var textInputStackView: UIStackView!
    
    let firstNameTextField = TextInputViewController(title: "First Name")
    let lastNameTextField = TextInputViewController(title: "Last Name")
    let emailTextField = TextInputViewController(title: "Email Address")
    let zipCodeTextField = TextInputViewController(title: "Zip Code")
    
    var isTextFieldAlreadyAnimated : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.setNavigationTitleView()
        self.clearLeftNavigationBackButton()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        addTextFieldsToStackView()
        continueButton.setCornerRadius()
        
        addNextButtonToTextFieldKeyboard(zipCodeTextField.textField,
                                         title:  "Done",
                                         selector: #selector(zipCodeNextButtonKeyboardTapped))
        
        emailTextField.textField.keyboardType = .emailAddress
        zipCodeTextField.textField.keyboardType = .numberPad
        
        setupSignUpDataToTextFields()
        setupTextFieldDelegate()
    }
    
    @objc func cancelTapped() {
        let appearance = ViewControllerHelper().getSCLAlertViewAppearance()
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Yes") {
            SignUpData.sharedInstance.clearData()
            if let vc = self.getHomeViewController() {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        alert.addButton("No") {}
        
        alert.showWarning("Poolu Sign Up",
                         subTitle: "Are you sure to cancel sign up?",
                          colorStyle: 0x7ED321,
                          colorTextButton: 0xFFFFFF,
                          animationStyle: .bottomToTop)
    }
    
    func getHomeViewController() -> HomeViewController? {
        let allVC = self.navigationController?.viewControllers
        
        if  let homeVC = allVC![1] as? HomeViewController {
            return homeVC;
        }
        return nil
    }
    
    func addTextFieldsToStackView() {
        let textFieldsViewControllers:[TextInputViewController] =
            [firstNameTextField, lastNameTextField, emailTextField, zipCodeTextField]
        
        for controller in textFieldsViewControllers {
            self.textInputStackView.addArrangedSubview(controller.view)
        }
        
        self.textInputStackView.axis = .vertical
        self.textInputStackView.distribution = .fillEqually
    }
    
    func addNextButtonToTextFieldKeyboard(_ textField: UITextField, title: String, selector: Selector) {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
//        let barBtnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
//                                         target: self, action: selector)
        
        let barBtnDone = UIBarButtonItem(title: title, style: .done, target: self, action: selector)
  
        toolbarDone.items = [flexSpace, barBtnDone]
        textField.inputAccessoryView = toolbarDone
    }
    
    
    @objc func zipCodeNextButtonKeyboardTapped() {
        animateTextField(textField: zipCodeTextField.textField, up:false)
        isTextFieldAlreadyAnimated = false
        
        if zipCodeTextField.text != "" {
            zipCodeTextField.validateUSZipCode()
            
        }
        self.view.endEditing(true)
    }
    
    func setupSignUpDataToTextFields() {
        self.firstNameTextField.text = SignUpData.sharedInstance.firstName
        self.lastNameTextField.text = SignUpData.sharedInstance.lastName
        self.emailTextField.text = SignUpData.sharedInstance.email
        self.zipCodeTextField.text = SignUpData.sharedInstance.zipCode
    }
    
    func setupTextFieldDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        zipCodeTextField.delegate = self
        
        
        firstNameTextField.textField.delegate = self
        lastNameTextField.textField.delegate = self
        emailTextField.textField.delegate = self
        zipCodeTextField.textField.delegate = self
    }
    
    func validateAllTextField() -> Bool {
        return
            firstNameTextField.validateFirstName() &&
            lastNameTextField.validateLastName() &&
            zipCodeTextField.validateUSZipCode() &&
            emailTextField.validateEmailAddress()
    }

    @IBAction func next(_ sender: Any) {
        if validateAllTextField()  {
            SignUpData.sharedInstance.firstName = self.firstNameTextField.text
            SignUpData.sharedInstance.lastName = self.lastNameTextField.text
            SignUpData.sharedInstance.email = self.emailTextField.text
            SignUpData.sharedInstance.zipCode = self.zipCodeTextField.text
            
            self.navigationController?.pushViewController(AddProfilePhotoViewController(),
                                                          animated: true)
        }
    }
}

extension ContactViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if string == "\n" {
            return true
        }
        
        if textField == firstNameTextField.textField {
            if !textField.isLetter(string) {
                return false
            }
        } else if textField == lastNameTextField.textField {
            if !textField.isLetter(string) {
                return false
            }
        } else if textField == zipCodeTextField.textField {
            if !textField.isLengthInLimitedRange(string, range, lengthLimit: 5) ||
                !textField.isNumber(string) {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField.textField && !isTextFieldAlreadyAnimated {
            self.animateTextField(textField: textField, up:true)
            isTextFieldAlreadyAnimated = true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            return
        }
        if textField == firstNameTextField.textField {
            firstNameTextField.validateFirstName()
        } else if textField == lastNameTextField.textField {
            lastNameTextField.validateLastName()
        } else if textField == emailTextField.textField {
           emailTextField.validateEmailAddress()
        } else if textField == zipCodeTextField.textField {
            zipCodeTextField.validateUSZipCode()
            
        }
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance:CGFloat = -120
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up {
            movement = movementDistance
        } else {
            movement = -movementDistance
        }
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

extension ContactViewController: TextInputViewControllerDelegate {
   
    
    func TextInputViewControllerDone(_ controller: TextInputViewController) {
        
        if controller == firstNameTextField {
            if firstNameTextField.text != "" {
                firstNameTextField.validateFirstName()
            }
            lastNameTextField.textField.becomeFirstResponder()
        } else if controller == lastNameTextField {
            if lastNameTextField.text != "" {
                lastNameTextField.validatePassword()
            }
            emailTextField.textField.becomeFirstResponder()
        } else if controller == emailTextField {
            if emailTextField.text != "" {
                emailTextField.validateEmailAddress()
            }
            zipCodeTextField.textField.becomeFirstResponder()
        } else if controller == zipCodeTextField {
            if zipCodeTextField.text != "" {
                zipCodeTextField.validateUSZipCode()
            }
        }
    }
    
}
