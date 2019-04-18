//
//  CoreDataManager.swift
//  Last.fm client
//
//  Created by student on 4/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    //MARK: Properties
    
    static let instance = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init(){
        
    }
    
    func addNewObject(withEntityName name: String, withProperties props: [String: Any]) {
        
        let entity = NSEntityDescription.entity(forEntityName: name, in: persistentContainer.viewContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext)
        
        managedObject.setValuesForKeys(props)
        saveContext()
    
    }
    
    func editObject(withInstance managedObject: NSManagedObject, withProperties props: [String: Any]){
        
        managedObject.setValuesForKeys(props)
        saveContext()
    }
    
    func deleteObject(withInstance managedObject: NSManagedObject){
        
        persistentContainer.viewContext.delete(managedObject)
        saveContext()
    }
    
    func loadData(withEntityName name: String) -> [NSManagedObject] {
        
        var result: [NSManagedObject]
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch items", err)
            result = []
        }
        
        return result
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
