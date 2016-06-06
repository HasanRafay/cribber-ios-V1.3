//
//  Country.swift
//  Cribber
//
//  Created by Tim Ross on 27/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

struct Country {
    var code: String
    var name: String
    var prefix: Int
    
    static let all = [
        Country(code: "AU", name: "Australia", prefix: 61),
        Country(code: "NZ", name: "New Zealand", prefix: 64),
        Country(code: "GB", name: "United Kingdom", prefix: 44),
        Country(code: "US", name: "United States", prefix: 1)
    ]
}
