//
//  LanguageOverview.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/17/20.
//

import SwiftUI

struct LanguageOverview: View {
    
    @State var languages : [String] = [
        "Chinese",
        "Japanese",
        "Korean"
    ]
    
    var body: some View {
        Form {
            Section {
                List(languages, id: \.self) { language in
                    Text(language)
                }
            }
        }
    }
}

struct LanguageOverview_Previews: PreviewProvider {
    static var previews: some View {
        LanguageOverview()
    }
}
