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
    
    func initialize(context : AssessmentContext)
    {
        self.characters = context.characters
        accuracy_table.initialize_mapping(characters: self.characters)
        performance.initialize_mapping(characters: self.characters)
        assessment_metadata = coredata_manager.getAssessmentMetadata(id: context.id,
                                                                     assessmentType: context.assessmentType)
        print(assessment_metadata?.id)
        print(assessment_metadata?.mastered)
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
}
