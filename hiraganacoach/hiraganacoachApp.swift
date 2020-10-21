//
//  hiraganacoachApp.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/21/20.
//

import SwiftUI

@main
struct hiraganacoachApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
