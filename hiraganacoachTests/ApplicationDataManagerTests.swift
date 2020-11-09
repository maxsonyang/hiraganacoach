//
//  ApplicationDataManagerTests.swift
//  hiraganacoachTests
//
//  Created by Maxson Yang on 11/8/20.
//

import XCTest
@testable import hiraganacoach
import CoreData

class CharacterRecordTests: XCTestCase {

    var coreDataManager : TestCoreDataManager!
    var applicationDataManager : ApplicationDataManager!
    
    override func setUp()
    {
        super.setUp()
        coreDataManager = TestCoreDataManager()
        applicationDataManager = ApplicationDataManager(cdm: coreDataManager, vc: coreDataManager.mainContext)
    }
    
    override func tearDown()
    {
        super.tearDown()
        coreDataManager = nil
        applicationDataManager = nil
    }
    
    func testCreateNewCharacterRecord()
    {
        let record = applicationDataManager.createCharacterRecord(character: "a", language: "English")
        
        XCTAssertEqual(record.character, "a")
        XCTAssertEqual(record.language, "English")
        XCTAssertTrue(record.attempts == 0)
        XCTAssertTrue(record.correct == 0)
        
        // Make sure initialized confusion_index does not contain any values
        let confusion_index = record.confusion_index as! [String : [String : Int]]
        XCTAssertTrue(confusion_index.count == 0)
    }
    
    func testGetCharacterRecord()
    {
        let created_record = applicationDataManager.createCharacterRecord(character: "a", language: "English")
        
        let record = applicationDataManager.getCharacterRecord(character: "a", language: "English")
        
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
        let created_record = applicationDataManager.createCharacterRecord(character: "a", language: "English")
        let attempt_2 = applicationDataManager.createCharacterRecord(character: "a", language: "English")
        XCTAssertTrue(created_record === attempt_2)
    }
    
    func testUpdateCharacterRecordCorrect()
    {
        applicationDataManager.createCharacterRecord(character: "a", language: "English")
        
        var record = applicationDataManager.getCharacterRecord(character: "a", language: "English")
        
        record.attempts += 1
        record.correct += 1
        
        applicationDataManager.update(record)
        
        record = applicationDataManager.getCharacterRecord(character: "a", language: "English")
        
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
        applicationDataManager.createCharacterRecord(character: "a", language: "English")
        
        var record = applicationDataManager.getCharacterRecord(character: "a", language: "English")

        record.attempts += 1

        var confusion_index = record.confusion_index as! [String : Int]
        confusion_index["b"] = 1
        record.confusion_index = confusion_index as NSObject

        applicationDataManager.update(record)

        record = applicationDataManager.getCharacterRecord(character: "a", language: "English")

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
        let record = applicationDataManager.createCharacterRecord(character: "a", language: "English")
        XCTAssertTrue(applicationDataManager.recordExists(character: "a", language: "English"))
        applicationDataManager.delete(record)
        XCTAssertFalse(applicationDataManager.recordExists(character: "a", language: "English"))
    }
}
