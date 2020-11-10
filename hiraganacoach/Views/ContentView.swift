//
//  ContentView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/21/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        LanguageSelectionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
