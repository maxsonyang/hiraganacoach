//
//  AssessmentsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import SwiftUI

struct AssessmentsView: View {
    
    @State var displayedContexts : [AssessmentContext] = []
    @State var masteryMapping : [String : Bool] = [:]
    @State var categoryScore : Int = 0
    @State var masteredTopics : Int = 0
    @State var highestStreak : Int = 0
    var languageContext : LanguageContext
    
    init(languageContext : LanguageContext) {
        self.languageContext = languageContext
        UITableView.appearance().backgroundColor = UIColor.deepBlue
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor.deepBlue
    }
    
    var body: some View {
            Form {
                Section(header: Text("Performance").foregroundColor(.white)) {
                    HStack {
                        VStack {
                            Text("\(categoryScore)").font(.system(size: 18.0)).foregroundColor(.cyanProcess)
                            Text("correct answers").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        Spacer()
                        VStack {
                            Text("\(masteredTopics)").font(.system(size: 18.0)).foregroundColor(.cyanProcess)
                            Text("topics mastered").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        Spacer()
                        VStack {
                            Text("\(highestStreak)").font(.system(size: 18.0)).foregroundColor(.cyanProcess)
                            Text("longest streak").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        
                    }
                }
                Section(header: Text("Practice").foregroundColor(.white)) {
                    List(displayedContexts) { context in
                        if context.id == "dojo" {
                            Category(assessmentContext: context, languageContext: languageContext, mastered: true)
                                .frame(height: 60)
                        } else {
                            if masteryMapping[context.id] == nil {
                                Category(assessmentContext: context, languageContext: languageContext, mastered: false)
                                    .frame(height: 60)
                            } else {
                                Category(assessmentContext: context, languageContext: languageContext, mastered: masteryMapping[context.id]!)
                                    .frame(height: 60)
                            }
                        }
                    }.listRowBackground(Color.white)
                }
            }
            .navigationTitle(Text(languageContext.label))
            .onAppear() {
                initializeLanguageData(language: languageContext.id)
                masteryMapping = CoreDataManager().fetchMasteryArray(language: languageContext.id)
                // TODO: Do one, larger request instead of multiple smaller ones.
                masteredTopics = getMasteredTopics()
                categoryScore = getCategoryScore()
                highestStreak = getHighestStreak()
            }
    }
    
    func initializeLanguageData(language: String)
    {
        let jsonContexts = getContexts(fileName: languageContext.id + "_contexts")
        displayedContexts = jsonContexts.filter {
            filterContext(context: $0, language: language)
        }
        characterMapping = getCharacterMapping(fileName: languageContext.id + "_characters")
        character_categories = getCharacterCategories(fileName: languageContext.id + "_categories")
    }
    
    func filterContext(context : AssessmentContext, language: String) -> Bool
    {
        if context.assessmentType == "dojo"
        {
            let coredata = CoreDataManager()
            let assessmentMetadata = coredata.fetchAllAssessmentMetadataForLanguage(language: language)
            for metadata in assessmentMetadata
            {
                if metadata.mastered
                {
                    return true
                }
            }
        }
        if context.assessmentType == "practice"
        {
            return true
        }
        return false
    }
    
    func getCategoryScore() -> Int
    {
        return CoreDataManager().fetchLanguageScore(language: languageContext.id)
    }
    
    func getHighestStreak() -> Int
    {
        return CoreDataManager().fetchHighestStreak(language: languageContext.id)
    }
    
    func getMasteredTopics() -> Int
    {
        var count = 0
        for key in masteryMapping.keys
        {
            count += (masteryMapping[key]! ? 1 : 0)
        }
        return count
    }
}

struct AssessmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentsView(languageContext: LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"))
    }
}
