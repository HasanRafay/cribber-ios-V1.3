//
//  SignupFormHelper.swift
//  Cribber
//
//  Created by Tim Ross on 8/05/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class SignupFormHelper {
    class func keyboardHeightFromUserInfo(info: NSDictionary) -> CGFloat {
        let value: NSValue = info.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let frame = value.CGRectValue().size
        return frame.height
    }
    
    class func offsetForOrientation() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad && UIInterfaceOrientationIsPortrait(orientation) {
            return CGFloat(200)
        } else {
            return CGFloat(10)
        }
    }
}
