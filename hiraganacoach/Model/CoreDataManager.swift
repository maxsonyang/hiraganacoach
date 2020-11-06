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
    
    func fetchAssessmentMetadata(id : String, assessmentType : String) -> [AssessmentMetadata]
    {
        let fetchRequest = NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
        let id_predicate = NSPredicate(format: "id == %@", id)
        let assessmentType_predicate = NSPredicate(format: "assessmentType == %@", assessmentType)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [id_predicate, assessmentType_predicate])
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print(error)
        }
        
        return []
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
        var result = fetchAssessmentMetadata(id : id, assessmentType: assessmentType)
        if result.isEmpty
        {
            createNewAssessmentMetadata(id: id, assessmentType: assessmentType, language: language)
            result = fetchAssessmentMetadata(id: id, assessmentType: assessmentType)
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
    
    func checkCharacterExists(character : String) -> Bool
    {
        let fetchRequest = NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
        let predicate = NSPredicate(format: "character == %@", character)
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
            if !checkCharacterExists(character: character)
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

