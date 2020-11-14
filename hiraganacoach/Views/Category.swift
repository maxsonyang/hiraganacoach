//
//  Category.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import Foundation
import SwiftUI

struct Category : Identifiable, View {
    
    var id : String = ""
    var languageContext : LanguageContext
    var assessmentContext : AssessmentContext
    var mastered : Bool
    
    init(assessmentContext : AssessmentContext, languageContext: LanguageContext, mastered : Bool)
    {
        self.assessmentContext = assessmentContext
        self.mastered = mastered
        self.languageContext = languageContext
    }
    
    var body : some View {
        NavigationLink(
            destination: QuizView(assessmentContext: assessmentContext, languageContext: languageContext),
            label: {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(mastered ? .rainyBlue : .deepBlue)

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
