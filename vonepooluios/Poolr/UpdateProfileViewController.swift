//
//  UpdateProfileViewController.swift
//  Poolr
//
//  Created by James Li on 10/13/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import Toast_Swift

class UpdateProfileViewController: UIViewController {

    @IBOutlet var userPhotoImageView: UIImageView!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var textInputStackView: UIStackView!
    
    let firstNameTextField = TextInputViewController(title: "First Name")
    let lastNameTextField = TextInputViewController(title: "Last Name")
    let emailTextField = TextInputViewController(title: "Email Address")
    let zipCodeTextField = TextInputViewController(title: "Zip Code")
    let phoneNumberTextField = TextInputViewController(title: "Mobile Phone Number")
    
    let profileData = ProfileData()
    var profilePhoto: UIImage?
    var isPhotoChanged: Bool = false
    var isTextChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupProfileData() -> Bool {
        profileData.getProfileData()
        
        if profileData.hasVaildProfileData {
            firstNameTextField.text = profileData.firstName!
            lastNameTextField.text = profileData.lastName!
            emailTextField.text = profileData.email!
            zipCodeTextField.text = profileData.zipCode!
            
            phoneNumberTextField.text = profileData.phoneNumber!
            phoneNumberTextField.textField.formatPhoneNumber()
        } else {
            return false
        }
        
        return true
    }
    
    func setupViews() {
        addTextFieldsToStackView()
        if !setupProfileData() {
            return
        }
        
        setupNavigationBarItems()
        setupImagePickerTapAction()
        
        zipCodeTextField.textField.keyboardType = .numberPad
        phoneNumberTextField.textField.keyboardType = .numberPad
        emailTextField.textField.keyboardType = .emailAddress
        
        addNextButtonToTextFieldKeyboard(zipCodeTextField.textField,
                                         selector: #selector(zipCodeNextButtonKeyboardTapped))
        
        addNextButtonToTextFieldKeyboard(phoneNumberTextField.textField,
                                         selector: #selector(phoneNumberNextButtonKeyboardTapped))
        
        firstNameTextField.textField.returnKeyType = .done
        lastNameTextField.textField.returnKeyType = .done
        emailTextField.textField.returnKeyType = .done
 
        setupTextFieldDelegate()
        
        if let photo = UserDataPersistenceHelper.profilePhoto {
            showUserPhoto(photo)
            addPhotoButton.setTitle("CHANGE PHOTO", for: .normal)
        }
    }
    
    func setupTextFieldDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        zipCodeTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        firstNameTextField.textField.delegate = self
        lastNameTextField.textField.delegate = self
        emailTextField.textField.delegate = self
        zipCodeTextField.textField.delegate = self
        phoneNumberTextField.textField.delegate = self
        
    }
    
    func setupNavigationBarItems() {
        self.setNavigationTitleView()
        self.setLeftNavigationBackButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: self,
                                                                 action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func saveTapped() {
        if validateAllTextField() && isTextChanged {
            profileData.firstName = self.firstNameTextField.text
            profileData.lastName = self.lastNameTextField.text
            profileData.email = self.emailTextField.text
            profileData.phoneNumber = self.phoneNumberTextField.text
            profileData.zipCode = self.zipCodeTextField.text
            
            self.updateUser(profileData)
        } else if isPhotoChanged {
            self.uploadProfilePhoto(useSpinner: true)
        }
    }
    
    func setupImagePickerTapAction () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        userPhotoImageView.addGestureRecognizer(tapGesture)
        userPhotoImageView.isUserInteractionEnabled = true
    }
    
    func showUserPhoto(_ photo: UIImage) {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.bounds.size.width / 2.0
        userPhotoImageView.clipsToBounds = true
        
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.image = photo.resizedImage(withBounds: CGSize(width: 64.0, height: 64.0))
        
    }
    
    func addTextFieldsToStackView() {
        let textFieldsViewControllers:[TextInputViewController] =
            [firstNameTextField, lastNameTextField, emailTextField, zipCodeTextField, phoneNumberTextField]
        
        for controller in textFieldsViewControllers {
            textInputStackView.addArrangedSubview(controller.view)
        }
        
        textInputStackView.axis = .vertical
        textInputStackView.distribution = .fillEqually
    }
    
    func addNextButtonToTextFieldKeyboard(_ textField: UITextField, selector: Selector) {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let barBtnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self, action: selector)
        
        toolbarDone.items = [flexSpace, barBtnDone]
        textField.inputAccessoryView = toolbarDone
    }
    
    @objc func zipCodeNextButtonKeyboardTapped() {
        if zipCodeTextField.text != "" {
            zipCodeTextField.validateUSZipCode()
        }
        self.view.endEditing(true)
    }
    
