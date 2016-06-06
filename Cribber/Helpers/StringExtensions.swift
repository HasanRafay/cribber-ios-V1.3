//
//  StringExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 28/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

extension String {
    func stringByRemovingSpaces() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}