//
//  LanguageSelectionView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/6/20.
//

import SwiftUI

struct LanguageSelectionView: View
{
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.deepBlue
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor.deepBlue
    }
    
    @State var availableLanguages : [LanguageContext] = [
        LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"),
        LanguageContext(id: "katakana", label: "Katakana", family: "Japanese"),
        LanguageContext(id: "bopomofo", label: "Zhuyin", family: "Chinese"),
        LanguageContext(id: "korean", label: "Korean", family: "Korean")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List(availableLanguages) { context in
                        LanguageRow(languageContext: context)
                    }
                }
            }
            .navigationTitle("Languages")
            .navigationBarItems(trailing: NavigationLink(
                                    destination: SettingsView(),
                                    label: {
                                        Image(systemName: "gear")
                                            .font(.system(size: 24.0))
                                            .foregroundColor(.white)
                                    }))
        }.accentColor(.white)
    }
}

struct LanguageRow : View
{
    let languageContext : LanguageContext
    
    init(languageContext : LanguageContext)
    {
        self.languageContext = languageContext
    }
    
    var body: some View
    {
        NavigationLink(
            destination: AssessmentsView(languageContext: languageContext),
            label: {
                Text(languageContext.label)
                    .font(.system(size: 28.0))
                    .foregroundColor(Color.deepBlue)
            })
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView().previewDevice("iPhone 8 Plus")
        LanguageSelectionView().previewDevice("iPhone 11 Pro Max")
        LanguageSelectionView().previewDevice("iPhone XR")
    }
}
