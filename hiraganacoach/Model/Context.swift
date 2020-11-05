//
//  Context.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/29/20.
//

import Foundation

struct AssessmentContext : Identifiable, Codable
{
    /*
        Class used to define how a view should be generated to adhere
        to the flyweight design pattern.
     */
    let label : String
    let category_label : String
    let id : String
    let assessmentType : String
    let categories : [String]
    
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
