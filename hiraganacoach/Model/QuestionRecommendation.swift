//
//  QRecObjects.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import Foundation
import CoreData

class AccuracyTable {
    
    var coredata_manager : CoreDataManager = CoreDataManager()
    var record_mapping : [String : CharacterRecord] = [:]
    
    func initialize_mapping(characters : [String])
    {
        record_mapping = coredata_manager.getCharacterRecordMappings(characters: characters)
    }
    
    func updateAccuracy(character : String, answer : String, correct : Bool)
    {
        /*
            Method that updates a particular record for a character.
            Retrieves a confusion/answer index which stores the amount
            of attempts + mistakes for a particular response given by user WHEN tasked
            with answering a particular question
         */
        
        // Retrieve the character's record and confusion index.
        let character_record = record_mapping[character]!
        var confusion_index = character_record.confusion_index as! [String : [String : Int]]
        let result = confusion_index[answer]
        var answer_index : [String : Int]
        
        // Check if the answer index exists, if it doesn't add it to the confusion_index
        // Otherwise unwrap.
        if result == nil {
            answer_index = [
                "attempts" : 0,
                "mistakes" : 0
            ]
            confusion_index[answer] = answer_index
        } else {
            answer_index = result!
        }
        
        if correct {
            character_record.correct += 1
        } else {
            answer_index["mistakes"]! += 1
        }
        answer_index["attempts"]! += 1
        character_record.attempts += 1
        
        confusion_index[answer] = answer_index
        character_record.confusion_index = confusion_index as NSObject
        coredata_manager.saveContext()
    }
    
    func getCorrectAttempts(character : String) -> Int
    {
        let character_record = record_mapping[character]!
        return Int(character_record.correct)
    }
    
    func getAttempts(character: String) -> Int
    {
        let character_record = record_mapping[character]!
        return Int(character_record.attempts)
    }
    
    func getAccuracy(character: String) -> Double
    {
        let attempts = getAttempts(character: character)
        if attempts == 0
        {
            return 0.0
        }
        let correct = getCorrectAttempts(character: character)
        return Double(correct) / Double(attempts)
    }
    
    func getRecommendationAccuracy(character: String) -> Double
    {
        return min(getAccuracy(character: character), 0.9)
    }
    
    func printRecordsNicely()
    {
        
        for key in record_mapping.keys
        {
            let record = record_mapping[key]!
            
            print(
            """
            Key: \(key)
                Correct: \(record.correct)
                Attempts: \(record.attempts)
                Accuracy: \(getAccuracy(character: key) * 100)%
            """)
            
        }
        
    }
    
}

func recommend(characters : [String], accuracyTable : AccuracyTable) -> String
{
    let filteredByAccuracy = filterByAccuracy(characters: characters, accuracyTable: accuracyTable)
    return recommendByFrequency(characters: filteredByAccuracy, accuracyTable: accuracyTable)
}

func filterByAccuracy(characters : [String], accuracyTable : AccuracyTable) -> [String]
{
    /*
        Returns a set of characters to choose from based on
        a randomly chosen accuracy. Sets with lower accuracy
        are given a greater weight than those of higher accuracy.
     
        TODO: Need to redo the weights so it doesn't seem so hacky.
     */
    
    // First assign characters into sets and get accuracies + their weights.
    var weights : [Double : Double] = [:]
    var accuracySets : [Double : [String]] = [:]
    for character in characters
    {
        let accuracy = accuracyTable.getRecommendationAccuracy(character: character).roundToOneDecimal()
        let weight = 15.0 - accuracy
        weights[accuracy] = weight
        if accuracySets[weight] == nil {
            accuracySets[weight] = [character]
        } else {
            accuracySets[weight]!.append(character)
        }
    }
    
    // Calculate the total weight
    let total_weight = Array(weights.values).reduce(0, +)
    
    // Get a random weight.
    let random_number = Double.random(in: 0...total_weight)
    
    var running_total = 0.0
    for weight in weights.keys {
        let value = weights[weight]!
        running_total += value
        if running_total >= random_number
        {
            let key = weights[weight]!
            return accuracySets[key]!
        }
    }
    
    return []
}


func recommendByFrequency(characters : [String], accuracyTable : AccuracyTable) -> String
{
    /*
        Recommends a character based on the total number of encounters
        the user has had with the particular character regardless of
        correctness.
     */
    
    let total_attempts = getTotalCharacterAttempts(characters: characters, accuracyTable: accuracyTable)
    var reversed_total = 0
    var reversed_frequencies : [String : Int] = [:]
    for character in characters
    {
        let difference = total_attempts - accuracyTable.getAttempts(character: character)
        reversed_frequencies[character] = difference
        reversed_total += difference
    }
    
    let random_number = Int.random(in: 0...reversed_total)
    var running_total = 0
    for character in characters.shuffled()
    {
        running_total += reversed_frequencies[character]!
        if random_number <= running_total
        {
            return character
        }
    }
    
    return ""
}


func removeLastCharacter(character : String, characters : [String]) -> [String]
{
    // Removes the last chosen character from consideration.
    let filtered = characters.filter { $0 != character }
    return filtered
}

func getTotalCharacterAttempts(
    characters : [String],
    accuracyTable : AccuracyTable) -> Int
{
    var total = 0
    
    for character in characters
    {
        total += accuracyTable.getAttempts(character: character)
    }
    
    return total
}

func getTotalCorrectCharacterAttempts(
    characters : [String],
    accuracyTable : AccuracyTable) -> Int
{
    var total = 0
    
    for character in characters
    {
        total += accuracyTable.getCorrectAttempts(character: character)
    }
    
    return total
}
    
func getTotalCharacterAccuracies(
    characters : [String],
    accuracyTable : AccuracyTable) -> Double
{
    var total : Double = 0.0
    
    for character in characters
    {
        total += accuracyTable.getAccuracy(character: character)
    }
    
    return total
}

extension Double {
    // Credits to Sebastian and mrh.is @ StackOverflow
    // Link: https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
    func roundToOneDecimal() -> Double
    {
        let number = floor(self * 10.0)
        return number
    }
}

func getMasteredCategories() -> [String]
{
    var results : [String] = []
    let manager = CoreDataManager()
    let all_metadata = manager.fetchAllAssessmentMetadata()
    for metadata in all_metadata
    {
        if metadata.mastered && metadata.assessmentType == "practice"
        {
            results.append(metadata.id!)
        }
    }
    return results
}

