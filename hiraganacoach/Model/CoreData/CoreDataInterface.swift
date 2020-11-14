//
//  ApplicationDataManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/8/20.
//

import Foundation
import CoreData

public class CoreDataInterface
{
    
    public var coreDataManager : RevisedCoreDataManager
    let viewContext : NSManagedObjectContext
    
    init(cdm : RevisedCoreDataManager, vc : NSManagedObjectContext, testing : Bool=false)
    {
        if !testing {
            coreDataManager = cdm
        } else {
            coreDataManager = TestCoreDataManager()
        }
        viewContext = vc
    }
    
}

extension CoreDataInterface
{
    /*
        MARK: Character Record Methods
     */
    
    // MARK: Character Record Creation Methods
    
    @discardableResult
    public func createCharacterRecord(character : String,
                               language : String) -> CharacterRecord
    {
        if recordExists(character: character, language: language)
        {
            return getCharacterRecord(character: character, language: language)!
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
        let result = getCharacterRecord(character: character, language: language)
        return result != nil
    }
    
    // MARK: Getters
    public func getCharacterRecord(character : String,
                            language : String) -> CharacterRecord?
    {
        let fetchRequest = getCharacterRecordRequest()
        fetchRequest.predicate = languageAndCharacterPredicate(character, language)

        let results = executeCharacterFetchRequest(fetchRequest)
        
        return results.count > 0 ? results[0] : nil
    }
    
    public func getCharacterRecordsOfLanguage(_ language : String) -> [CharacterRecord]
    {
        let fetchRequest = getCharacterRecordRequest()
        fetchRequest.predicate = getLanguagePredicate(language)
        return executeCharacterFetchRequest(fetchRequest)
    }
    
    public func executeCharacterFetchRequest(
        _ fetchRequest : NSFetchRequest<CharacterRecord>) -> [CharacterRecord]
    {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("Could not get character record: \(error.debugDescription)")
        }
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
    
    public func deleteAllCharacterRecords()
    {
        let fetchRequest = getCharacterRecordRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            for result in results
            {
                viewContext.delete(result)
            }
            coreDataManager.saveContext(viewContext)
        } catch let error as NSError {
            fatalError("Could not fetch character records \(error)")
        }
    }
}

extension CoreDataInterface
{
    /*
        MARK: Assessment Metadata Methods
     */
    
    @discardableResult
    public func createAssessmentMetadata(id: String,
                language: String, assessmentType: String) -> AssessmentMetadata
    {
        
        if assessmentMetadataExists(id: id, language: language, assessmentType: assessmentType)
        {
            return getAssessmentMetadata(id: id, language: language, assessmentType: assessmentType)!
        }
        let assessmentMetadata = AssessmentMetadata(context: viewContext)
        
        assessmentMetadata.id = id
        assessmentMetadata.language = language
        assessmentMetadata.assessmentType = assessmentType
        assessmentMetadata.mastered = false
        assessmentMetadata.highestStreak = 0
        
        coreDataManager.saveContext(viewContext)
        
        return assessmentMetadata
    }
    
    public func executeAssessmentMetadataFetchRequest(
        _ fetchRequest : NSFetchRequest<AssessmentMetadata>) -> [AssessmentMetadata]
    {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("Could not get character record: \(error.debugDescription)")
        }
    }
    
    public func assessmentMetadataExists(id: String,
                language: String, assessmentType: String) -> Bool
    {
        let result = getAssessmentMetadata(id: id, language: language, assessmentType: assessmentType)
        return result != nil
    }
    
    public func getAssessmentMetadata(id: String,
                language: String, assessmentType: String) -> AssessmentMetadata?
    {
        let fetchRequest = getAssessmentMetadataRequest()
        let predicate = assessmentMetadataMatchPredicate(id: id,
                        language: language, assessmentType: assessmentType)
        fetchRequest.predicate = predicate
        
        let results = executeAssessmentMetadataFetchRequest(fetchRequest)
        
        return results.count > 0 ? results[0] : nil
    }
    
    public func getAllAssessmentMetadata(language: String) -> [AssessmentMetadata]?
    {
        let fetchRequest = getAssessmentMetadataRequest()
        let predicate = getLanguagePredicate(language)
        fetchRequest.predicate = predicate
        
        let results = executeAssessmentMetadataFetchRequest(fetchRequest)
        
        return results
    }
    
    @discardableResult
    public func update(metadata : AssessmentMetadata) -> AssessmentMetadata
    {
        coreDataManager.saveContext(viewContext)
        return metadata
    }
    
    public func delete(metadata : AssessmentMetadata)
    {
        viewContext.delete(metadata)
        coreDataManager.saveContext(viewContext)
    }
    
    public func deleteAllAssessmentMetadata()
    {
        let fetchRequest = getAssessmentMetadataRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            for result in results
            {
                viewContext.delete(result)
            }
            coreDataManager.saveContext(viewContext)
        } catch let error as NSError {
            fatalError("Could not fetch character records \(error)")
        }
    }
}

