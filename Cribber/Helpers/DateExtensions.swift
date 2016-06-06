//
//  DateExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 6/05/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

extension NSDate {
    func toLocalTime() -> NSDate {
        let timeZone = NSTimeZone.defaultTimeZone()
        let seconds = timeZone.secondsFromGMTForDate(self)
        return NSDate(timeInterval: NSTimeInterval(seconds), sinceDate: self)
    }
    
    func toGlobalTime() -> NSDate {
        let timeZone = NSTimeZone.defaultTimeZone()
        let seconds = -timeZone.secondsFromGMTForDate(self)
        return NSDate(timeInterval: NSTimeInterval(seconds), sinceDate: self)
    }
}
