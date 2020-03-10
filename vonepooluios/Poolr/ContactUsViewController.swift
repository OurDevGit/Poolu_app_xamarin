//
//  ContactUsViewController.swift
//  Poolr
//
//  Created by James Li on 4/26/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {

    @IBOutlet weak var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitleView()
        setLeftNavigationBackButton()
        sendEmailButton.setCornerRadius()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([AppConstants.pooluSupportEmail])
            mailComposerVC.setSubject("Question / Feedback")
            mailComposerVC.setMessageBody("Hello Poolu,", isHTML: false)
            
            present(mailComposerVC, animated: true, completion: nil)
        } else {
            ViewControllerHelper().showSCLErrorAlert(title: "Can not send email", errorMessage: "Your phone could not send email")
        }
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