extension CoreDataInterface
{
    
    /*
        MARK: Language Metadata Methods
     */
    
    @discardableResult
    public func createLanguageMetadata(language: String) -> LanguageMetadata
    {
        if languageMetadataExists(language: language)
        {
            return getLanguageMetadata(language: language)!
        }
        
        let languageMetadata = LanguageMetadata(context: viewContext)
        languageMetadata.language = language
        languageMetadata.highestStreak = 0
        languageMetadata.masteredTopics = 0
        languageMetadata.totalScore = 0
        
        coreDataManager.saveContext(viewContext)
        return languageMetadata
    }
    
    public func languageMetadataExists(language: String) -> Bool
    {
        let result = getLanguageMetadata(language: language)
        return result != nil
    }
    
    public func getLanguageMetadata(language: String) -> LanguageMetadata?
    {
        let fetchRequest = getLanguageMetadataRequest()
        let predicate = getLanguagePredicate(language)
        fetchRequest.predicate = predicate
        
        let results = executeLanguageMetadataFetchRequest(fetchRequest)
        return results.count > 0 ? results[0] : nil
    }
    
    public func executeLanguageMetadataFetchRequest(
        _ fetchRequest: NSFetchRequest<LanguageMetadata>) -> [LanguageMetadata]
    {
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("Could not retrieve Language Metadata with error: \(error.debugDescription)")
        }
    }
    
    // Update
    @discardableResult
    public func update(languageMetadata: LanguageMetadata) -> LanguageMetadata
    {
        coreDataManager.saveContext(viewContext)
        return languageMetadata
    }
    
    // Delete
    public func delete(languageMetadata: LanguageMetadata)
    {
        viewContext.delete(languageMetadata)
        coreDataManager.saveContext(viewContext)
    }
    
    public func deleteAllLanguageMetadata()
    {
        let fetchRequest = getLanguageMetadataRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            for result in results
            {
                viewContext.delete(result)
            }
            coreDataManager.saveContext(viewContext)
        } catch let error as NSError {
            fatalError("Could not fetch character records \(error)")
        }
    }
}

extension CoreDataInterface
{
    /*
        MARK: Fetch Requests and Predicates
     */
    
    // MARK: Fetch Requests
    private func getCharacterRecordRequest() -> NSFetchRequest<CharacterRecord>
    {
        return NSFetchRequest<CharacterRecord>(entityName: "CharacterRecord")
    }
    
    private func getAssessmentMetadataRequest() -> NSFetchRequest<AssessmentMetadata>
    {
        return NSFetchRequest<AssessmentMetadata>(entityName: "AssessmentMetadata")
    }
    
    private func getLanguageMetadataRequest() -> NSFetchRequest<LanguageMetadata>
    {
        return NSFetchRequest<LanguageMetadata>(entityName: "LanguageMetadata")
    }
    
    // MARK: Unary Predicates
    private func getCharacterPredicate(_ character : String) -> NSPredicate
    {
        return NSPredicate(format: "character == %@", character)
    }
    
    private func getLanguagePredicate(_ language : String) -> NSPredicate
    {
        return NSPredicate(format: "language == %@", language)
    }
    
    private func getIDPredicate(_ id: String) -> NSPredicate
    {
        return NSPredicate(format: "id == %@", id)
    }
    
    private func getAssessmentTypePredicate(_ assessmentType: String) -> NSPredicate
    {
        return NSPredicate(format: "assessmentType == %@", assessmentType)
    }
    
    // MARK: Compound Predicates
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
    
    private func assessmentMetadataMatchPredicate(id: String,
                        language: String, assessmentType: String) -> NSPredicate
    {
        let idPredicate = getIDPredicate(id)
        let languagePredicate = getLanguagePredicate(language)
        let assessmentTypePredicate = getAssessmentTypePredicate(assessmentType)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            idPredicate,
            languagePredicate,
            assessmentTypePredicate,
        ])
    }
}

extension CoreDataInterface
{
    // MARK: Other Methods
    
        public func hardReset()
        {
            deleteAllLanguageMetadata()
            deleteAllAssessmentMetadata()
            deleteAllCharacterRecords()
        }
}
