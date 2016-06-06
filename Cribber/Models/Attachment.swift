//
//  Attachment.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import CoreData

class Attachment: NSManagedObject {

    @NSManaged var contentType: String
    @NSManaged var remoteID: NSNumber
    @NSManaged var localFilePath: String?
    @NSManaged var sourceURL: String
    @NSManaged var previewURL: String?
    @NSManaged var title: String
    @NSManaged var feedItem: FeedItem
}
