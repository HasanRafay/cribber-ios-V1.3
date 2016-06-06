//
//  PhoneNumber.swift
//  Cribber
//
//  Created by Tim Ross on 20/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

struct PhoneNumber {
    var prefix: Int
    var number: Int
    
    var description: String {
        return "\(prefix)\(number)"
    }
}
