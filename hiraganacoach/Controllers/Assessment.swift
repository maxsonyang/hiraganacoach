//
//  Assessment.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/2/20.
//

import Foundation

class Assessment
{
    
    var characters : [String] = []
    var coredata_manager : CoreDataManager = CoreDataManager()
    var accuracy_table : AccuracyTable = AccuracyTable()
    var performance : Performance = Performance()
    var assessment_metadata : AssessmentMetadata?
    
    func initialize(assessmentContext : AssessmentContext, languageContext : LanguageContext)
    {
        self.characters = self.fetchCharacters(categories: assessmentContext.categories, assessmentType: assessmentContext.assessmentType, language: languageContext.id)
        accuracy_table.initialize(characters: self.characters, languageContext: languageContext)
        performance.initialize_mapping(characters: self.characters)
        assessment_metadata = coredata_manager.getAssessmentMetadata(id: assessmentContext.id,
                                                                     assessmentType: assessmentContext.assessmentType, language: languageContext.id)
    }
    
    func updatePerformance(character : String, answer : String, correct : Bool)
    {
        accuracy_table.updateAccuracy(character: character, answer: answer, correct: correct)
        performance.updateCharacterPerformance(character: character, correct: correct)
    }
    
    func updateMastery()
    {
        assessment_metadata?.mastered = true
        coredata_manager.saveContext()
    }
    
    func mastered() -> Bool
    {
        return performance.masteryAchieved()
    }
    
    func previouslyMastered() -> Bool
    {
        return assessment_metadata!.mastered
    }
    
    func getNextCharacter(answer : String) -> String
    {
        let characters = removeLastCharacter(character: answer, characters: self.characters).shuffled()
        let chosen_category = recommend(characters: characters, accuracyTable: accuracy_table)
        return chosen_category
    }
    
    func fetchCharacters(categories: [String], assessmentType: String, language: String) -> [String]
    {
        if assessmentType == "dojo"
        {
            var mastered_categories : [String] = []
            let assessmentMetadata = coredata_manager.fetchAllAssessmentMetadataForLanguage(language: language)
            for metadata in assessmentMetadata
            {
                if metadata.mastered
                {
                    let mastered_characters = character_categories[metadata.id!]!
                    mastered_categories.append(contentsOf: mastered_characters)
                }
            }
            return mastered_categories
        }
        return hiraganacoach.fetchCharacters(categories: categories)
    }
}