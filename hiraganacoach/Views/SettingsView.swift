//
//  SettingsView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/2/20.
//

import SwiftUI

struct SettingsView: View {
    
    let coreDataInterface = BaseController.coreDataInterface
    
    var body: some View {
        Form {
            Section(header: Text("Personal Performance")
                        .foregroundColor(.white)) {
                Button("Delete all assessments", action: {
                    coreDataInterface.deleteAllAssessmentMetadata()
                }).foregroundColor(.deepBlue)
                Button("Delete all performance", action: {
                    coreDataInterface.deleteAllCharacterRecords()
                    coreDataInterface.deleteAllLanguageMetadata()
                }).foregroundColor(.deepBlue)
                Button("Hard Reset", action: {
                    coreDataInterface.hardReset()
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
