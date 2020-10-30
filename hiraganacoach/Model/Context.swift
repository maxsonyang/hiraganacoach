//
//  Context.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/29/20.
//

import Foundation

struct AssessmentContext : Identifiable
{
    /*
        Class used to define how a view should be generated to adhere
        to the  flyweight design pattern.
     */
    let label : String
    let hiragana_label : String
    let id : String
    let assessmentType : String
    let characters : [String]
    
    init(label: String, hiragana_label : String,
         id : String, assessmentType : String, categories : [String])
    {
        self.label = label
        self.hiragana_label = hiragana_label
        self.id = id
        self.characters = fetchCharacters(categories: categories)
        self.assessmentType = assessmentType
    }
}
