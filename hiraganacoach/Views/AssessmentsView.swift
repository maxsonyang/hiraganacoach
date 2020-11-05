//
//  AssessmentsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import SwiftUI

struct AssessmentsView: View {
    
    @State var displayedContexts : [AssessmentContext] = []
    var languageContext = "Japanese"
    var languageSubContext = "hiragana"
    
    var body: some View {
        NavigationView {
            List(displayedContexts) { context in
                Category(context: context).frame(height: 60)
            }
            .navigationTitle("Practice")
            .navigationBarItems(trailing: NavigationLink(
                                    destination: SettingsView(),
                                    label: {
                                        Image(systemName: "gear")
                                            .foregroundColor(.gray)
                                    }))
            .onAppear() {
                let jsonContexts = getContexts(fileName: languageSubContext + "_contexts")
                displayedContexts = jsonContexts.filter {
                    filterContext(context: $0)
                }
                characterMapping = getCharacterMapping(fileName: languageSubContext + "_characters")
                character_categories = getCharacterCategories(fileName: languageSubContext + "_categories")
            }
        }
    }
    
    func filterContext(context : AssessmentContext) -> Bool
    {
        if context.assessmentType == "dojo"
        {
            let coredata = CoreDataManager()
            let assessmentMetadata = coredata.fetchAllAssessmentMetadata()
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
        AssessmentsView()
    }
}
