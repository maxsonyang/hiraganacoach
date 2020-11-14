//
//  ApplicationDataManagerTests.swift
//  hiraganacoachTests
//
//  Created by Maxson Yang on 11/8/20.
//

import XCTest
@testable import hiraganacoach
import CoreData

class ApplicationDataInterfaceTests : XCTestCase
{
    var coreDataManager : TestCoreDataManager!
    var applicationDataInterface : CoreDataInterface!
    
    override func setUp()
    {
        super.setUp()
        coreDataManager = TestCoreDataManager()
        applicationDataInterface = CoreDataInterface(cdm: coreDataManager, vc: coreDataManager.mainContext)
    }
    
    override func tearDown()
    {
        super.tearDown()
        coreDataManager = nil
        applicationDataInterface = nil
    }
}

// MARK: Character Record Tests
class CharacterRecordTests: ApplicationDataInterfaceTests
{
    
    func testCreateNewCharacterRecord()
    {
        let record = applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        
        XCTAssertEqual(record.character, "a")
        XCTAssertEqual(record.language, "English")
        XCTAssertTrue(record.attempts == 0)
        XCTAssertTrue(record.correct == 0)
        
        // Make sure initialized confusion_index does not contain any values
        let confusion_index = record.confusion_index as! [String : [String : Int]]
        XCTAssertTrue(confusion_index.count == 0)
    }
    
    func testCharacterRecordExists()
    {
        // Check for non-existent record
        var exists = applicationDataInterface.recordExists(character: "a", language: "English")
        XCTAssertFalse(exists)
        
        // Check for existing
        applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        exists = applicationDataInterface.recordExists(character: "a", language: "English")
        XCTAssertTrue(exists)
        
        // Check for exact matching record (no false-positives)
        exists = applicationDataInterface.recordExists(character: "non", language: "existent")
        XCTAssertFalse(exists)
    }
    
    func testGetCharacterRecord()
    {
        let created_record = applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        
        let record = applicationDataInterface.getCharacterRecord(character: "a", language: "English")!
        
        XCTAssertTrue(created_record === record)
        XCTAssertEqual(record.character, "a")
        XCTAssertEqual(record.language, "English")
        XCTAssertTrue(record.attempts == 0)
        XCTAssertTrue(record.correct == 0)
        
        // Make sure initialized confusion_index does not contain any values
        let confusion_index = record.confusion_index as! [String : [String : Int]]
        XCTAssertTrue(confusion_index.count == 0)
    }
    
    func testNoDuplicateRecord()
    {
        // Attempts at creating an existing record should return the existing record
        let created_record = applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        let attempt_2 = applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        XCTAssertTrue(created_record === attempt_2)
    }
    
    func testUpdateCharacterRecordCorrect()
    {
        applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        
        var record = applicationDataInterface.getCharacterRecord(character: "a", language: "English")!
        
        record.attempts += 1
        record.correct += 1
        
        applicationDataInterface.update(record)
        
        record = applicationDataInterface.getCharacterRecord(character: "a", language: "English")!
        
        XCTAssertEqual(record.character, "a")
        XCTAssertEqual(record.language, "English")
        XCTAssertTrue(record.attempts == 1)
        XCTAssertTrue(record.correct == 1)
        
        // Make sure initialized confusion_index does not contain any values
        let confusion_index = record.confusion_index as! [String : Int]
        XCTAssertTrue(confusion_index.count == 0)
    }
    
    func testUpdateCharacterRecordIncorrect()
    {
        applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        
        var record = applicationDataInterface.getCharacterRecord(character: "a", language: "English")!

        record.attempts += 1

        var confusion_index = record.confusion_index as! [String : Int]
        confusion_index["b"] = 1
        record.confusion_index = confusion_index as NSObject

        applicationDataInterface.update(record)

        record = applicationDataInterface.getCharacterRecord(character: "a", language: "English")!

        XCTAssertEqual(record.character, "a")
        XCTAssertEqual(record.language, "English")
        XCTAssertTrue(record.attempts == 1)
        XCTAssertTrue(record.correct == 0)

        // Make sure initialized confusion_index does not contain any values
        confusion_index = record.confusion_index as! [String : Int]
        XCTAssertTrue(confusion_index.count == 1)
        XCTAssertNotNil(confusion_index["b"])
        XCTAssertEqual(confusion_index["b"], 1)

    }
    
    func testDeleteCharacterRecord()
    {
        let record = applicationDataInterface.createCharacterRecord(character: "a", language: "English")
        XCTAssertTrue(applicationDataInterface.recordExists(character: "a", language: "English"))
        applicationDataInterface.delete(record)
        XCTAssertFalse(applicationDataInterface.recordExists(character: "a", language: "English"))
    }
}

// MARK: Assessment Metadata Tests
class AssessmentMetadataTests : ApplicationDataInterfaceTests
{
    func testCreateNewAssessmentMetadata()
    {
        let metadata = applicationDataInterface.createAssessmentMetadata(id: "test", language: "English", assessmentType: "testing")
        
        XCTAssertEqual(metadata.id, "test")
        XCTAssertEqual(metadata.language, "English")
        XCTAssertEqual(metadata.assessmentType, "testing")
        XCTAssertEqual(metadata.highestStreak, 0)
        XCTAssertFalse(metadata.mastered)
    }
    
