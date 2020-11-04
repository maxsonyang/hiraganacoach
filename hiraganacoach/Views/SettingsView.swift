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
            Section {
                Button("Delete all assessments", action: {
                    CoreDataManager().deleteAllAssessmentMetadata()
                })
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
