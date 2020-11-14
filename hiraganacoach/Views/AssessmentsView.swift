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
    
    var assessmentsController : AssessmentsController
    var languageContext : LanguageContext
    
    init(languageContext : LanguageContext) {
        self.assessmentsController = AssessmentsController(languageContext: languageContext)
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
                            Text("\(categoryScore)").font(.system(size: 24.0)).foregroundColor(.cyanProcess)
                            Text("correct answers").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        Spacer()
                        VStack {
                            Text("\(masteredTopics)").font(.system(size: 24.0)).foregroundColor(.cyanProcess)
                            Text("topics mastered").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        Spacer()
                        VStack {
                            Text("\(highestStreak)").font(.system(size: 24.0)).foregroundColor(.cyanProcess)
                            Text("longest streak").foregroundColor(.deepBlue).font(.system(size: 12.0))
                        }
                        
                    }
                }
                Section(header: Text("Practice").foregroundColor(.white)) {
                    List(displayedContexts) { context in
                        if context.id == "dojo" {
                            Category(assessmentContext: context, languageContext: languageContext,
                                     mastered: true)
                                .frame(height: 60)
                        } else {
                            if masteryMapping[context.id] == nil {
                                Category(assessmentContext: context, languageContext: languageContext,
                                         mastered: false)
                                    .frame(height: 60)
                            } else {
                                Category(assessmentContext: context, languageContext: languageContext,
                                         mastered: masteryMapping[context.id]!)
                                    .frame(height: 60)
                            }
                        }
                    }.listRowBackground(Color.white)
                }
            }
            .navigationTitle(Text(assessmentsController.getNavLabel()))
            .onAppear() {
                initializeView()
            }
    }
    
    func initializeView()
    {
        displayedContexts = assessmentsController.getDisplayedTopics()
        masteryMapping = assessmentsController.getMasteryMapping()
        masteredTopics = assessmentsController.getMasteredTopics()
        categoryScore = assessmentsController.getTotalScore()
        highestStreak = assessmentsController.getHighestStreak()
    }
}

struct AssessmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentsView(languageContext: LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"))
    }
}