    func testAssessmentMetadataExists()
    {
        // Checks for non-existent record.
        var dne = applicationDataInterface.assessmentMetadataExists(id: "test", language: "English", assessmentType: "test")
        XCTAssertFalse(dne)
        
        // Checks for existing record.
        applicationDataInterface.createAssessmentMetadata(id: "test", language: "English", assessmentType: "test")
        let exists = applicationDataInterface.assessmentMetadataExists(id: "test", language: "English", assessmentType: "test")
        XCTAssertTrue(exists)
        
        // Checks to ensure exact match with predicate
        dne = applicationDataInterface.assessmentMetadataExists(id: "non", language: "existent", assessmentType: "Metadata")
        XCTAssertFalse(dne)
    }
    
    func testGetAssessmentMetadata()
    {
        applicationDataInterface.createAssessmentMetadata(id: "test", language: "English", assessmentType: "test")
        let metadata = applicationDataInterface.getAssessmentMetadata(id: "test", language: "English", assessmentType: "test")!
        
        XCTAssertEqual(metadata.id, "test")
        XCTAssertEqual(metadata.language, "English")
        XCTAssertEqual(metadata.assessmentType, "test")
        XCTAssertEqual(metadata.highestStreak, 0)
        XCTAssertFalse(metadata.mastered)
    }
    
    func testUpdateAssessmentMetadata()
    {
        var metadata = applicationDataInterface.createAssessmentMetadata(id: "test", language: "English", assessmentType: "test")
        metadata.mastered = true
        metadata.highestStreak = 9001
        
        applicationDataInterface.update(metadata: metadata)
        
        metadata = applicationDataInterface.getAssessmentMetadata(id: "test", language: "English", assessmentType: "test")!
        XCTAssertEqual(metadata.id, "test")
        XCTAssertEqual(metadata.language, "English")
        XCTAssertEqual(metadata.assessmentType, "test")
        XCTAssertEqual(metadata.highestStreak, 9001)
        XCTAssertTrue(metadata.mastered)
    }
    
    func testDeleteMetadata()
    {
        var exists = applicationDataInterface.assessmentMetadataExists(id: "test", language: "English", assessmentType: "test")
        XCTAssertFalse(exists)
        
        let metadata = applicationDataInterface.createAssessmentMetadata(id: "test", language: "English", assessmentType: "test")
        exists = applicationDataInterface.assessmentMetadataExists(id: "test", language: "English", assessmentType: "test")
        XCTAssertTrue(exists)
        
        applicationDataInterface.delete(metadata: metadata)
        exists = applicationDataInterface.assessmentMetadataExists(id: "test", language: "English", assessmentType: "test")
        XCTAssertFalse(exists)
    }
}

extension ApplicationDataInterfaceTests
{
    
    func testCreateLanguageMetadata()
    {
        let languageMetadata : LanguageMetadata = applicationDataInterface.createLanguageMetadata(language: "English")
        
        XCTAssertEqual(languageMetadata.highestStreak, 0)
        XCTAssertEqual(languageMetadata.language, "English")
        XCTAssertEqual(languageMetadata.masteredTopics, 0)
        XCTAssertEqual(languageMetadata.totalScore, 0)
    }
    
    func testCheckLanguageMetadataExists()
    {
        var exists = applicationDataInterface.languageMetadataExists(language: "Japanese")
        XCTAssertFalse(exists)
        
        applicationDataInterface.createLanguageMetadata(language: "Japanese")
        exists = applicationDataInterface.languageMetadataExists(language: "Japanese")
        
        XCTAssertTrue(exists)
    }
    
    func testNoDuplicateMetadata()
    {
        let languageMetadata : LanguageMetadata = applicationDataInterface.createLanguageMetadata(language: "English")
        let duplicate : LanguageMetadata = applicationDataInterface.createLanguageMetadata(language: "English")
        
        XCTAssertTrue(languageMetadata === duplicate)
    }
    
    func testGetLanguageMetadata()
    {
        var languageMetadata : LanguageMetadata = applicationDataInterface.createLanguageMetadata(language: "English")
        languageMetadata = applicationDataInterface.getLanguageMetadata(language: "English")!
        
        XCTAssertEqual(languageMetadata.highestStreak, 0)
        XCTAssertEqual(languageMetadata.language, "English")
        XCTAssertEqual(languageMetadata.masteredTopics, 0)
        XCTAssertEqual(languageMetadata.totalScore, 0)
    }
    
    func testUpdateLanguageMetadata()
    {
        var languageMetadata : LanguageMetadata = applicationDataInterface.createLanguageMetadata(language: "English")
        
        languageMetadata.highestStreak = 1
        languageMetadata.language = "Boontling"
        languageMetadata.masteredTopics = -1
        languageMetadata.totalScore = 42
        
        applicationDataInterface.update(languageMetadata: languageMetadata)
        
        languageMetadata = applicationDataInterface.getLanguageMetadata(language: "Boontling")!
        
        XCTAssertEqual(languageMetadata.highestStreak, 1)
        XCTAssertEqual(languageMetadata.language, "Boontling")
        XCTAssertEqual(languageMetadata.masteredTopics, -1)
        XCTAssertEqual(languageMetadata.totalScore, 42)
    }
    
    func testDeleteLanguageMetadata()
    {
        var exists = applicationDataInterface.languageMetadataExists(language: "Japanese")
        XCTAssertFalse(exists)
        
        let metadata = applicationDataInterface.createLanguageMetadata(language: "Japanese")
        exists = applicationDataInterface.languageMetadataExists(language: "Japanese")
        
        XCTAssertTrue(exists)
        
        applicationDataInterface.delete(languageMetadata: metadata)
        exists = applicationDataInterface.languageMetadataExists(language: "Japanese")
        XCTAssertFalse(exists)
    }
}
