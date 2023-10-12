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
        static let checkDuration = 0.5
        static let selectDuration = 0.1
        static let lostAnimationDuration = 1.0
    }
    
    struct DeviceGeometry {
        var isIpad = false
        var deviceWidth: CGFloat = 0
        var deviceHeight: CGFloat = 0
        
        init() {
            setDeviceDimensions()
        }
        
        var infoViewWidth: CGFloat {
            return deviceWidth * (isIpad ? 0.8 : 1.0)
        }
        var infoViewHeight: CGFloat {
            return deviceHeight * (isIpad ? 0.5 : 0.7)
        }
        var infoPageWidth: CGFloat {
            return deviceWidth * (isIpad ? 0.8 : 1.0) - 10
        }
        var infoPageLettersWidth: CGFloat {
            return deviceWidth * (isIpad ? 0.5 : 0.8)
        }
        var dotsOffset: CGFloat {
            return -(deviceHeight - infoViewHeight - 100)
        }
        var infoViewHeaderWidth: CGFloat {
            return infoViewWidth - infoPageCornerRadius * 2
        }
        var infoPageCornerRadius: CGFloat {
            return 25
        }
        var infoViewHeaderHeight: CGFloat {
            return isIpad ? 100 : 80
        }
        var infoViewCloseButtonOffset: CGSize {
            let size = CGSize(width: (infoViewWidth - 120) / 2,
                              height: -infoViewHeight / 2 - 40)
            return size
        }
        

        mutating func setDeviceDimensions() {
            deviceWidth = UIScreen.main.bounds.size.width
            deviceHeight = UIScreen.main.bounds.size.height
            isIpad = UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
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
    
    func willTerminate() {
        model.willTerminate()
    }
    
    
    let numberOfLetters = 5
    let numberOfRows = 6
    
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
    
    func letterTapped(_ letter: WordleModel.WordleLetter) {
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
            if won {return}
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
            await GameCenterViewModel.shared.setHighSore(score: score)
        }
    }
        
    enum RowType {
        case allRightPlace
        case allWrong
        case rightPlaceAndLetter
        case oneRightPlace
        case oneRightLetter
    }
    
    func letterRow(type: RowType)->[WordleModel.WordleLetter] {
        var row = [WordleModel.WordleLetter]()
        switch type {
        case .allRightPlace:
            row.append(WordleModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "D", id: 1, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "L", id: 2, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "E", id: 3, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "R", id: 4, rightPlace: true, rightLetter: false, wrongLetter: false))
        case .allWrong:
            row.append(WordleModel.WordleLetter(letter: "U", id: 0, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "N", id: 1, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "I", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "O", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "N", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))
        case .rightPlaceAndLetter:
            row.append(WordleModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "R", id: 1, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "G", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "O", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "N", id: 4, rightPlace: false, rightLetter: false , wrongLetter: true))
        case .oneRightPlace:
            row.append(WordleModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "N", id: 1, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "T", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "I", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "K", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))
        case .oneRightLetter:
            row.append(WordleModel.WordleLetter(letter: "K", id: 0, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "L", id: 1, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "A", id: 2, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WordleModel.WordleLetter(letter: "N", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WordleModel.WordleLetter(letter: "G", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))

        }
        return row
    }
}
