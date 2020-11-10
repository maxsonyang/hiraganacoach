//
//  QuizView.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 10/21/20.
//

import SwiftUI
import CoreData
import NotificationBannerSwift

struct QuizView: View {
    
    @State var score : Int = 0
    @State var streak : Int = 0
    @State var guess : String = ""
    @State var displayAnswer : Bool = false
    @State var displayedText : String = ""
    @State var character : String = ""
    @State var answer : String = ""
    
    var assessmentContext : AssessmentContext
    var languageContext : LanguageContext
    var assessment : Assessment = ASSESSMENT
    
    init(assessmentContext : AssessmentContext, languageContext : LanguageContext)
    {
        self.assessmentContext = assessmentContext
        self.languageContext = languageContext
    }
    
    var body: some View {
        ZStack {
            // Background Color
            Color.deepBlue
                .ignoresSafeArea()
            
            VStack {
                Text("Identify the Character")
                    .fontWeight(.bold)
                    .font(.system(size: 24.0))
                    .foregroundColor(.white)
                
                HStack {
                    ScoreCardView(text: "Score: \(score)", bg_color: Color.mellowLime)
                    ScoreCardView(text: "Streak: \(streak)", bg_color: Color.peachyOrange)
                }
                Spacer().frame(height: 50)
                VStack{
                    CharacterCardView(character: $displayedText)
                    HStack {
                        Spacer()
                        Button(action: {
                            displayAnswer.toggle()
                            displayedText = getCardText()
                            streak = 0
                        }, label: {
                            VStack {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 24))
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .padding(10)
                            }
                            .background(Color.rainyBlue)
                            .frame(width: 40, height: 40)
                            .cornerRadius(100)
                        })
                    }.frame(width: 150, alignment: .center)
                }
                Spacer().frame(height: 75.0)
                HStack {
                    ZStack(alignment: .leading) {
                        TextField("", text: $guess)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.leading)
                            .frame(width: 150, height: 50, alignment: .leading)
                            .font(.system(size: 24.0))
                            .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(.white))
                            .foregroundColor(.deepBlue)
                            .accentColor(.deepBlue)
                        if guess.isEmpty {
                            Text("romaji").foregroundColor(.rainyBlue).font(.system(size: 24.0)).padding(.leading, 17)

                        }
                    }
                    Button(action: {
                        if guess.lowercased() == answer {
                            displayAnswer = false
                            score += 1
                            streak += 1
                            guess = ""
                            assessment.updatePerformance(character: answer, answer: guess, correct: true)
                            // This must always be at the end!!!
                            updateCharacter()
                            if assessment.mastered() && !assessment.previouslyMastered()
                            {
                                assessment.updateMastery()
                                let banner = FloatingNotificationBanner(title: "Great work!", subtitle: "You're ready to move on to the next topic!", style: .success)
                                banner.show()
                            }
                        } else {
//                            let mistaken_character = characterMapping[guess]
//                            if mistaken_character != nil {
                            if assessment.characters.contains(guess) {
                                streak = 0
                                assessment.updatePerformance(character: answer, answer: guess, correct: false)
                            }
                        }
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                    })
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.white)
                    .foregroundColor(.rainyBlue)
                    .cornerRadius(10.0)
                }
                Spacer().frame(height: 100)
            }
            .onAppear() {
                initializeContext()
            }.onDisappear() {
                updateHighestStreak()
            }
        }
    }
    
    func getCardText() -> String
    {
        if (displayAnswer) {
            return answer
        } else {
            return character
        }
    }
    
    func getNewCharacter() -> String
    {
        return assessment.getNextCharacter(answer: answer)
    }

    func updateCharacter()
    {
        let new_character = getNewCharacter()
        answer = new_character
        character = characterMapping[answer]!
        displayedText = getCardText()
    }
    
    func initializeContext()
    {
        assessment.initialize(assessmentContext: self.assessmentContext, languageContext: self.languageContext)
        updateCharacter()
        displayedText = character
    }
    
    func updateHighestStreak()
    {
        let manager = CoreDataManager()
        let fetchedMetadata = manager.fetchAssessmentMetadata(id: assessmentContext.id, assessmentType: assessmentContext.assessmentType, language: languageContext.id)
        if fetchedMetadata.count > 0
        {
            let metadata = fetchedMetadata[0]
            print(metadata)
            if metadata.highestStreak < streak {
                print("hello")
                metadata.setValue(streak, forKey: "highestStreak")
                manager.saveContext()
            }
        }
    }
}

func fetchCharacters(categories : [String]) -> [String]
{
    var results : [String] = []
    for category in categories
    {
        print(category)
        let characters = character_categories[category]!
        for character in characters
        {
            results.append(character)
        }
    }
    return results
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(assessmentContext: AssessmentContext(label: "Vowels", category_label: "vowels", id: "vowels", assessmentType: "practice", categories: ["vowels"]), languageContext: LanguageContext(id: "hiragana", label: "Hiragana", family: "Japanese"))
    }
}

struct CharacterCardView: View {
    
    /*
        Card that displays the main character
     */
    
    @Binding var character : String
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
//                .frame(width: 200, height: 200, alignment: .center)
//                .foregroundColor(.white)
//                .shadow(color: Color(hue: 1.0, saturation: 0.0, brightness: 0.701, opacity: 0.469), radius: 5.0, x: 0.0, y: 0.0)
//                    .background(Color.white)
            Text(character)
                .font(.system(size: 120.0))
                .foregroundColor(.white)
        }
    }
}

struct ScoreCardView: View {
    
    var text : String
    var bg_color : Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                .fill(bg_color)
                .frame(width: 100, height: 40, alignment: .leading)

            Text(text)
                .font(.system(size: 18.0))
                .foregroundColor(.white)
        }
    }
    
}
