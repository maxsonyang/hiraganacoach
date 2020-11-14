//
//  Assessment.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/29/20.
//

import Foundation

public class Performance
{
    public var character_performance : [String : [String : Int]] = [:]
    
    public  func initialize_mapping(characters : [String])
    {
        var temp_dict : [String : [String : Int]] = [:]
        for character in characters
        {
            temp_dict[character] = [
                "streak" : 0,
                "attempts" : 0
            ]
        }
        self.character_performance = temp_dict
    }
    
    public func updateCharacterPerformance(character : String, correct : Bool)
    {
        if correct {
            character_performance[character]!["streak"]! += 1
        } else {
            character_performance[character]!["streak"] = 0
        }
        // Attempt always gets updated no matter what.
        character_performance[character]!["attempts"]! += 1
    }
    
    public func masteryAchieved() -> Bool
    {
        for character in character_performance.keys
        {
            let performance_dict = character_performance[character]!
            if performance_dict["streak"]! < 10 || performance_dict["attempts"]! < 10
            {
                return false
            }
        }
        return true
    }
}
