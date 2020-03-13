//
//  AddProfilePhotoViewController.swift
//  Poolr
//
//  Created by James Li on 9/30/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import Toast_Swift
import SCLAlertView
import OneSignal

class AddProfilePhotoViewController: UIViewController {
    
    @IBOutlet var userPhotoImageView: UIImageView!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var joinPoolrButton: UIButton!
    @IBOutlet var termsAndPolicyTextView: UITextView!
    
    let termsUrlString = "terms"
    let policyUrlString = "policy"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        setupNavigationBarItems()
        setupImagePickerTapAction()
       
        setupTermsAndPolicyTapAction()
        self.addPhotoButton.contentHorizontalAlignment = .center
        joinPoolrButton.setCornerRadius()
        
        
        if let photo = SignUpData.sharedInstance.photo {
            showUserPhoto(photo)
            addPhotoButton.setTitle("CHANGE PHOTO", for: .normal)
        }
    }
    
    func setupNavigationBarItems() {
        self.setNavigationTitleView()
        self.setLeftNavigationBackButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
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
        userPhotoImageView.image = photo.resizedImage(withBounds: CGSize(width: 160.0, height: 160.0))
        
    }
    
    func setupTermsAndPolicyTapAction() {
        
        let fontAttr = UIFont(name: "Avenir-Roman", size: 12)
        let fontColorAttrBlue = UIColor(red: 109.0 / 255.0, green: 110.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0)

        let attributedString = NSMutableAttributedString(string: AppConstants.joinPoolrComfirmMessage,
                                                         attributes: [.font: fontAttr!,
                                                                      .foregroundColor: fontColorAttrBlue])

        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor(white: 51.0 / 255.0, alpha: 1.0),
                                      range: NSRange(location: 16, length: 10))
        
        var foundRange = attributedString.mutableString.range(of: "Terms and Conditions")
        attributedString.addAttribute(.link, value: URL(string: termsUrlString)!, range: foundRange)
        foundRange = attributedString.mutableString.range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: policyUrlString, range: foundRange)
        
        termsAndPolicyTextView.attributedText = attributedString
        termsAndPolicyTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: AppConstants.lightGreen]
        termsAndPolicyTextView.delegate = self
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func joinPoolr(_ sender: Any) {
        UserDataPersistenceHelper.profilePhoto = nil
        self.createUser()
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
    
    func createUser() {
        view.makeToastActivity(.center)
        
        AccountService.createUser(SignUpData.sharedInstance) {  [weak self] (result, error)  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.hideToastActivity()
            if let error = error {
                print(error)
                ViewControllerHelper().showSCLErrorAlert(title: "Sign Up Error", errorMessage: error.showError)
            } else if let userData = result, UserDataPersistenceHelper.persistAccountData(userData) {
                let myCustomUniqueUserId = userData.userId
                
                OneSignal.setExternalUserId(myCustomUniqueUserId ?? "")
                SignUpData.sharedInstance.oneSignalId = userData.userId ?? "";
                if let photo = SignUpData.sharedInstance.photo {
                    strongSelf.uploadSignUpProfilePhoto(photo)
                } else {
                    strongSelf.navigationController?.pushViewController(PlrTabBarController(), animated: true)
                }
                SignUpData.sharedInstance.clearData()
            }
        }
    }
    
    func uploadSignUpProfilePhoto(_ photo: UIImage) {
        let quality = AppConstants.userPhotoCompressionQuality
        let resizedPhoto = photo.resizedImage(withBounds: CGSize(width: AppConstants.userPhotoUploadWidth,
                                                                 height: AppConstants.userPhotoUploadHight))
        
        if let compressedPhoto = UIImageJPEGRepresentation(resizedPhoto, quality) {
            PhotoService.uploadUserProfilePhoto(photoData: compressedPhoto) {
                [weak self] (result, error)  in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print(error)
                } else if let _ = result {
                    UserDataPersistenceHelper.profilePhoto = resizedPhoto
                }
                strongSelf.navigationController?.pushViewController(PlrTabBarController(), animated: true)
            }
        } else {
            print("Could not compress user profile photo")
        }
    }

}

extension AddProfilePhotoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == termsUrlString) {
            pushTermsOrPolicyViewController(urlString: termsUrlString)
        } else if (URL.absoluteString == policyUrlString) {
            pushTermsOrPolicyViewController(urlString: policyUrlString)
        }
        return false
    }
    
    func pushTermsOrPolicyViewController(urlString: String) {
        var controller : UIViewController?
        
        if urlString == termsUrlString {
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.termsAndConditionsUrlString)
        } else if urlString == policyUrlString {
            controller = ViewControllerHelper().loadDocumentInWebView(
                withUrlString: AppConstants.privacyPolicyUrlString)
        }
        
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension AddProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        let choosePhotoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {_ in self.choosePhotoFromLibrary() })
        alertController.addAction(choosePhotoAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = PlrImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = PlrImagePickerController();
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        
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
                SignUpData.sharedInstance.photo = photo
                showUserPhoto(photo)
                addPhotoButton.setTitle("CHANGE PHOTO", for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