    @objc func phoneNumberNextButtonKeyboardTapped() {
        if phoneNumberTextField.text != "" {
            phoneNumberTextField.validateUSPhoneNumber()
        }
        self.view.endEditing(true)
    }
    
    func validateAllTextField() -> Bool {
        return
            firstNameTextField.validateFirstName() &&
            lastNameTextField.validateLastName() &&
            emailTextField.validateEmailAddress() &&
            zipCodeTextField.validateUSZipCode() &&
            phoneNumberTextField.validateUSPhoneNumber()
    }
    
    func updateUser(_ profileData: ProfileData) {
        view.makeToastActivity(.center)
        AccountService.updateUser(profileData) { [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Profile Update", errorMessage: error.showError)
            } else if let userData = result,
                UserDataPersistenceHelper.persistProfileData(userData) {
                if strongSelf.isPhotoChanged {
                    strongSelf.uploadProfilePhoto(useSpinner: false)
                }
                strongSelf.view.makeToast("Profile updated successfully", duration: 3.0, position: .center)
            }
        }
    }
    
    func uploadProfilePhoto(useSpinner: Bool) {
        if useSpinner {
            view.makeToastActivity(.center)
        }
        if  let photo = self.userPhotoImageView.image,
            let compressedPhoto = UIImageJPEGRepresentation(photo, AppConstants.userPhotoCompressionQuality) {
            PhotoService.uploadUserProfilePhoto(photoData: compressedPhoto) {
                [weak self] (result, error)  in
                guard let strongSelf = self else {
                    return
                }
                if useSpinner {
                    strongSelf.view.hideToastActivity()
                }
                
                if let error = error {
                    print(error)
                } else if let _  = result {
                    UserDataPersistenceHelper.profilePhoto = photo
                    if useSpinner {
                        strongSelf.view.makeToast("Photo updated successfully", duration: 3.0, position: .center)
                    }
                }
            }
        } else {
            print("Could not compress user profile photo")
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        pickPhoto()
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Camera", style: .default, handler: {_ in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        
        let choosePhotoAction = UIAlertAction(title: "Photo Libray", style: .default, handler: {_ in self.choosePhotoFromLibrary() })
        alertController.addAction(choosePhotoAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = PlrImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = PlrImagePickerController();
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            showPhotoMenu()
        }
    }
    
    // MARK : - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.profilePhoto = photo
                self.isPhotoChanged = true
                showUserPhoto(photo)
                addPhotoButton.setTitle("CHANGE PHOTO", for: .normal)
        }
        
       
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension UpdateProfileViewController: UITextFieldDelegate {
    
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
        } else if textField == phoneNumberTextField.textField {
            if  !textField.isLengthInLimitedRange(string, range, lengthLimit: 14) ||
                !textField.isNumber(string) {
                return false
            }
            textField.formatPhoneNumber()
        } else if textField == zipCodeTextField.textField {
            if !textField.isLengthInLimitedRange(string, range, lengthLimit: 5) ||
                !textField.isNumber(string) {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextField(textField, isUp: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextField(textField, isUp: false)
        
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
        } else if textField == phoneNumberTextField.textField {
            phoneNumberTextField.validateUSPhoneNumber()
        }
        
        isTextChanged = true
    }
    
    func animateTextField(_ textField: UITextField, isUp: Bool) {
        if textField == lastNameTextField.textField {
            self.animateTextField(textField, distanct: -30, up: isUp)
        } else if textField == emailTextField.textField {
            self.animateTextField(textField, distanct: -80, up: isUp)
        } else if textField == zipCodeTextField.textField {
            self.animateTextField(textField, distanct: -160, up: isUp)
        } else if textField == phoneNumberTextField.textField {
            self.animateTextField(textField, distanct: -230, up: isUp)
        }
    }
    
    func animateTextField(_ textField: UITextField, distanct: CGFloat, up: Bool) {
        let movementDistance:CGFloat = distanct
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


extension UpdateProfileViewController: TextInputViewControllerDelegate {

    func TextInputViewControllerDone(_ controller: TextInputViewController) {
        
        if controller == firstNameTextField {
            if firstNameTextField.text != "" {
                firstNameTextField.validateFirstName()
            }
        } else if controller == lastNameTextField {
            if lastNameTextField.text != "" {
                lastNameTextField.validatePassword()
            }
        } else if controller == emailTextField {
            if emailTextField.text != "" {
                emailTextField.validateEmailAddress()
            }
        } else if controller == zipCodeTextField {
            if zipCodeTextField.text != "" {
                zipCodeTextField.validateUSZipCode()
            }
        } else if controller == phoneNumberTextField {
            if phoneNumberTextField.text != "" {
                phoneNumberTextField.validateUSPhoneNumber()
            }
        }
        
        self.isTextChanged = true
    }
}




