//
//  WordleViewModel.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI
import GameKit

struct WordleColors {
    static let rightPlace = Color(uiColor: #colorLiteral(red: 0.244219631, green: 0.7725548148, blue: 0.7890618443, alpha: 1))
    static let rightPlaceShadow = Color(uiColor: #colorLiteral(red: 0.1710186601, green: 0.5491942167, blue: 0.5561188459, alpha: 1))
    static let rightLetter = Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1))
    static let rightLetterShadow = Color(uiColor: #colorLiteral(red: 0.8136706352, green: 0.4051097035, blue: 0.01514841989, alpha: 1))
    static let wrong = Color(uiColor: #colorLiteral(red: 0.5058823824, green: 0.505882442, blue: 0.5058823824, alpha: 1))
    static let wrongShadow = Color(uiColor: #colorLiteral(red: 0.3137255013, green: 0.3137255013, blue: 0.3137255013, alpha: 1))
    
    static let rightPlaceBlind = Color(uiColor: #colorLiteral(red: 1, green: 0.5614245534, blue: 0.3310378194, alpha: 1))
    static let rightPlaceShadowBlind = Color(uiColor: #colorLiteral(red: 0.8136706352, green: 0.4051097035, blue: 0.01514841989, alpha: 1))
    static let rightLetterBlind = Color(uiColor: #colorLiteral(red: 0.4285933971, green: 0.7139324546, blue: 0.9999988675, alpha: 1))
    static let rightLetterShadowBlind = Color(uiColor: #colorLiteral(red: 0.4789951444, green: 0.611972332, blue: 0.7388407588, alpha: 1))
    static let wrongBlind = Color(uiColor: #colorLiteral(red: 0.5058823824, green: 0.505882442, blue: 0.5058823824, alpha: 1))
    static let wrongShadowBlind = Color(uiColor: #colorLiteral(red: 0.3137255013, green: 0.3137255013, blue: 0.3137255013, alpha: 1))

    static func wordleColor(letter: WordleModel.WordleLetter, shadow: Bool, blind: Bool)->Color {
        var wordleColor: Color = .white
        if letter.rightPlace {
            if blind {
                wordleColor = shadow ? rightPlaceShadowBlind : rightPlaceBlind
            }
            else {
                wordleColor = shadow ? rightPlaceShadow : rightPlace
            }
        }
        else if letter.rightLetter {
            if blind {
                wordleColor = shadow ? rightLetterShadowBlind : rightLetterBlind
            }
            else  {
                wordleColor = shadow ? rightLetterShadow : rightLetter
            }
        }
        else if letter.wrongLetter {
            if blind {
                wordleColor = shadow ? wrongShadowBlind : wrongBlind
            }
            else {
                wordleColor = shadow ? wrongShadow : wrong
            }
        }
        return wordleColor
    }
}


class WordleViewModel: ObservableObject {
    
    @Published private var model: WordleModel
    @Published var showStatistics = false
    @Published var showInfo = false
    @Published var showSettings = false
    @Published var showNotInList = false
    @Published var deviceGeometry = DeviceGeometry()
    @Published var showLeaderBoard = false
    @Published var scoreToAdd = 0
    @Published var oldScore = 0
    
    @AppStorage("totalGames") var numberOfGames: Int = 0
    @AppStorage("firstTry") var numberOfFirstTrys: Int = 0
    @AppStorage("secondTry") var numberOfSecondTrys: Int = 0
    @AppStorage("thirdTry") var numberOfThirdTrys: Int = 0
    @AppStorage("fourthTry") var numberOFourthTrys: Int = 0
    @AppStorage("fifthTry") var numberOfFifthTrys: Int = 0
    @AppStorage("sixthTry") var numberOfSixthTrys: Int = 0
    @AppStorage("series") var series: Int = 0
    @AppStorage("bestSeries") var bestSeries: Int = 0
    @AppStorage("lastgameWasWon") var lastGameWasWon: Bool = false
    @AppStorage("blindMode") var blindMode: Bool = false
    @AppStorage("score") var score: Int = 0

    struct Constants {
        static let ShowNotInListTime = 1.5
        static let checkDuration = 0.5
        static let selectDuration = 0.1
        static let lostAnimationDuration = 1.0
    }
    
    let numberOfLetters = 5
    let numberOfRows = 6
 
    init() {
        model = WordleModel(numberOfLetters: numberOfLetters, NumberOfRows: numberOfRows)
        showNotInList = false
        oldScore = score
    }
    
    var letters: [WordleModel.WordleLetter] {
        return model.letterField
    }
    
    var word: String {
        return model.word
    }
        
    var won: Bool {
        return model.won
    }
    
    var lost: Bool {
        return model.lost
    }
    
    var keys: [WordleModel.WordleLetter] {
        return model.keyboardField
    }
    
    var enableNewGame: Bool {
        return model.actualRow > 0 || model.won
    }
    
    // MARK - animation timing
    func rowCheckDuration()->TimeInterval {
        return Constants.checkDuration * Double(numberOfLetters)
    }
    func lostAnimationDuration()->TimeInterval {
        return Constants.checkDuration * Double(numberOfLetters) + Constants.lostAnimationDuration * 2
    }
    func checkDelay(id: Int)->TimeInterval {
        return Constants.checkDuration * Double(id % numberOfLetters)
    }
    func rowSelectDuration()->TimeInterval {
        return Constants.selectDuration * Double(numberOfLetters)
    }
    
    // MARK - user intents
    func letterTapped(_ letter: WordleModel.WordleLetter) {
        if lost {
            newGame()
            return
        }
        model.setSelectedLetter(id: letter.id)
    }
    
    func chartButtonTapped() {
        showStatistics.toggle()
    }
    
    func settingsButtonTapped() {
        showInfo.toggle()
    }
    
    func keyPressed(_ letter: WordleModel.WordleLetter) {
        model.setKeyboardLetter(letter)
    }
    
    func newGame() {
        updateStatistic(newGame: true)
        var transaction = Transaction(animation: .easeInOut(duration: 0.5))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            model.newGame(numberOfLetters: numberOfLetters, NumberOfRows: numberOfRows)
        }
        scoreToAdd = score - oldScore
        oldScore = score
    }
    
    func statisticsDismissed() {
        if won {
            newGame()
        }
    }
    
    func check() {
        scoreToAdd = 0
        oldScore = score
        let result = model.checkRow()
        if model.won {
            updateStatistic(newGame: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + rowCheckDuration()) { [weak self] in
                self?.showStatistics.toggle()
            }
        }
        else if model.lost {
            updateStatistic(newGame: false)
        }
        if result == .wordNotInList {
            showNotInList = true
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.ShowNotInListTime) {[weak self] in
                self?.showNotInList = false
            }
        }
        if model.lost {
            DispatchQueue.main.asyncAfter(deadline: .now() + rowCheckDuration() + Constants.lostAnimationDuration) {[weak self] in
                self?.model.setLetterFieldLostFlag(false)
            }
        }
    }
    
    func resetStatistic() {
        numberOfGames = 0
        numberOfFirstTrys = 0
        numberOfSecondTrys = 0
        numberOfThirdTrys = 0
        numberOFourthTrys = 0
        numberOfFifthTrys = 0
        numberOfSixthTrys = 0
        series = 0
        bestSeries = 0
        lastGameWasWon = false
    }
    
    private func updateStatistic(newGame: Bool) {
        if newGame {
            if won || lost {return}
        }
        oldScore = score
        numberOfGames += 1
        if won {
            switch model.actualRow {
            case 0:
                numberOfFirstTrys += 1
                score += 6
            case 1:
                numberOfSecondTrys += 1
                score += 5
            case 2:
                numberOfThirdTrys += 1
                score += 4
            case 3:
                numberOFourthTrys += 1
                score += 3
            case 4:
                numberOfFifthTrys += 1
                score += 2
            case 5:
                numberOfSixthTrys += 1
                score += 1
            default:
                print("error in statistic")
            }
            if lastGameWasWon {
                series += series == 0 ? 2 : 1
                if series > bestSeries {
                    bestSeries = series
                }
            }
            lastGameWasWon = true
        }
        else {
            lastGameWasWon = false
            series = 0
            score -= 6
        }
        
        Task {
            await GameCenterManager.shared.setHighSore(score: score)
        }
    }
        
    func willTerminate() {
        model.willTerminate()
    }
}
