//
//  ViewControllerExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 20/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

public extension UIViewController {
    func showErrorAlert(error: NSError) {
        let title = error.localizedDescription ?? NSLocalizedString("Error", comment: "")
        showAlert(title, message: error.localizedFailureReason ?? "")
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
