//
//  ErrorResponse.swift
//  Cribber
//
//  Created by Tim Ross on 28/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import HTTPStatusCodes

struct ErrorResponse {
    var code: HTTPStatusCode
    var status = "error"
    var message = String()
    
    init(code: HTTPStatusCode, json: JSON) {
        self.code = code
        if let status = json["status"].string {
            self.status = status
        }
        if let message = json["message"].string {
            self.message = message
        }
    }
    
    var userInfo: [String: String] {
        return [
            NSLocalizedDescriptionKey: code.localizedReasonPhrase.capitalizedString,
            NSLocalizedFailureReasonErrorKey: message
        ]
    }
    
    var error: NSError {
        return NSError(domain: Constants.CribberErrorDomain,
            code: code.rawValue,
            userInfo: userInfo)
    }
}
