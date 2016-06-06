//
//  Log.swift
//  Cribber
//
//  Created by Tim Ross on 5/05/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

class Log {
    class func Error(action: String, error: NSError? = nil) {
        print("Log - Error: \(action). \(error)")
        var attributes = ["action": action]
        if error != nil {
            attributes["code"] = String(error!.code)
            attributes["description"] = error!.localizedDescription
            attributes["reason"] = error!.localizedFailureReason
        }
        NewRelic.recordEvent("Error", attributes: attributes)
    }
    
    class func Debug(action: String, message: String) {
#if DEBUG
        print("Log - Debug: \(action). \(message)")
#endif
    }
}
