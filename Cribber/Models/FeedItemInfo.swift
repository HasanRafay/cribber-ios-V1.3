//
//  FeedItemInfo.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

@objc protocol FeedItemInfo {
    
    var from: String { get }
    var subject: String { get }
    var message: String { get }
    var publishDate: NSDate { get }
    var logoURL: String? { get }
    var feedItemType: String { get }
    var attachments: NSOrderedSet { get }
}
