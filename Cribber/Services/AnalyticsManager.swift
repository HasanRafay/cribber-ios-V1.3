//
//  AnalyticsManager.swift
//  Cribber
//
//  Created by Tim Ross on 5/05/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class AnalyticsManager {
    let tracker: GAITracker
    
    static let sharedInstance = AnalyticsManager()
    
    convenience init() {
        let ga = GAI.sharedInstance()
        ga.trackUncaughtExceptions = false
        ga.dispatchInterval = 20
        ga.logger.logLevel = .Error
        
        self.init(tracker: ga.trackerWithTrackingId(Constants.GATrackingID))
        
        print(Constants.GATrackingID)
    }
    
    init(tracker: GAITracker) {
        Log.Debug("Analytics", message: "Initialized with tracker: \(tracker.name)")
        self.tracker = tracker
    }
    
    func startSession() {
        Log.Debug("Analytics", message: "Start session")
        tracker.set(kGAISessionControl, value: "start")
    }
    
    func endSession() {
        Log.Debug("Analytics", message: "End session")
        tracker.set(kGAISessionControl, value: "end")
    }
    
    func sendScreenView(screenName: String) {
        Log.Debug("Analytics", message: "Screen view: \(screenName)")
        tracker.set(kGAIScreenName, value: screenName)
        let build = GAIDictionaryBuilder.createScreenView().build()
        tracker.send(build as [NSObject : AnyObject])
    }
    
    func sendEvent(category category: String, action: String, label: String? = nil, value: NSNumber? = nil) {
        Log.Debug("Analytics", message: "Send event: category: \(category), action: \(action), label: \(label), value: \(value)")
        let build = GAIDictionaryBuilder.createEventWithCategory(
            category, action: action, label: label, value: value
        ).build()
        tracker.send(build as [NSObject : AnyObject])
    }
}
