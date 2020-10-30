//
//  AssessmentsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/23/20.
//

import SwiftUI

struct AssessmentsView: View {
    
    var body: some View {
        NavigationView {
            List(contexts) { context in
                Category(context: context).frame(height: 60)
            }
            .navigationTitle("Practice")
        }
    }
}

struct AssessmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentsView()
    }
}
