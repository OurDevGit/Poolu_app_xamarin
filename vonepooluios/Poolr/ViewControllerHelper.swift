//
//  ViewControllerHelper.swift
//  Poolr
//
//  Created by James Li on 9/16/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import UserNotifications

class ViewControllerHelper {
    
    func loadViewBackground(_ uiView: UIView, imageName: String) {
        UIGraphicsBeginImageContext(uiView.frame.size)
        UIImage(named: imageName)?.draw(in: uiView.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        uiView.contentMode = UIViewContentMode.scaleAspectFit
        uiView.backgroundColor = UIColor(patternImage: image)
    }
    
    func addTopBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    func getSCLAlertViewAppearance() -> SCLAlertView.SCLAppearance {
        return SCLAlertView.SCLAppearance(
            kWindowWidth: 320,
            kWindowHeight: 280,
            kTitleFont: UIFont(name: "Avenir-Roman", size: 17)!,
            kTextFont: UIFont(name: "Avenir-Roman", size: 13)!,
            kButtonFont: UIFont(name: "Avenir-Roman", size: 17)!,
            showCloseButton: false,
            contentViewCornerRadius: 4,
            buttonCornerRadius: 4
        )
    }
    
    func showSCLErrorAlert(title: String, errorMessage: String) {
        let appearance = getSCLAlertViewAppearance()
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Close"){}
        alert.showError(title,
                        subTitle: errorMessage,
                        colorStyle:0x7ED321,
                        colorTextButton: 0xFFFFFF,
                        animationStyle: .bottomToTop)
    }
    
    func addStatusBarBackgroundForIphoneX() {
        if UIScreen.main.nativeBounds.height == 2436 {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = UIColor(patternImage: UIImage(named: "phBackground")!)
        }
    }
    
    func removeStatusBarBackgroundForIphoneX() {
        if UIScreen.main.nativeBounds.height == 2436 {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = UIColor.clear
        }
    }
    
    func formatLotteryNumbers(numbers: String) -> NSAttributedString {
        let lottoNumbers = NSMutableAttributedString(string: numbers, attributes: [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Medium", size: 14.0)!])
        let colorBallColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 0.8)
        lottoNumbers.addAttribute(NSAttributedStringKey.foregroundColor, value: colorBallColor, range: NSRange(location:14, length:3))
        
        return lottoNumbers
    }
    
    func scheduleLocalNotification(poolName: String, timeInterval: Double) {
        if let notificationOn = UserDataPersistenceHelper.isNotificationOn, notificationOn == false {
            return
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            (requests) in
            for request in requests {
                if request.identifier == poolName {
                    return
                }
            }
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = poolName + " Results"
            notificationContent.body = "Did you win the lottery? Let's find out!"
            
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: poolName, content: notificationContent, trigger: notificationTrigger)
            
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        })
    }
    
    func removeNotification(poolName: String)  {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            (requests) in
            for request in requests {
                if request.identifier == poolName {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [poolName])
                    return 
                }
            }
        })
    }
    
    func loadDocumentInWebView(withUrlString urlString: String) -> UIViewController {
        let vc = DocumentWebViewController()
        vc.documentUrlString = urlString
        return vc
    }
    
}
