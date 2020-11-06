//
//  AssessmentsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import SwiftUI

struct AssessmentsView: View {
    
    @State var displayedContexts : [AssessmentContext] = []
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
                Section {
                    List(displayedContexts) { context in
                        Category(assessmentContext: context, languageContext: languageContext)
                            .frame(height: 60)
                    }.listRowBackground(Color.white)
                }
            }
            .navigationTitle(Text("Practice"))
            .onAppear() {
                initializeLanguageData(language: languageContext.id)
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
}

struct AssessmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentsView(languageContext: LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"))
    }
}
