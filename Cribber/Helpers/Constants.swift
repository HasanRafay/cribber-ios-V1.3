//
//  Constants.swift
//  Cribber
//
//  Created by Tim Ross on 9/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

struct Constants {
    static let AttachmentItemHeight = CGFloat(165)
    static let UserDidSignInNotification = "UserDidSignInNotification"
    static let UserDidSignOutNotification = "UserDidSignOutNotification"
    static let ApplicationDidReceiveRemoteNotification = "ApplicationDidReceiveRemoteNotification"
    static let NoticeboardPageSize = 25
    static let CribberErrorDomain = "com.cribber.error"
    static let ParseApplicationID = "L9mqvmjMZsu5EyC72uSE7Ut2GpuAKHFaETk2umoC"
    static let ParseClientKey = "amQQvgz4QQpzcRepNY7LwDxbdbkDr9TFK3kk6OBX"
    static let FeedbackSubject = "Cribber Feedback"
    static let FeedbackRecipient = "support@cribber.com"
    static let GATrackingID = NSBundle.mainBundle().objectForInfoDictionaryKey("GATrackingID") as! String
    static let NewRelicToken = NSBundle.mainBundle().objectForInfoDictionaryKey("NewRelicToken") as! String
    static let PrivacyPolicyURL = NSURL(string: "http://www.cribber.com/privacy/")!
    static let TermsOfServiceURL = NSURL(string: "http://www.cribber.com/terms/")!
}
