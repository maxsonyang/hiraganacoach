//
//  SettingsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/2/20.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Personal Performance")) {
                Button("Delete all assessments", action: {
                    CoreDataManager().deleteAllAssessmentMetadata()
                }).foregroundColor(.deepBlue)
                Button("Delete all performance", action: {
                    CoreDataManager().deleteAllCharacterRecords()
                }).foregroundColor(.deepBlue)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
