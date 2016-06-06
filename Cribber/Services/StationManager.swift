//
//  StationManager.swift
//  Cribber
//
//  Created by Tim Ross on 19/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class StationManager {
    
    let api: CribberAPI
    let dataStore: CoreDataStore
    let stationBuilder: StationBuilder
    
    convenience init() {
        self.init(api: CribberAPI(), dataStore: CoreDataStore(), stationBuilder: StationBuilder())
    }
    
    init(api: CribberAPI, dataStore: CoreDataStore, stationBuilder: StationBuilder) {
        self.api = api
        self.dataStore = dataStore
        self.stationBuilder = stationBuilder
    }
    
    func countStations() -> Int {
        return dataStore.count(Station.self)
    }
    
    func loadStations() -> [Station] {
        return dataStore.findAll(order: "name")
    }
}
