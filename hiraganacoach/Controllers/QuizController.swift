//
//  QuizController.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/12/20.
//

import Foundation

class QuizController : BaseController
{
    
    let assessmentContext : AssessmentContext
    let languageContext : LanguageContext
    
    // Assets loaded on upon view.
    var assessmentMetadata : AssessmentMetadata?
    var characters : [String] = []
    var characterSet : [String : String] = [:]
    var languageMetadata : LanguageMetadata?
    var assessment : Assessment?
    
    
    init(assessmentContext : AssessmentContext, languageContext: LanguageContext)
    {
        self.assessmentContext = assessmentContext
        self.languageContext = languageContext
    }
    
    public func initializeController()
    {
        let cdi = BaseController.coreDataInterface
        let json = BaseController.jsonManager
        self.languageMetadata = cdi.getLanguageMetadata(language: languageContext.id)!
        let assessmentMetadata = cdi.createAssessmentMetadata(id: assessmentContext.id,
                                                              language: languageContext.id, assessmentType: assessmentContext.assessmentType)
        let characters = QuizController.fetchCharacters(assessmentContext: assessmentContext, languageContext: languageContext)
        let recordMapping = QuizController.getCharacterRecordMapping(characters: characters, language : languageContext.id )
        self.assessment = Assessment(characters: characters, assessmentMetadata: assessmentMetadata, recordMapping: recordMapping)
        self.assessmentMetadata = assessmentMetadata
        self.characters = characters
        self.characterSet = json.getCharacters(fileName: "\(languageContext.id)_characters")!
    }
    
}

extension QuizController
{
    // Initialization Methods
    
    static internal func getCharacterRecordMapping(characters : [String], language : String) -> [String : CharacterRecord]
        {
            let cdi = BaseController.coreDataInterface
            var mapping : [String : CharacterRecord] = [:]
            for character in characters
            {
                let record = cdi.createCharacterRecord(character: character, language: language)
                mapping[character] = record
            }
            return mapping
        }
    
    static internal func fetchCharacters(assessmentContext : AssessmentContext, languageContext: LanguageContext) -> [String]
    {
        var characters : [String] = []
        let json = BaseController.jsonManager
        let categorySets = json.getCategorySets(fileName: "\(languageContext.id)_categories")
        if assessmentContext.assessmentType == "dojo"
        {
            let cdi = BaseController.coreDataInterface
            let assessmentMetadata = cdi.getAllAssessmentMetadata(language: languageContext.id)!
            for metadata in assessmentMetadata
            {
                if metadata.mastered
                {
                    let mastered_characters = categorySets![metadata.id!]!
                    characters.append(contentsOf: mastered_characters)
                }
            }
        } else {
            for category in assessmentContext.categories
            {
                characters.append(contentsOf: categorySets![category]!)
            }
        }
        return characters
    }
}

extension QuizController
{
    // MARK: Assessment Interfacing methods
    
    public func mastered() -> Bool
    {
        return assessment!.mastered()
    }
    
    public func updateMastery()
    {
        assessment!.updateMastery()
    }
    
    public func previouslyMastered() -> Bool
    {
        return assessment!.previouslyMastered()
    }
}

extension QuizController
{
    // MARK: Performance Update methods
    
    public func updatePerformance(answer: String, guess: String, correct: Bool, streak: Int)
    {
        assessment!.updatePerformance(character: answer, answer: guess, correct: correct)
        if correct
        {
            incrementCategoryScore()
        }
        updateHighestStreak(streak: streak)
    }
    
    private func updateHighestStreak(streak: Int)
    {
        if languageMetadata!.highestStreak < streak
        {
            languageMetadata!.setValue(streak, forKey: "highestStreak")
            BaseController.coreDataInterface.update(languageMetadata: languageMetadata!)
        }
        if assessmentMetadata!.highestStreak < streak
        {
            assessmentMetadata!.setValue(streak, forKey: "highestStreak")
            BaseController.coreDataInterface.update(metadata: assessmentMetadata!)
        }
    }
    
    private func incrementCategoryScore()
    {
        languageMetadata!.totalScore += 1
    }
}

extension QuizController
{
    // MARK: Quiz Character Update
    
    public func getNewCharacter(answer : String) -> String
    {
        return assessment!.getNextCharacter(answer: answer)
    }
    
    public func getValueForCharacter(character : String) -> String
    {
        return characterSet[character]!
    }
}

extension QuizController
{
    // MARK: Answer Validation
    
    public func validGuess(guess: String) -> Bool
    {
        let lowered_answer = guess.lowercased()
        return self.characters.contains(lowered_answer)
    }
}
