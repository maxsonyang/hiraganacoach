//
//  TestCoreDataManagerClass.swift
//  hiraganacoachTests
//
//  Created by Maxson Yang on 11/8/20.
//

import CoreData
//@testable import hiraganacoach

class TestCoreDataManager : RevisedCoreDataManager {
    
    /*
        Class that allows for testing of CoreData by modifying
        the CDM to use in-memory storage (which will not persist
        once the app is closed).
     */
    
    override init()
    {
        super.init()
        
        let persistentStorageDescription = NSPersistentStoreDescription()
        persistentStorageDescription.type = NSInMemoryStoreType
        
        let inMemoryContainer = NSPersistentContainer(name: RevisedCoreDataManager.modelName, managedObjectModel: RevisedCoreDataManager.model)
        
        inMemoryContainer.persistentStoreDescriptions = [persistentStorageDescription]
        
        inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Could not load container: \(error.debugDescription)")
            }
        }
        
        container = inMemoryContainer
    }
    
}
