//
//  StationBuilder.swift
//  Cribber
//
//  Created by Tim Ross on 19/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class StationBuilder {
    
    let dataStore: CoreDataStore
    
    convenience init() {
        self.init(dataStore: CoreDataStore())
    }
    
    init(dataStore: CoreDataStore) {
        self.dataStore = dataStore
    }
    
    func stationsFromJSON(json: JSON) -> [Station] {
        deleteAllStations()
        var stations = [Station]()
        for jsonItem in json.arrayValue {
            let station = findOrCreateStation(jsonItem)
            populateStation(station, fromJSON: jsonItem)
            stations.append(station)
        }
        dataStore.saveData()
        return stations
    }
    
    private func deleteAllStations() {
        dataStore.deleteAll(Station.self)
    }
    
    private func findOrCreateStation(json: JSON) -> Station {
        return dataStore.findOrCreateBy(["remoteID": json["id"].numberValue])
    }
    
    private func populateStation(station: Station, fromJSON json: JSON) {
        station.name = json["name"].stringValue
    }
}
