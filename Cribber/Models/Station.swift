//
//  Station.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import CoreData

class Station: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var remoteID: NSNumber
}
