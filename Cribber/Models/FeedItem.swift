//
//  FeedItem.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import CoreData

class FeedItem: NSManagedObject {

    @NSManaged var from: String
    @NSManaged var remoteID: NSNumber
    @NSManaged var order: NSNumber
    @NSManaged var logoURL: String?
    @NSManaged var message: String
    @NSManaged var publishDate: NSDate
    @NSManaged var pinned: Bool
    @NSManaged var subject: String
    @NSManaged var feedItemType: String
    @NSManaged var attachments: NSOrderedSet
}
