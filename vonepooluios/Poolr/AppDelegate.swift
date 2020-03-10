//
//  AppDelegate.swift
//  Poolr
//
//  Created by James Li on 7/2/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        presentRootController()
        registerForNotifications()
        return true
    }
    
    private func presentRootController(tabIndex: Int? = 0) {
        var controller: UIViewController =  WalkThroughViewController()
        
        if let _ = UserDataPersistenceHelper.phoneNumber {
            controller = PlrTabBarController()
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = PlrNavigationController.init(rootViewController: controller)
        window!.makeKeyAndVisible()
    }
    
    private func registerForNotifications() {
        let userNotification = UNUserNotificationCenter.current()
        userNotification.delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                userNotification.requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    guard granted else { return }
                }
            }
        }
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        if components.url?.absoluteString == AppConstants.poolLink {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            navigationController.pushViewController(PlrTabBarController(), animated: false)
        }
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = PlrTabBarController()
        vc.tabIndex = 1
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = PlrNavigationController.init(rootViewController: vc)
        window!.makeKeyAndVisible()

        completionHandler()
    }
    
}

