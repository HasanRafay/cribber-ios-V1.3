//
//  FeedManager.swift
//  Cribber
//
//  Created by Tim Ross on 8/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class FeedManager {
    
    let api: CribberAPI
    let feedBuilder: FeedBuilder
    let stationBuilder: StationBuilder
    let dataStore: CoreDataStore
    
    convenience init() {
        self.init(api: CribberAPI(), feedBuilder: FeedBuilder(), stationBuilder: StationBuilder(), dataStore: CoreDataStore())
    }
    
    init(api: CribberAPI, feedBuilder: FeedBuilder, stationBuilder: StationBuilder, dataStore: CoreDataStore) {
        self.api = api
        self.feedBuilder = feedBuilder
        self.stationBuilder = stationBuilder
        self.dataStore = dataStore
    }
    
    func loadFeedItems(onlyPinned onlyPinned : Bool = false) -> [FeedItem] {
        if onlyPinned {
            return dataStore.findAllBy(["pinned": true], order: "order")
        } else {
            return dataStore.findAll(order: "order")
        }
    }

    func fetchFeed(completion: (error: NSError?) -> Void) {
        api.fetchFeed({
            (json, error) in
            if error != nil {
                Log.Error("Fetching feed items", error: error)
                completion(error: error)
            } else {
                self.stationBuilder.stationsFromJSON(json!["communities"])
                self.feedBuilder.feedItemsFromJSON(json!["noticeboard"])
                completion(error: nil)
            }
        })
    }
}
