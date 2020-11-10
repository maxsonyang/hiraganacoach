//
//  JSONManagerTests.swift
//  hiraganacoachTests
//
//  Created by Maxson Yang on 11/9/20.
//

import XCTest
@testable import hiraganacoach

class JSONManagerTests: XCTestCase {

    let jsonManager = JSONManager()
    
    func testRetrieveCharacter()
    {
        let results = jsonManager.getCharacters(fileName: "test_characters")
        XCTAssertNotNil(results)
        
        XCTAssertEqual(results, [
            "a" : "a",
            "b" : "b"
        ])
    }
    
    func testRetrieveContexts()
    {
        let results = jsonManager.getAssessmentContexts(fileName: "test_assessment_contexts")
        XCTAssertNotNil(results)
        
        let contextArray = results!
        XCTAssertEqual(contextArray.count, 2)
        
        let dojo = contextArray[0]
        XCTAssertEqual(dojo.label, "Dojo")
        XCTAssertEqual(dojo.category_label, "a")
        XCTAssertEqual(dojo.categories.count, 0)
        XCTAssertEqual(dojo.id, "dojo")
        XCTAssertEqual(dojo.assessmentType, "dojo")
        
        let vowels = contextArray[1]
        XCTAssertEqual(vowels.label, "Vowels")
        XCTAssertEqual(vowels.category_label, "a")
        XCTAssertEqual(vowels.categories.count, 1)
        XCTAssertEqual(vowels.id, "vowels")
        XCTAssertEqual(vowels.assessmentType, "practice")
    }
    
}

extension JSONManagerTests
{
    // MARK: Performance Testing
    func testGetContextsPerformance() {
        measure {
            _ = JSONManager().getAssessmentContexts(fileName: "hiragana_contexts")
        }
    }
    
    func testGetCharactersPerformance() {
        measure {
            _ = JSONManager().getCharacters(fileName: "hiragana_characters")
        }
    }
}
