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
    @State var sectionMastered : Bool = false
    @State var streakBroken : Bool = false
    @State var globalStreakBroken : Bool = false
    
    var quizController : QuizController
    var languageContext : LanguageContext
    var assessmentContext : AssessmentContext?
    
    init(assessmentContext : AssessmentContext, languageContext : LanguageContext)
    {
        self.assessmentContext = assessmentContext
        self.languageContext = languageContext
        quizController = QuizController(assessmentContext: assessmentContext, languageContext: languageContext)
    }
    
    var body: some View {
        ZStack {
            // Background Color
            Color.deepBlue
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(assessmentContext!.label)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "star.fill")
                            .font(.system(size: 18.0))
                            .foregroundColor(sectionMastered ? .starYellow : .rainyBlue)
                    
                }
                Spacer().frame(height: 10)
                Text("Identify the Character")
                    .font(.title2)
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
                            if streak > Int(quizController.languageMetadata!.highestStreak) && !globalStreakBroken
                            {
                                Banners.getGlobalStreakRecordBanner(section: "").show()
                                globalStreakBroken = true
                            }
                            else if streak > Int(quizController.assessmentMetadata!.highestStreak) && !streakBroken
                            {
                                Banners.getLocalStreakRecordBanner(section: quizController.assessmentContext.label).show(
                                    bannerPosition: .top,
                                    cornerRadius: 8,
                                    shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                                    shadowBlurRadius: 16,
                                    shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
                                )
                                streakBroken = true
                            }
                            switch quizController.languageMetadata?.totalScore
                            {
                                case 50:
                                    Banners.getScoreAchievementBanner(score: 50).show()
                                    break
                                case 100:
                                    Banners.getScoreAchievementBanner(score: 100).show()
                                    break
                                case 200:
                                    Banners.getScoreAchievementBanner(score: 200).show()
                                    break
                                case 500:
                                    Banners.getScoreAchievementBanner(score: 500).show()
                                    break
                                case 1000:
                                    Banners.getScoreAchievementBanner(score: 1000).show()
                                    break
                                case 2000:
                                    Banners.getScoreAchievementBanner(score: 2000).show()
                                    break
                                case 4000:
                                    Banners.getScoreAchievementBanner(score: 4000).show()
                                    break
                                default:
                                    break
                            }
                            quizController.updatePerformance(answer: answer, guess: guess.lowercased(), correct: true, streak: streak)
                            guess = ""
                            // This must always be at the end!!!
                            updateCharacter()
                            if (quizController.mastered()) && !(quizController.previouslyMastered())
                            {
                                if !(assessmentContext?.assessmentType == "dojo")
                                {
                                    quizController.updateMastery()
                                    sectionMastered = true
                                    let banner = Banners.getMasteredBanner()
                                    banner.show()
                                }
                            }
                        } else {
                            if quizController.validGuess(guess: guess) {
                                streak = 0
                                quizController.updatePerformance(answer: answer, guess: guess.lowercased(), correct: false, streak: streak)
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
                let assessmentHS = quizController.assessmentMetadata!.highestStreak
                streakBroken = assessmentHS == 0
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

    func updateCharacter()
    {
        let new_character = quizController.getNewCharacter(answer: answer)
        answer = new_character
        character = quizController.getValueForCharacter(character: answer)
        displayedText = getCardText()
    }
    
    func initializeContext()
    {
        quizController.initializeController()
        updateCharacter()
        displayedText = character
        sectionMastered = quizController.previouslyMastered()
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
