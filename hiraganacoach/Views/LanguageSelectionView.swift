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
    
    @State var languageContexts : [LanguageContext] = [
        LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"),
        LanguageContext(id: "korean", label: "Korean", family: "Korean"),
        LanguageContext(id: "katakana", label: "Katakana", family: "Japanese")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List(languageContexts) { context in
                        LanguageRow(context: context)
                            .frame(height: 40)

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
    var context : LanguageContext
    
    init(context : LanguageContext)
    {
        self.context = context
    }
    
    var body: some View
    {
        NavigationLink(
            destination: AssessmentsView(languageContext: context),
            label: {
                Text(context.label)
                    .font(.system(size: 28.0))
                    .foregroundColor(Color.deepBlue)
            })
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
    }
}
