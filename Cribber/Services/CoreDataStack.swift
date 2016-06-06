//
//  CoreDataStack.swift
//  Cribber
//
//  Created by Tim Ross on 15/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject, UIAlertViewDelegate {
    
    let persistentStoreFileName = "Cribber.sqlite"
    
    static let sharedInstance = CoreDataStack()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Cribber", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreURL, options: self.autoMigrateOptions)
        } catch let error as NSError {
            coordinator = nil
            Log.Error("Initialising Core Data", error: error)
            dispatch_async(dispatch_get_main_queue()) {
                self.showFatalAlert()
            }
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    var applicationDocumentsDirectory: NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as NSURL!
    }
    
    var persistentStoreURL: NSURL {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.persistentStoreFileName)
    }
    
    var autoMigrateOptions: [String: Bool] {
        return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    }
    
    func showFatalAlert() {
        UIAlertView(
            title: "A fatal error occurred",
            message: "This app will quit when you tap OK. Please re-launch the app.",
            delegate: self,
            cancelButtonTitle: "OK"
        ).show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        abort()
    }
    
    func saveContext() throws {
        if let moc = self.managedObjectContext {
            if moc.hasChanges {
                try moc.save()
            }
        }
    }
}
