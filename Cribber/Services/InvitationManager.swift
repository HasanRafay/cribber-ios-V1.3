//
//  InvitationManager.swift
//  Cribber
//
//  Created by Tim Ross on 19/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

class InvitationManager {
    
    let api: CribberAPI
    let dataStore: CoreDataStore
    
    convenience init() {
        self.init(api: CribberAPI(), dataStore: CoreDataStore())
    }
    
    init(api: CribberAPI, dataStore: CoreDataStore) {
        self.api = api
        self.dataStore = dataStore
    }
    
    func acceptInvitation(feedItem: FeedItem, completion: (error: NSError?) -> Void) {
        assert(feedItem.feedItemType == FeedItemType.Invitation.rawValue, "Invalid feed item type")
        api.acceptInvitation(feedItem.remoteID, response: {
            (json, error) in
            if error != nil {
                Log.Error("Accepting invitation", error: error)
            } else {
                self.deleteLocalFeedItem(feedItem)
            }
            completion(error: error)
        })
    }
    
    private func deleteLocalFeedItem(feedItem: FeedItem) {
        dataStore.delete(feedItem)
        dataStore.saveData()
    }
}
