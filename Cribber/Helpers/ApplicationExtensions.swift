//
//  ApplicationExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 30/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func appVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "\(version)" : "\(version) (\(build))"
    }

    func topViewController() -> UIViewController {
        var topController = keyWindow!.rootViewController
        while (topController?.presentedViewController != nil) {
            topController = topController!.presentedViewController
        }

        return topController!
    }
}
