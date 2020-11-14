//
//  Context.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/29/20.
//

import Foundation

public struct AssessmentContext : Identifiable, Codable
{
    /*
        Class used to define how a view should be generated to adhere
        to the flyweight design pattern.
     */
    public let label : String
    public let category_label : String
    public let id : String
    public let assessmentType : String
    public let categories : [String]
    
    init(label: String, category_label : String,
         id : String, assessmentType : String, categories : [String])
    {
        self.label = label
        self.category_label = category_label
        self.id = id
        self.categories = categories
        self.assessmentType = assessmentType
    }
    
}

public class LanguageContext : Identifiable, Codable
{
    public let id : String
    public let label : String
    public let family : String
    
    init(id : String, label : String, family : String)
    {
        self.id = id
        self.label = label
        self.family = family
    }
}

// Rework -----

//public class UnifiedContext
//{
//    /*
//        Establishes a single context that provides all the resources
//        needed for any given view of the app.
//     */
//
//    // MARK: Attributes
//
//    // Internal Services
//    public let coreDataInterface : CoreDataInterface = {
//        let coreData = RevisedCoreDataManager()
//        let viewContext = coreData.mainContext
//        return CoreDataInterface(cdm: coreData, vc: viewContext)
//    }()
//    public let jsonManager : JSONManager = JSONManager()
//    lazy public var performance : Performance = Performance()
//    lazy public var assessment : Assessment? = Assessment()
//
//    // CoreData attributes
//    public var languageMetadata : LanguageMetadata?
//
//    // Language-level settings
//    public var language : String?
//    public var characterSet : [String : String]?
//    public var categorySets : [String : [String]]?
//    public var assessmentContexts : [AssessmentContext]?
//    public var masteryMapping : [String : Bool]?
//
//    // Assessment-level settings
//    public var categories : [String]?
//    public var characters : [String]?
//    public var assessmentType : String?
//    public var assessmentID : String?
//    public var assessmentMetadata : AssessmentMetadata?
//
//}
//
//extension UnifiedContext
//{
//    // MARK: Context Update Methods
//    @discardableResult
//    public func updateLanguageContext(language : String) -> UnifiedContext
//    {
//        self.language = language
//        self.characterSet = getCharacterSet()
//        self.categorySets = getCategorySet()
//        self.languageMetadata = getLanguageMetadata()
//        self.assessmentContexts = getAssessmentContexts()
//        self.masteryMapping = getMasteryMapping()
//        return self
//    }
//
//    @discardableResult
//    public func updateAssessmentContext(assessmentContext : AssessmentContext) -> UnifiedContext
//    {
//        self.categories = assessmentContext.categories
//        self.assessmentType = assessmentContext.assessmentType
//        self.assessmentID = assessmentContext.id
//        self.characters = fetchCharacters()
//        self.assessmentMetadata = getAssessmentMetadata()
//        assessment?.initialize()
//        return self
//    }
//
//}
//
//extension UnifiedContext
//{
//    // MARK: Getters
//    internal func getCharacterSet() -> [String : String]?
//    {
//        precondition(language != nil)
//        return jsonManager.getCharacters(fileName: "\(language!)_characters")
//    }
//
//    internal func getCategorySet() -> [String : [String]]?
//    {
//        precondition(language != nil)
//        return jsonManager.getCategorySets(fileName: "\(language!)_categories")
//    }
//
//    internal func getAssessmentMetadata() -> AssessmentMetadata?
//    {
//        if coreDataInterface.assessmentMetadataExists(id: assessmentID!, language: language!, assessmentType: assessmentType!) {
//            return coreDataInterface.getAssessmentMetadata(id: assessmentID!,
//                                     language: language!, assessmentType: assessmentType!)
//        }
//        return coreDataInterface.createAssessmentMetadata(id: assessmentID!, language: language!, assessmentType: assessmentType!)
//    }
//
//    internal func getAssessmentContexts() -> [AssessmentContext]?
//    {
//        precondition(language != nil)
//        return jsonManager.getAssessmentContexts(fileName: "\(language!)_contexts")
//    }
//
//    internal func getLanguageMetadata() -> LanguageMetadata?
//    {
//        precondition(language != nil)
//        if coreDataInterface.languageMetadataExists(language: language!)
//        {
//            return coreDataInterface.getLanguageMetadata(language: language!)
//        }
//        return coreDataInterface.createLanguageMetadata(language: language!)
//    }
//
//    internal func getMasteryMapping() -> [String : Bool]?
//    {
//        precondition(language != nil)
//        let allMetadata = coreDataInterface.getAllAssessmentMetadata(language : language!)!
//        var mapping : [String : Bool] = [:]
//        for metadata in allMetadata
//        {
//            mapping[metadata.id!] = metadata.mastered
//        }
//
//        return mapping
//    }
//
//    internal func getMasteredTopics() -> Int
//    {
//        precondition(languageMetadata != nil)
//        return Int(languageMetadata!.masteredTopics)
//    }
//
//    internal func getHighestStreak() -> Int
//    {
//        precondition(languageMetadata != nil)
//        return Int(languageMetadata!.highestStreak)
//    }
//
//    internal func getTotalScore() -> Int
//    {
//        precondition(languageMetadata != nil)
//        return Int(languageMetadata!.totalScore)
//    }
//
//    internal func fetchCharacters() -> [String]
//    {
//        var characters : [String] = []
//        if assessmentType == "dojo"
//        {
//            let assessmentMetadata = coreDataInterface.getAllAssessmentMetadata(language: language!)!
//            for metadata in assessmentMetadata
//            {
//                if metadata.mastered
//                {
//                    let mastered_characters = categorySets![metadata.id!]!
//                    characters.append(contentsOf: mastered_characters)
//                }
//            }
//        } else {
//            for category in categories!
//            {
//                characters.append(contentsOf: categorySets![category]!)
//            }
//        }
//        return characters
//    }
//
//    internal func getCharacterRecordMapping(characters : [String]) -> [String : CharacterRecord]
//    {
//        var mapping : [String : CharacterRecord] = [:]
//        for character in characters
//        {
//            let record = coreDataInterface.createCharacterRecord(character: character, language: language!)
//            mapping[character] = record
//        }
//        return mapping
//    }
//}
//
//extension UnifiedContext
//{
//    // MARK: Assessment Methods
//
//    public func updatePerformance(answer: String, guess: String, correct: Bool, streak: Int)
//    {
//        assessment?.updatePerformance(character: answer, answer: guess, correct: correct)
//        updateHighestStreak(currentStreak: streak)
//    }
//
//    public func updateHighestStreak(currentStreak: Int)
//    {
//        if languageMetadata!.highestStreak < currentStreak
//        {
//            languageMetadata?.setValue(currentStreak, forKey: "highestStreak")
//        }
//        coreDataInterface.update(languageMetadata: languageMetadata!)
//    }
//
//    public func updateScore(score: Int)
//    {
//        let currentScore = getTotalScore()
//        languageMetadata?.setValue(currentScore + score, forKey: "totalScore")
//        coreDataInterface.update(languageMetadata: languageMetadata!)
//    }
//
//    public func updateMastery()
//    {
//        assessment?.updateMastery()
//        languageMetadata?.masteredTopics += 1
//        coreDataInterface.update(languageMetadata: languageMetadata!)
//    }
//}
//
//extension UnifiedContext
//{
//    // MARK: Settings Methods (Delete Methods)
//
//    public func deleteAllCharacterRecords()
//    {
//        coreDataInterface.deleteAllCharacterRecords()
//    }
//
//    public func deleteAllAssessmentMetadata()
//    {
//        coreDataInterface.deleteAllAssessmentMetadata()
//    }
//
//    public func deleteAllLanguageMetadata()
//    {
//        coreDataInterface.deleteAllLanguageMetadata()
//    }
//
//    public func hardReset()
//    {
//        deleteAllLanguageMetadata()
//        deleteAllAssessmentMetadata()
//        deleteAllCharacterRecords()
//    }
//}
