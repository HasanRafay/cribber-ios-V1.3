//
//  DateFormatterExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 8/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

extension NSDateFormatter {
    func stringFromDate(date: NSDate, sinceDate since: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: date, toDate: since, options: [])
        if (components.day < 1) {
            return "Today"
        } else if (components.day < 2) {
            return "Yesterday"
        }
        return stringFromDate(date)
    }
}
