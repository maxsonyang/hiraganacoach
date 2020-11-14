//
//  Assessment.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/2/20.
//

import Foundation

public class Assessment
{
    
    public var characters : [String] = []
    public var accuracy_table : AccuracyTable = AccuracyTable()
    public var performance : Performance = Performance()
    public var assessment_metadata : AssessmentMetadata
    
    init(characters: [String], assessmentMetadata: AssessmentMetadata, recordMapping: [String : CharacterRecord])
    {
        self.characters = characters
        accuracy_table.initialize(characters: self.characters, recordMapping: recordMapping)
        performance.initialize_mapping(characters: self.characters)
        assessment_metadata = assessmentMetadata
    }
    
    func updatePerformance(character : String, answer : String, correct : Bool)
    {
        accuracy_table.updateAccuracy(character: character, answer: answer, correct: correct)
        performance.updateCharacterPerformance(character: character, correct: correct)
    }
    
    func updateMastery()
    {
        assessment_metadata.mastered = true
    }
    
    func mastered() -> Bool
    {
        return performance.masteryAchieved()
    }
    
    func previouslyMastered() -> Bool
    {
        return assessment_metadata.mastered
    }
    
    func getNextCharacter(answer : String) -> String
    {
        let characters = removeLastCharacter(character: answer, characters: self.characters).shuffled()
        let chosen_category = recommend(characters: characters, accuracyTable: accuracy_table)
        return chosen_category
    }
    
}
