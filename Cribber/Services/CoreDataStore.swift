//
//  CoreDataStore.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore {
    
    let coreDataStack: CoreDataStack
    
    convenience init() {
        self.init(coreDataStack: CoreDataStack.sharedInstance)
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        return coreDataStack.managedObjectContext
    }
    
    func saveData() {
        do {
            try coreDataStack.saveContext()
        } catch let error as NSError {
            Log.Error("Saving data", error: error)
        }
    }
    
    func findOrCreateBy<T:NSManagedObject>(params: [String: AnyObject]) -> T {
        if let entity = findBy(params) as T? {
            return entity
        }
        return createEntity(params)
    }
    
    func createEntity<T:NSManagedObject>() -> T {
        return createEntity([String: AnyObject]())
    }
    
    func createEntity<T:NSManagedObject>(params: [String: AnyObject]) -> T {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(
            T.nameOfClass, inManagedObjectContext: managedObjectContext!) 
        for key in params.keys {
            entity.setValue(params[key], forKey: key)
        }
        return entity as! T
    }
    
    func findBy<T:NSManagedObject>(params: [String: AnyObject]) -> T? {
        let fetchRequest = NSFetchRequest(entityName: T.nameOfClass)
        fetchRequest.predicate = buildPredicate(params)

        do {
            let entities = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [T]
            return entities!.first
        } catch let error as NSError {
            Log.Error("Fetching \(T.nameOfClass) entity", error: error)
            return nil
        }
    }
    
    func findAll<T:NSManagedObject>() -> [T] {
        return findAll(order: nil)
    }
    
    func findAll<T:NSManagedObject>(order order: String?, ascending: Bool = true) -> [T] {
        return findAllBy(nil, order: order, ascending: ascending)
    }

    func findAllBy<T:NSManagedObject>(params: [String: AnyObject]?, order: String?, ascending: Bool = true) -> [T] {
        let fetchRequest = NSFetchRequest(entityName: T.nameOfClass)

        if order != nil {
            let sortDescriptor = NSSortDescriptor(key: order!, ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }

        fetchRequest.predicate = buildPredicate(params)

        do {
            let entities = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [T]
            return entities!
        } catch let error as NSError {
            Log.Error("Fetching \(T.nameOfClass) entities", error: error)
            return [T]()
        }
    }
    
    func count<T:NSManagedObject>(type: T.Type) -> Int {
        let fetchRequest = NSFetchRequest(entityName: T.nameOfClass)
        fetchRequest.includesSubentities = false
        
        var error: NSError?
        let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: &error)
        if(count == nil) {
            Log.Error("Counting \(T.nameOfClass) entities", error: error)
        }
        return count!
    }
    
    func delete<T:NSManagedObject>(entity: T) {
        managedObjectContext?.deleteObject(entity)
    }
    
    func deleteAll<T:NSManagedObject>(type: T.Type) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: T.nameOfClass)
        fetchRequest.includesPropertyValues = false
        
        do {
            let entities = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [T]
            for entity in entities! {
                delete(entity)
            }
        } catch let error as NSError {
            Log.Error("Fetching \(T.nameOfClass) entities for deletion", error: error)
            return false
        }
        return true
    }

    private func buildPredicate(params: [String: AnyObject]?) -> NSPredicate? {
        if let predicates = params {
            if predicates.count > 0 {
                let format = predicates.keys.map({"(\($0) == %@)"}).joinWithSeparator(" AND ")
                return NSPredicate(format: format, argumentArray: Array(predicates.values))
            }
        }

        return nil
    }
}
