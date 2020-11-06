//
//  Category.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import Foundation
import SwiftUI

struct Category : Identifiable, View {
    
    
    var assessmentContext : AssessmentContext
    var languageContext : LanguageContext
    var id : String
    
    init(assessmentContext : AssessmentContext, languageContext : LanguageContext) {
        self.assessmentContext = assessmentContext
        self.languageContext = languageContext
        self.id = assessmentContext.id
    }
    
    var body : some View {
        NavigationLink(
            destination: QuizView(assessmentContext: assessmentContext, languageContext: languageContext),
            label: {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.deepBlue)

                                .background(Color.white)
                        Text(assessmentContext.category_label)
                            .font(.system(size: assessmentContext.category_label.count > 1 ? 20.0 : 30.0))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .cornerRadius(10.0)
                    Spacer().frame(width: 20)
                    Text(assessmentContext.label)
                        .font(.system(size: 28.0))
                        .foregroundColor(Color.deepBlue)
                    Spacer()
                }
            }).accentColor(.white)
    }
    
}
