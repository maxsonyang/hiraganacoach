//
//  ApplicationDataManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/8/20.
//

import Foundation
import CoreData

public final class ApplicationDataInterface
{
    
    let coreDataManager : RevisedCoreDataManager
    let viewContext : NSManagedObjectContext
    
    init(cdm : RevisedCoreDataManager, vc : NSManagedObjectContext)
    {
        coreDataManager = cdm
        viewContext = vc
    }
    
}

extension ApplicationDataInterface
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

extension ApplicationDataInterface
{
    /*
        MARK: Assessment Metadata Methods
     */
    
    @discardableResult
    public func createAssessmentMetadata(id: String,
                language: String, assessmentType: String) -> AssessmentMetadata
    {
        
        
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
        fetchRequest : NSFetchRequest<AssessmentMetadata>) -> [AssessmentMetadata]
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
        let fetchRequest = getAssessmentMetadataRequest()
        let predicate = assessmentMetadataMatchPredicate(id: id,
                                    language: language, assessmentType: assessmentType)
        fetchRequest.predicate = predicate
        
        let results = executeAssessmentMetadataFetchRequest(fetchRequest: fetchRequest)
        return results.count > 0
    }
    
    public func getAssessmentMetadata(id: String,
                language: String, assessmentType: String) -> AssessmentMetadata
    {
        let fetchRequest = getAssessmentMetadataRequest()
        let predicate = assessmentMetadataMatchPredicate(id: id,
                        language: language, assessmentType: assessmentType)
        fetchRequest.predicate = predicate
        
        let results = executeAssessmentMetadataFetchRequest(fetchRequest: fetchRequest)
        
        // Checking for invalid results
        precondition(results.count > 0, "No \(assessmentType) assessment for \(id), \(language)")
        precondition(results.count == 1, "Duplicate \(assessmentType) assessment found for \(id), \(language)")
        
        return results[0]
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
}

extension ApplicationDataInterface
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
