//
//  WordleModel.swift
//  Wordle
//
//  Created by Holger Becker on 13.09.23.
//

import SwiftUI

class WordleModel: ObservableObject {
    @AppStorage("totalGames") var numberOfGames: Int = 0
    @AppStorage("firstTry") var numberOfFirstTrys: Int = 0
    @AppStorage("secondTry") var numberOfSecondTrys: Int = 0
    @AppStorage("thirdTry") var numberOfThirdTrys: Int = 0
    @AppStorage("fourthTry") var numberOFourthTrys: Int = 0
    @AppStorage("fifthTry") var numberOfFifthTrys: Int = 0
    @AppStorage("sixthTry") var numberOfSixthTrys: Int = 0
    
    
    enum Field: Int, Hashable {
        case name, location, date, addAttendee
    }
    
    @Published var chosenWord = [String]()
    @Published var tries = [[Letter]]()
    @Published var keyboard = [Letter]()
    
    @Published var tryNumber = 0
    @Published var fieldNumber = 0
    
    @Published var animateField = -1
    @Published var letterInput = ""
    @Published var cheat = false
    @Published var won = false
    
    let maxTries = 6
    
    
    var myStrings = [String]()
    var originalWord = ""
    
    
    struct Letter: Identifiable, Hashable {
        var id = UUID()
        
        var rightPlace = false
        var rightLetter = false
        var wrong = false
        var character = ""
        
        init(_ letter: String) {
            self.character = letter
        }
        init(_ letter: String, wrong: Bool) {
            self.character = letter
            self.wrong = wrong
        }
    }
    
    
    init() {
        readData()
        newGame()
    }
    func initKeyboard() {
        keyboard.removeAll()
        for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            keyboard.append(Letter(String(letter)))
        }
    }
    
    func newGame() {
        numberOfGames += 1
        won = false
        var myWord = myStrings.randomElement()
        initKeyboard()
        
        originalWord = myWord ?? ""
        cheat = false
        myWord = myWord?.uppercased()
        chosenWord.removeAll()
        tryNumber = 0
        fieldNumber = 0
        if let myWord = myWord {
            for chr in myWord {
                chosenWord.append(String(chr))
            }
        }
        tries.removeAll()
        for _ in 0..<maxTries {
            tries.append([Letter(" "), Letter(" "), Letter(" "), Letter(" "), Letter(" ")])
        }
    }
    
    func checkRow() {
        withAnimation(.easeInOut(duration: 1)) {
            var wordToCheck = ""
            for chr in tries[fieldNumber] {
                wordToCheck = wordToCheck + chr.character
            }
            
            tryNumber = 0
            
            if !myStrings.contains(where: {$0.uppercased() == wordToCheck}) {
                withAnimation{
                    animateField = fieldNumber
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.animateField = -1
                }
                return
            }
            
            if tries[fieldNumber].contains(where: {$0.character == ""}) {
                withAnimation{
                    animateField = fieldNumber
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.animateField = -1
                }
                return
            }
            
            let checkWord = chosenWord
            var letter: Letter
            
            for index in 0..<5 {
                letter = tries[fieldNumber][index]
                if tries[fieldNumber][index].character == checkWord[index] {
                    tries[fieldNumber][index].rightPlace = true
                }
            }
            for index in 0..<5 {
                letter = tries[fieldNumber][index]
                //letter.rightPlace = false
                for i in 0..<5 {
                    letter.wrong = true
                    if (checkWord[i] == letter.character) && !letter.rightPlace {
                        if checkWord.filter({ $0 == letter.character}).count
                            > tries[fieldNumber].filter({ $0.character == letter.character && ($0.rightLetter || $0.rightPlace)}).count {
                            letter.rightLetter = true
                            letter.wrong = false
                        }
                    }
                }
                tries[fieldNumber][index] = letter
                if let keyIndex = keyboard.firstIndex(where: {$0.character == letter.character}) {
                    var key = keyboard[keyIndex]
                    key.rightPlace = letter.rightPlace || key.rightPlace
                    key.rightLetter = (letter.rightLetter || key.rightLetter) && !key.rightPlace
                    key.wrong = letter.wrong && !key.rightPlace && !key.rightLetter
                    keyboard[keyIndex] = key
                }
                tries[fieldNumber][index] = letter
            }
            print(tries[fieldNumber])
            var willWin = true
            for index in 0..<5 {
                if checkWord[index] != tries[fieldNumber][index].character {
                    willWin = false
                    break
                }
            }
            won = willWin
            
            fieldNumber += 1
            
            
            if won {
                switch fieldNumber  {
                case 1:
                    numberOfFirstTrys += 1
                case 2:
                    numberOfSecondTrys += 1
                case 3:
                    numberOfThirdTrys += 1
                case 4:
                    numberOFourthTrys += 1
                case 5:
                    numberOfFifthTrys += 1
                case 6:
                    numberOfSixthTrys += 1
                default:
                    print("Error")
                }
            }
        }
    }
    
    func setNextInputField() {
        letterInput = ""
        if !(tryNumber == 4) {
            tryNumber += 1
        }
        
    }
    
    func backspace() {
        letterInput = ""
        tries[fieldNumber][tryNumber].character = " "
        tries[fieldNumber][tryNumber].rightPlace = false
        tries[fieldNumber][tryNumber].rightLetter = false
        tries[fieldNumber][tryNumber].wrong = false
        if !(tryNumber == 0) {
            tryNumber -= 1
        }
        
    }
    
    func deleteWord() {
        myStrings.removeAll(where: {$0 == originalWord})
        writaData()
        newGame()
    }


    func readData() {
        if let path = Bundle.main.path(forResource: "german", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .ascii)
                myStrings = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
    }
    
    func writaData() {
        let output = myStrings.map{$0}.joined(separator: "\n")
        if let path = Bundle.main.path(forResource: "german", ofType: "txt") {
            do {
                try output.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print(error)
            }
        }
    }
}

