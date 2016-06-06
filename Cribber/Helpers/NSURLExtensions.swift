//
//  NSURLExtensions.swift
//  Cribber
//
//  Created by Resolve Digital on 20/10/15.
//  Copyright © 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import SafariServices

extension NSURL {
    func openInSafari() {
        let application = UIApplication.sharedApplication()

        if scheme.hasPrefix("http") {
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(URL: self)
                application.topViewController().presentViewController(svc, animated: true, completion: nil)

                return
            }
        }

        application.openURL(self)
    }
}