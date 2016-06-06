//
//  AppDelegate.swift
//  Cribber
//
//  Created by Tim Ross on 23/03/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    var authManager: AuthenticationManager!
    
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }
    
    // MARK: - UIApplicationDelegate methods

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NewRelicAgent.startWithApplicationToken(Constants.NewRelicToken)
        AnalyticsManager.sharedInstance.startSession()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard?.instantiateInitialViewController()
        
        Parse.setApplicationId(Constants.ParseApplicationID, clientKey: Constants.ParseClientKey)
        
        // Only register for push notifications on iPhone
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            registerPushNotifications(application)
        }
        
        Styles.setupAppearance()
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(AppDelegate.userDidSignIn), name: Constants.UserDidSignInNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(AppDelegate.userDidSignOut), name: Constants.UserDidSignOutNotification, object: nil)
        
        authManager = AuthenticationManager.sharedInstance
        
        ensureNoticeboardIsLoaded()
        checkAuthentication()
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        let currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveEventually(nil)
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        AnalyticsManager.sharedInstance.startSession()
        checkAuthentication()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        AnalyticsManager.sharedInstance.endSession()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        try! CoreDataStack.sharedInstance.saveContext()
        AnalyticsManager.sharedInstance.endSession()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.addUniqueObject("user_\(installation.deviceToken!)", forKey: "channels")
        installation.saveInBackgroundWithBlock(nil)
        Log.Debug("Registered for remote notifications", message: "deviceToken: \(installation.deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Log.Debug("Failed to register for remote notifications", message: "error: \(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        Log.Debug("Received notification", message: "applicationState: \(application.applicationState.rawValue)")
        if application.applicationState == .Active {
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.ApplicationDidReceiveRemoteNotification, object: self)
        }
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            if let navController = rootViewController?.presentedViewController as? UINavigationController {
                if let attachmentController = navController.topViewController as? AttachmentPreviewController {
                if attachmentController.isPresented {
                    return UIInterfaceOrientationMask.AllButUpsideDown
                }
                }
            }
            return UIInterfaceOrientationMask.Portrait
        }
    }
    
    func registerPushNotifications(application: UIApplication) {
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    // MARK: - Helper methods
    
    func ensureNoticeboardIsLoaded() {
        let viewController = window?.rootViewController as! UINavigationController
        let noticeBoardViewController = viewController.topViewController as! NoticeboardViewController
        _ = noticeBoardViewController.view
    }
    
    func checkAuthentication() {
        if authManager.isAuthenticated {
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.UserDidSignInNotification, object: self)
        } else {
            displaySignupViewController()
        }
    }
    
    func displaySignupViewController() {
        if let signupNavController = storyboard?.instantiateViewControllerWithIdentifier("signupNavController") {
            rootViewController?.presentViewController(signupNavController, animated: true, completion: nil)
        }
    }
    
    func userDidSignIn() {
        if let phoneNumber = authManager.phoneNumber {
            NewRelic.setAttribute("phone_number", value: phoneNumber)
        }
        Log.Debug("Signed in", message: "phone_number: \(authManager.phoneNumber)")
    }
    
    func userDidSignOut() {
        displaySignupViewController()
    }
}
