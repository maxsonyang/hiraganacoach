//
//  Persistence.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/21/20.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "hiraganacoach")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

class CoreDataManager {
    
    let viewContext = PersistenceController().container.viewContext
    
    func createNewAssessmentMetadata(id : String, assessmentType : String, language : String)
    {
        let assessmentMetadataEntity = NSEntityDescription.entity(forEntityName: "AssessmentMetadata", in: viewContext)!
        let assessmentMetadata = AssessmentMetadata(entity: assessmentMetadataEntity, insertInto: viewContext)
        
        assessmentMetadata.setValue(id, forKey: "id")
        assessmentMetadata.setValue(false, forKey: "mastered")
        assessmentMetadata.setValue(0, forKey: "highestStreak")
        assessmentMetadata.setValue(assessmentType, forKey: "assessmentType")
        assessmentMetadata.setValue(language, forKey: "language")
        saveContext()
    }
    
    func fetchAssessmentMetadata(id : String, assessmentType : String, language: String) -> [AssessmentMetadata]
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        let id_predicate = NSPredicate(format: "id == %@", id)
        let languagePredicate = getLanguageEqualityPredicate(language: language)
        let assessmentType_predicate = NSPredicate(format: "assessmentType == %@", assessmentType)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [id_predicate, assessmentType_predicate, languagePredicate])
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print(error)
        }
        
        return []
    }
    
    func fetchMasteryArray(language: String) -> [String : Bool]
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        let predicate = getLanguageEqualityPredicate(language: language)
        fetchRequest.propertiesToFetch = ["mastered", "id"]
        fetchRequest.predicate = predicate
        do {
            let results = try viewContext.fetch(fetchRequest)
            var mapping : [String : Bool] = [:]
            for context in results
            {
                mapping[context.id!] = context.mastered
            }
            return mapping
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return [:]
    }
    
    func fetchLanguageScore(language : String) -> Int
    {
        let fetchRequest = NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
        let languagePredicate = getLanguageEqualityPredicate(language: language)
        fetchRequest.propertiesToFetch = ["correct"]
        fetchRequest.predicate = languagePredicate
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.map {
                Int($0.correct)
            }.reduce(0, +)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return -1
    }
    
    func fetchHighestStreak(language : String) -> Int
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        let languageEqualityPredicate = getLanguageEqualityPredicate(language: language)
        fetchRequest.propertiesToFetch = ["highestStreak"]
        fetchRequest.predicate = languageEqualityPredicate
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results.map {
                Int($0.highestStreak)
            }.reduce(0, max)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return -1
    }
    
    func fetchAllCharacterRecords() -> [CharacterRecord]
    {
        let fetchRequest = NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch let error as NSError
        {
            print(error.debugDescription)
        }
        return []
    }
    
    func deleteAllCharacterRecords()
    {
        let records = fetchAllCharacterRecords()
        for record in records
        {
            deleteCharacterRecord(characterRecord: record)
        }
    }
    
    func deleteCharacterRecord(characterRecord: CharacterRecord)
    {
        viewContext.delete(characterRecord)
        saveContext()
    }
    
    func fetchAllAssessmentMetadataForLanguage(language: String) -> [AssessmentMetadata]
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        let predicate = getLanguageEqualityPredicate(language: language)
        fetchRequest.predicate = predicate
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return []
    }
    
    func fetchAllAssessmentMetadata() -> [AssessmentMetadata]
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    
    func deleteAllAssessmentMetadata()
    {
        let metadata = fetchAllAssessmentMetadata()
        for data in metadata
        {
            deleteAssessmentMetadata(metadata: data)
        }
    }
    
    func deleteAssessmentMetadata(metadata: AssessmentMetadata)
    {
        viewContext.delete(metadata)
        saveContext()
    }
    
    func getAssessmentMetadata(id: String, assessmentType: String, language: String) -> AssessmentMetadata
    {
        var result = fetchAssessmentMetadata(id : id, assessmentType: assessmentType, language: language)
        if result.isEmpty
        {
            createNewAssessmentMetadata(id: id, assessmentType: assessmentType, language: language)
            result = fetchAssessmentMetadata(id: id, assessmentType: assessmentType, language: language)
            return result[0]
        }
        return result[0]
    }
    
    func createNewCharacterRecord(character : String, language : String)
    {
        let characterRecordEntity = NSEntityDescription.entity(forEntityName: "CharacterRecord", in: viewContext)!
        let characterRecord = CharacterRecord(entity: characterRecordEntity, insertInto: viewContext)
        let confusionIndex : [String : [String : NSNumber]] = [:]
        
        characterRecord.setValue(character, forKey: "character")
        characterRecord.setValue(0, forKey: "correct")
        characterRecord.setValue(0, forKey: "attempts")
        characterRecord.setValue(confusionIndex, forKey: "confusion_index")
        characterRecord.setValue(language, forKey: "language")
        saveContext()
    }
    
    func getCharacterRecordMappings(characters : [String], language: String) -> [String : CharacterRecord]
    {
        let characterRecords = fetchCharacterRecords(characters: characters, language: language)
        var mapping : [String : CharacterRecord] = [:]
        
        for record in characterRecords
        {
            mapping[record.character!] = record
        }
        
        return mapping
    }
    
    func checkCharacterExists(character : String, language: String) -> Bool
    {
        let fetchRequest = NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
        let characterPredicate = NSPredicate(format: "character == %@", character)
        let languagePredicate = getLanguageEqualityPredicate(language: language)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [characterPredicate, languagePredicate])
        fetchRequest.predicate = predicate
        let result = performFetchRequest(fetchRequest: fetchRequest)
        return result.count > 0
    }
    
    func fetchCharacterRecords(characters : [String], language: String) -> [CharacterRecord]
    {
        /*
            Returns a list of specified characters.
            Creates new records if the character doesn't already exist.
            Otherwise retrieves together.
         */
        for character in characters
        {
            if !checkCharacterExists(character: character, language: language)
            {
                createNewCharacterRecord(character: character, language: language)
            }
        }
        
        let predicate = getCompoundPredicatesForCharacters(characters: characters, language: language)
        let fetchRequest = NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
        fetchRequest.predicate = predicate
        
        return performFetchRequest(fetchRequest: fetchRequest)
    }
    
    func performFetchRequest(fetchRequest: NSFetchRequest<CharacterRecord>) -> [CharacterRecord]
    {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Couldn't retrieve the characters with error \(error.userInfo)")
        }
        return []
    }
    
    func getCharacterEqualityPredicate(character : String) -> NSPredicate
    {
        return NSPredicate(format: "character == %@", character)
    }
    
    func getLanguageEqualityPredicate(language : String) -> NSPredicate
    {
        return NSPredicate(format: "language == %@", language)
    }
    
    func getCompoundPredicatesForCharacters(characters : [String], language: String) -> NSCompoundPredicate
    {
        var predicates : [NSPredicate] = []
        
        for character in characters
        {
            let predicate = getCharacterEqualityPredicate(character: character)
            predicates.append(predicate)
        }
        
        let characterEqualityPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let languageEqualityPredicate = getLanguageEqualityPredicate(language: language)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [characterEqualityPredicates, languageEqualityPredicate])
        
    }
    
    func saveContext()
    {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Couldn't add a new character with error \(error.userInfo) :c")
        }
    }
}

public class RevisedCoreDataManager
{
    public static let modelName = "hiraganacoach"
    
    public static let model : NSManagedObjectModel =
    {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var container : NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: RevisedCoreDataManager.modelName, managedObjectModel: RevisedCoreDataManager.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("App crashed with error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public lazy var mainContext: NSManagedObjectContext =
    {
        return self.container.viewContext
    }()
    
    public func getNewBackgroundContext() -> NSManagedObjectContext
    {
        let backgroundContext = container.newBackgroundContext()
        return backgroundContext
    }
    
    public func saveContext(_ context: NSManagedObjectContext)
    {
        if context != mainContext
        {
            saveBackgroundContext(context: context)
        } else {
            saveMainContext()
        }
    }
    
    public func saveBackgroundContext(context : NSManagedObjectContext)
    {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unable to save context: \(error.debugDescription)")
            }
        }
        
        self.saveMainContext()
    }
    
    public func saveMainContext()
    {
        mainContext.perform
        {
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                fatalError("Unable to save context: \(error.debugDescription)")
            }
        }
    }
}

