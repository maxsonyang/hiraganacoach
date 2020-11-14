//
//  AssessmentsController.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/12/20.
//

import Foundation

public class BaseController
{
    // Interfaces for data.
    internal static var coreDataInterface : CoreDataInterface = {
        let cdm = RevisedCoreDataManager()
        let vc = cdm.mainContext
        return CoreDataInterface(cdm: cdm, vc: vc)
    }()
    internal static let jsonManager : JSONManager = JSONManager()
}

public class AssessmentsController : BaseController
{
    
    // Contextual variables
    private let languageContext : LanguageContext
    private let languageMetadata : LanguageMetadata
    private let assessmentContexts : [AssessmentContext]
    
    init(languageContext : LanguageContext)
    {
        let cdi = AssessmentsController.coreDataInterface
        let json = AssessmentsController.jsonManager
        self.languageContext = languageContext
        self.languageMetadata = cdi.createLanguageMetadata(language: languageContext.id)
        self.assessmentContexts = json.getAssessmentContexts(fileName: "\(languageContext.id)_contexts")!
    }
    
}

extension AssessmentsController
{
    // MARK: Context Getter Methods
    
    public func getNavLabel() -> String
    {
        return languageContext.label
    }
    
    public func getLanguageID() -> String
    {
        return languageContext.id
    }
    
    public func getLanguageFamily() -> String
    {
        return languageContext.family
    }
}

extension AssessmentsController
{
    // MARK: Language Metadata Getters
    
    public func getMasteredTopics() -> Int
    {
        return Int(languageMetadata.masteredTopics)
    }
    
    public func getHighestStreak() -> Int
    {
        return Int(languageMetadata.highestStreak)
    }
    
    public func getTotalScore() -> Int
    {
        return Int(languageMetadata.totalScore)
    }
}

extension AssessmentsController
{
    // MARK: Assessments Metadata Methods
    
    public func getMasteryMapping() -> [String : Bool]
    {
        let cdi = AssessmentsController.coreDataInterface
        if let allMetadata = cdi.getAllAssessmentMetadata(language: getLanguageID())
        {
            var mapping : [String : Bool] = [:]
            for metadata in allMetadata
            {
                mapping[metadata.id!] = metadata.mastered
            }

            return mapping
        }
        return [:]
    }
    
    public func getDisplayedTopics() -> [AssessmentContext]
    {
        return assessmentContexts.filter {
            displayContext(assessmentContext: $0)
        }
    }
    
    private func displayContext(assessmentContext : AssessmentContext) -> Bool
    {
        if assessmentContext.assessmentType == "dojo"
        {
            // Do something
            let cdi = AssessmentsController.coreDataInterface
            if let assessmentMetadata = cdi.getAllAssessmentMetadata(language: getLanguageID()) {
                for metadata in assessmentMetadata
                {
                    if metadata.mastered
                    {
                        return true
                    }
                }
                return false
            } else {
                print("Could not get assessmentMetadata for \(getLanguageID())")
                return false
            }
        }
        
        return true
    }
}
