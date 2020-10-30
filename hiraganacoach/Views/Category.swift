//
//  Category.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import Foundation
import SwiftUI

struct Category : Identifiable, View {
    
    
    let label : String
    let hiragana_label : String
    var id: String
    var accuracyTable : AccuracyTable
    var categories : [String]
    
    init(label : String, hiragana_label : String, id : String, accuracyTable : AccuracyTable, categories : [String]) {
        self.label = label
        self.hiragana_label = hiragana_label
        self.id = id
        self.accuracyTable = accuracyTable
        self.categories = categories
    }
    
    var body : some View {
        
        NavigationLink(
            destination: QuizView(categories: self.categories, accuracy_table: accuracyTable),
            label: {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .shadow(color: Color(hue: 1.0, saturation: 0.0, brightness: 0.701), radius: 1.0, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                .background(Color.white)
                        Text(self.hiragana_label)
                            .font(.system(size: 36.0))
                            .fontWeight(.bold)
                    }
                    Spacer().frame(width: 20)
                    Text(label)
                        .font(.system(size: 32.0))
                    Spacer()
                }
            })
    }
    
}
