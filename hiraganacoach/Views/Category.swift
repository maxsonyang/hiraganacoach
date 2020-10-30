//
//  Category.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import Foundation
import SwiftUI

struct Category : Identifiable, View {
    
    
    var context : AssessmentContext
    var id : String
    
    init(context : AssessmentContext) {
        self.context = context
        self.id = context.id
    }
    
    var body : some View {
        
        NavigationLink(
            destination: QuizView(context: self.context),
            label: {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .shadow(color: Color(hue: 1.0, saturation: 0.0, brightness: 0.701), radius: 1.0, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                .background(Color.white)
                        Text(context.hiragana_label)
                            .font(.system(size: 36.0))
                            .fontWeight(.bold)
                    }
                    Spacer().frame(width: 20)
                    Text(context.label)
                        .font(.system(size: 32.0))
                    Spacer()
                }
            })
    }
    
}
