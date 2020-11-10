//
//  JSONManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/4/20.
//

import Foundation

func openJSONFile(fileName : String) -> Data
{
    if let path = Bundle.main.path(forResource: fileName, ofType: "json")
    {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return data
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    return Data()
}

func getContexts(fileName : String) -> [AssessmentContext]
{
    let jsonData = openJSONFile(fileName: fileName)
    if let contexts =  try? JSONDecoder().decode([AssessmentContext].self, from: jsonData)
    {
        return contexts
    }
    return []
}

func getCharacterMapping(fileName : String) -> [String : String]
{
    let jsonData = openJSONFile(fileName: fileName)
    if let contexts = try? JSONDecoder().decode([String:String].self, from: jsonData)
    {
        return contexts
    }
    return [:]
}

func getCharacterCategories(fileName : String) -> [String : [String]]
{
    let jsonData = openJSONFile(fileName: fileName)
    if let contexts = try? JSONDecoder().decode([String: [String]].self, from: jsonData)
    {
        return contexts
    }
    return [:]
}
