//
//  ApplicationDataManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/8/20.
//

import Foundation
import CoreData

public final class ApplicationDataManager
{
    
    let coreDataManager : RevisedCoreDataManager
    let viewContext : NSManagedObjectContext
    
    init(cdm : RevisedCoreDataManager, vc : NSManagedObjectContext)
    {
        coreDataManager = cdm
        viewContext = vc
    }
    
}

extension ApplicationDataManager
{
    /*
        Methods for dealing with Character Records
     */
    
    // MARK: Character Record Creation Methods
    
    @discardableResult
    public func createCharacterRecord(character : String,
                               language : String) -> CharacterRecord
    {
        if recordExists(character: character, language: language)
        {
            return getCharacterRecord(character: character, language: language)
        }
        
        let characterRecord = CharacterRecord(context: viewContext)
        characterRecord.attempts = 0
        characterRecord.character = character
        characterRecord.confusion_index = [:] as NSObject
        characterRecord.correct = 0
        characterRecord.language = language
        
        coreDataManager.saveContext(viewContext)
        
        return characterRecord
    }
    
    public func recordExists(character : String, language : String) -> Bool
    {
        let fetchRequest = getCharacterRecordRequest()
        fetchRequest.predicate = languageAndCharacterPredicate(character, language)
        let results = executeCharacterFetchRequest(fetchRequest: fetchRequest)
        
        return results.count > 0
    }
    
    /*
        MARK: Character Record Getters + Predicates
     */
    
    public func executeCharacterFetchRequest(
        fetchRequest : NSFetchRequest<CharacterRecord>) -> [CharacterRecord]
    {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("Could not get character record: \(error.debugDescription)")
        }
    }
    
    // MARK: Getters
    public func getCharacterRecord(character : String,
                            language : String) -> CharacterRecord
    {
        let fetchRequest = getCharacterRecordRequest()
        fetchRequest.predicate = languageAndCharacterPredicate(character, language)

        let results = executeCharacterFetchRequest(fetchRequest: fetchRequest)
        
        // Checking for invalid results
        precondition(results.count > 0, "No character found matching \(character) in \(language)")
        precondition(results.count == 1, "Duplicate entries found for character: \(character) of \(language)")
        
        return results[0]
    }
    
    public func getCharacterRecordsOfLanguage(_ language : String) -> [CharacterRecord]
    {
        let fetchRequest = getCharacterRecordRequest()
        fetchRequest.predicate = getLanguagePredicate(language)
        return executeCharacterFetchRequest(fetchRequest: fetchRequest)
    }
    
    // MARK: Update
    @discardableResult
    public func update(_ record : CharacterRecord) -> CharacterRecord
    {
        coreDataManager.saveContext(viewContext)
        return record
    }
    
    public func delete(_ record : CharacterRecord)
    {
        viewContext.delete(record)
        coreDataManager.saveContext(viewContext)
    }
}

extension ApplicationDataManager
{
    /*
        MARK: Fetch Requests and Predicates
     */
    
    // MARK: Fetch Requests
    private func getCharacterRecordRequest() -> NSFetchRequest<CharacterRecord>
    {
        return NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
    }
    
    // MARK: Predicates
    private func getCharacterPredicate(_ character : String) -> NSPredicate
    {
        return NSPredicate(format: "character == %@", character)
    }
    
    private func getLanguagePredicate(_ language : String) -> NSPredicate
    {
        return NSPredicate(format: "language == %@", language)
    }
    
    private func languageAndCharacterPredicate(
        _ character : String, _ language : String) -> NSCompoundPredicate
    {
        let characterPredicate = getCharacterPredicate(character)
        let languagePredicate = getLanguagePredicate(language)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            characterPredicate,
            languagePredicate
        ])
    }
}
