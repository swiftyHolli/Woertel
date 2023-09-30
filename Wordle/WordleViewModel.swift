//
//  WordleViewModel.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI

struct WordleColors {
    static let rightPlace = Color(uiColor: #colorLiteral(red: 0.244219631, green: 0.7725548148, blue: 0.7890618443, alpha: 1))
    static let rightPlaceShadow = Color(uiColor: #colorLiteral(red: 0.1710186601, green: 0.5491942167, blue: 0.5561188459, alpha: 1))
    static let rightLetter = Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1))
    static let rightLetterShadow = Color(uiColor: #colorLiteral(red: 0.8136706352, green: 0.4051097035, blue: 0.01514841989, alpha: 1))
    static let wrong = Color(uiColor: #colorLiteral(red: 0.5058823824, green: 0.505882442, blue: 0.5058823824, alpha: 1))
    static let wrongShadow = Color(uiColor: #colorLiteral(red: 0.3137255013, green: 0.3137255013, blue: 0.3137255013, alpha: 1))
    
    static func wordleColor(letter: WordleModel.WordleLetter, shadow: Bool)->Color {
        var wordleColor: Color = .white
        if letter.rightPlace {
            wordleColor = shadow ? WordleColors.rightPlaceShadow : WordleColors.rightPlace
        }
        else if letter.rightLetter {
            wordleColor = shadow ? WordleColors.rightLetterShadow : WordleColors.rightLetter
        }
        else if letter.wrongLetter {
            wordleColor = shadow ? WordleColors.wrongShadow : WordleColors.wrong
        }
        return wordleColor
    }
}


class WordleViewModel: ObservableObject {
    
    struct Constants {
        static let ShowNotInListTime = 1.5
    }

    let numberOfLetters = 5
    let numberOfRows = 6
    
    @Published private var model: WordleModel
    @Published var showStatistics = false
    @Published var showSettings = false
    @Published var showNotInList = false

    @AppStorage("totalGames") var numberOfGames: Int = 0
    @AppStorage("firstTry") var numberOfFirstTrys: Int = 0
    @AppStorage("secondTry") var numberOfSecondTrys: Int = 0
    @AppStorage("thirdTry") var numberOfThirdTrys: Int = 0
    @AppStorage("fourthTry") var numberOFourthTrys: Int = 0
    @AppStorage("fifthTry") var numberOfFifthTrys: Int = 0
    @AppStorage("sixthTry") var numberOfSixthTrys: Int = 0
    
    init() {
        model = WordleModel(numberOfLetters: numberOfLetters, NumberOfRows: numberOfRows)
        showNotInList = false
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
    
    var keys: [WordleModel.WordleLetter] {
        return model.keyboardField
    }
        
    func letterTapped(_ letter: WordleModel.WordleLetter) {
        model.setSelectedLetter(id: letter.id)
    }
    
    func chartButtonTapped() {
        showStatistics.toggle()
    }
    
    func settingsButtonTapped() {
        showSettings.toggle()
    }
    
    func keyPressed(_ letter: WordleModel.WordleLetter) {
        model.setKeyboardLetter(letter)
    }
    
    func newGame() {
        updateStatistic(newGame: true)
        var transaction = Transaction(animation: .easeInOut(duration: 0.5))
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            model.newGame(numberOfLetters: 5, NumberOfRows: 6)
        }
    }
    
    func check() {
        let result = model.checkRow()
        updateStatistic(newGame: false)
        if model.won {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 * Double(numberOfLetters)) { [weak self] in
                self?.showStatistics.toggle()
            }
        }
        if result == .wordNotInList {
            showNotInList = true
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.ShowNotInListTime) {[weak self] in
                self?.showNotInList = false
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
    }
    
    private func updateStatistic(newGame: Bool) {
        if newGame {
            if won {return}
        }
        numberOfGames += 1
        if won {
            print(model.actualRow)
            switch model.actualRow {
            case 0:
                numberOfFirstTrys += 1
            case 1:
                numberOfSecondTrys += 1
            case 2:
                numberOfThirdTrys += 1
            case 3:
                numberOFourthTrys += 1
            case 4:
                numberOfFifthTrys += 1
            case 5:
                numberOfSixthTrys += 1
            default:
                print("error in statistic")
            }
        }
    }
}
