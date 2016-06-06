//
//  FeedBuilder.swift
//  Cribber
//
//  Created by Tim Ross on 15/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedBuilder {
    
    let dataStore: CoreDataStore
    
    convenience init() {
        self.init(dataStore: CoreDataStore())
    }
    
    init(dataStore: CoreDataStore) {
        self.dataStore = dataStore
    }
    
    func feedItemsFromJSON(json: JSON) -> [FeedItem] {
        deleteAllFeedItems()
        var feedItems = [FeedItem]()
        for (index, jsonItem) in (json.arrayValue).enumerate() {
            let feedItem = createFeedItem(jsonItem)
            populateFeedItem(feedItem, fromJSON: jsonItem)
            feedItem.order = NSNumber(integer: index)
            feedItems.append(feedItem)
        }
        dataStore.saveData()
        return feedItems
    }
    
    private func deleteAllFeedItems() {
        dataStore.deleteAll(FeedItem.self)
    }
    
    private func createFeedItem(json: JSON) -> FeedItem {
        return dataStore.createEntity()
    }
    
    private func populateFeedItem(feedItem: FeedItem, fromJSON json: JSON) {
        feedItem.remoteID = json["id"].numberValue
        feedItem.feedItemType = json["type"].stringValue
        feedItem.pinned = json["pinned"].boolValue
        feedItem.from = json["from"].stringValue
        feedItem.logoURL = json["logo_url"].string
        feedItem.subject = json["subject"].stringValue
        feedItem.message = json["message"].stringValue
        feedItem.publishDate = dateFromString(json["sent_at"].stringValue)!
        feedItem.attachments = buildAttachments(json)
    }
    
    private func buildAttachments(json: JSON) -> NSOrderedSet {
        var attachments = [Attachment]()
        if let jsonArray = json["attachments"].array {
            for jsonItem in jsonArray {
                let attachment = findOrCreateAttachment(jsonItem)
                populateAttachment(attachment, fromJSON: jsonItem)
                attachments.append(attachment)
            }
        }
        return NSOrderedSet(array: attachments)
    }
    
    private func findOrCreateAttachment(json: JSON) -> Attachment {
        return dataStore.findOrCreateBy(["remoteID": json["id"].numberValue])
    }
    
    private func populateAttachment(attachment: Attachment, fromJSON json: JSON) {
        attachment.remoteID = json["id"].numberValue
        attachment.contentType = json["content_type"].stringValue
        attachment.title = json["title"].stringValue
        attachment.sourceURL = json["source_url"].stringValue
        attachment.previewURL = json["preview_url"].string
    }
    
    private func dateFromString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.dateFromString(dateString)
    }
}
