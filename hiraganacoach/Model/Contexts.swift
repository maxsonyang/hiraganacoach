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
