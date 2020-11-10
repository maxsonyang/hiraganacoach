//
//  JSONManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/9/20.
//

import Foundation

public final class JSONManager
{
    // MARK: Core Getters
    private func getJSONData(fileName : String) -> Data?
    {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json")
        {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch let error as NSError {
                fatalError("Could not retrieve \(fileName) error: \(error.debugDescription)")
            }
        }
        return nil
    }
    
    private func getJSONMapping(fileName : String) -> [String : Any]?
    {
        let data = getJSONData(fileName: fileName)!
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any]
            return result
        } catch let error as NSError {
            fatalError("Could not convert \(fileName) into a dictionary; Error: \(error.debugDescription)")
        }
    }
    
    private func getJSONObjectArray(fileName : String) -> [AnyObject]?
    {
        let data = getJSONData(fileName : fileName)!
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [AnyObject]
            return result
        } catch let error as NSError {
            fatalError("Could not convert \(fileName) into an array; Error: \(error.debugDescription)")
        }
    }
}

extension JSONManager
{
    // MARK: Language Data Getters
    public func getCharacters(fileName: String) -> [String : String]?
    {
        let results = getJSONMapping(fileName: fileName)
        precondition(results != nil, "No file found named \(fileName)")
        
        return results as? [String : String]
    }
    
    public func getAssessmentContexts(fileName : String) -> [AssessmentContext]?
    {
        let results = getJSONObjectArray(fileName: fileName)
        precondition(results != nil, "No file found named \(fileName)")
        
        var assessmentContexts : [AssessmentContext] = []
        for result in results!
        {
            // TODO: There must be a better way :(
            let assessmentContext = AssessmentContext(
                label: result["label"]! as! String,
                category_label: result["category_label"]! as! String,
                id: result["id"]! as! String,
                assessmentType: result["assessmentType"]! as! String,
                categories: result["categories"]! as! [String])
            assessmentContexts.append(assessmentContext)
        }
        
        return assessmentContexts
    }
}
