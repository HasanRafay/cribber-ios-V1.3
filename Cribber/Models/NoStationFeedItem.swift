//
//  NoStationFeedItem.swift
//  Cribber
//
//  Created by Tim Ross on 13/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class NoStationFeedItem: FeedItemInfo {
    
    @objc var from = "Cribber"
    
    @objc var subject = "Cribber Bulletin"
    
    @objc var message = "Whoops, looks like you aren't subscribed to any Cribber teams!  Don't worry... If your team is already using Cribber, let them know you've joined! If you are completely new to Cribber you can sign up your team for free."
    
    @objc var publishDate = NSDate().toGlobalTime()
    
    @objc var logoURL: String?
    
    @objc var feedItemType = FeedItemType.Local.rawValue
    
    @objc var attachments = NSOrderedSet()
}
