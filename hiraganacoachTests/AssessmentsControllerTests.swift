//
//  AssessmentsControllerTests.swift
//  hiraganacoachTests
//
//  Created by Maxson Yang on 11/12/20.
//

import XCTest
import CoreData
@testable import hiraganacoach

class AssessmentsControllerTests: XCTestCase
{

    let testLanguageContext : LanguageContext = LanguageContext(id: "test", label: "Test", family: "English")
    var testAssessmentsController : AssessmentsController!
    
    override func setUp() {
        super.setUp()
        BaseController.coreDataInterface = {
            let cdm = RevisedCoreDataManager()
            let vc = cdm.mainContext
            return CoreDataInterface(cdm: cdm, vc: vc, testing: true)
        }()
        testAssessmentsController = AssessmentsController(languageContext: testLanguageContext)
    }
    
    override func tearDown() {
        super.tearDown()
        testAssessmentsController = nil
    }

}

extension AssessmentsControllerTests
{
    func testInitialize()
    {
        
        
        let languageID = testAssessmentsController?.getLanguageID()
        let languageFamily = testAssessmentsController?.getLanguageFamily()
        let navLabel = testAssessmentsController?.getNavLabel()
        
        XCTAssertEqual(languageID, "test")
        XCTAssertEqual(languageFamily, "English")
        XCTAssertEqual(navLabel, "Test")
    }
    
    func testLanguageMetadataGetters()
    {
	
        let masteredTopics = testAssessmentsController?.getMasteredTopics()
        let highestStreak = testAssessmentsController?.getHighestStreak()
        let totalScore = testAssessmentsController?.getTotalScore()
        
        XCTAssertEqual(masteredTopics, 0)
        XCTAssertEqual(highestStreak, 0)
        XCTAssertEqual(totalScore, 0)
    }
    
    func testMasteryMappingMastered()
    {
        let assessmentMetadata = BaseController.coreDataInterface.createAssessmentMetadata(id: "test", language: "test", assessmentType: "practice")
        BaseController.coreDataInterface.update(metadata: assessmentMetadata)
        var mastery_mapping = testAssessmentsController?.getMasteryMapping()
        
        XCTAssertFalse((mastery_mapping?.isEmpty)!)
        XCTAssertNotNil(mastery_mapping?["test"])
        XCTAssertFalse((mastery_mapping?["test"])!)
        
        assessmentMetadata.mastered = true
        BaseController.coreDataInterface.update(metadata: assessmentMetadata)
        
        mastery_mapping = testAssessmentsController?.getMasteryMapping()
        XCTAssertFalse((mastery_mapping?.isEmpty)!)
        XCTAssertNotNil(mastery_mapping?["test"])
        XCTAssertTrue((mastery_mapping?["test"])!)
        
    }

    func testDisplayedContext()
    {
        var displayedTopics = testAssessmentsController?.getDisplayedTopics()
        XCTAssertEqual(displayedTopics?.count, 1)
        
        let assessmentMetadata = BaseController.coreDataInterface.getAssessmentMetadata(id: "test", language: "test", assessmentType: "practice")
        assessmentMetadata?.mastered = true
        BaseController.coreDataInterface.update(metadata: assessmentMetadata!)
        
        displayedTopics = testAssessmentsController?.getDisplayedTopics()
        XCTAssertEqual(displayedTopics?.count, 2)
    }
}
