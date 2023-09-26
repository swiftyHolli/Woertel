//
//  WordleModel.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import Foundation

struct WordleModel {
    
    private(set) var  letterField = [WordleLetter]()
    private(set) var  keyboardField = [WordleLetter]()
    private var numberOfLetters: Int = 5
    private var numberOfRows: Int = 6
    private var selectedIndex = 0
    
    var words = [String]()
    var word = ""
    
    var actualRow = 0
    var actualColumn = 0
        
    let keyboardLetters = ["Q","W","E","R","T","Z","U","I","O","P",
                           "A","S","D","F","G","H","J","K","L",
                           "Y","X","C","V","B","N","M", "⌫"]
    
    init(numberOfLetters: Int, NumberOfRows: Int) {
        newGame(numberOfLetters: numberOfLetters, NumberOfRows: NumberOfRows)
    }
    
    struct WordleLetter {
        var letter: String
        var id: Int
        
        var isSelected = false
        var isDisabled = true
        var isChecked = false
        
        var rightPlace = false
        var rightLetter = false
        var wrongLetter = false
        
        var shake = false
    }
    
    mutating func newGame(numberOfLetters: Int, NumberOfRows: Int) {
        self.numberOfLetters = numberOfLetters
        self.numberOfRows = NumberOfRows
        
        letterField = []
        for index in 0..<numberOfLetters * NumberOfRows{
            letterField.append(WordleLetter(letter: "", id: index))
        }
        keyboardField = []
        for index in 0..<keyboardLetters.count {
            keyboardField.append(WordleLetter(letter: keyboardLetters[index], id: index))
        }
        readData()
        word = words.randomElement() ?? ""
        word = word.uppercased()
        actualRow = 0
        actualColumn = 0
        setSelectedLetter(id: 0)
    }
    
    mutating func setSelectedLetter(id: Int) {
        for index in actualRowIndizies() {
            letterField[index].isDisabled = false
            if index % numberOfLetters == id % numberOfLetters {
                letterField[index].isSelected = true
                selectedIndex = index
            }
            else {
                letterField[index].isSelected = false
            }
        }
    }
    
    mutating func setKeyboardLetter(_ letter: WordleLetter) {
        let rowIndizies = actualRowIndizies()
        if letter.letter != "⌫" {
            letterField[selectedIndex].letter = letter.letter
            if selectedIndex < rowIndizies[rowIndizies.count - 1] {
                selectedIndex += 1
                setSelectedLetter(id: selectedIndex)
            }
        }
        else {
            letterField[selectedIndex].letter = ""
            if selectedIndex > rowIndizies[0] {
                selectedIndex -= 1
                setSelectedLetter(id: selectedIndex)
            }
        }
    }
        
    mutating func checkRow() {
        var letter: WordleLetter
        if !checkFilledWord() {return}
        for index in actualRowIndizies() {
            if String(word[index % numberOfLetters]) == letterField[index].letter {
                letterField[index].rightPlace = true
            }
            else {
                letterField[index].wrongLetter = true
            }
        }
        for index in actualRowIndizies() {
            letter = letterField[index]
            for index in actualRowIndizies() {
                letter.wrongLetter = true
                if (String(word[index % numberOfLetters]) == letter.letter) && !letter.rightPlace {
                    if word.filter({ String($0) == letter.letter}).count
                        > actualRowLetters().filter({ $0.letter == letter.letter && ($0.rightLetter || $0.rightPlace)}).count {
                        letter.rightLetter = true
                        letter.wrongLetter = false
                    }
                }
            }
            letter.isChecked = true
            letterField[index] = letter
            if let keyIndex = keyboardField.firstIndex(where: {$0.letter == letter.letter}) {
                let key = keyboardField[keyIndex]
                keyboardField[keyIndex].rightPlace = letter.rightPlace || key.rightPlace
                keyboardField[keyIndex].rightLetter = (letter.rightLetter || key.rightLetter) && !key.rightPlace
                keyboardField[keyIndex].wrongLetter = letter.wrongLetter && !key.rightPlace && !key.rightLetter
            }
        }
        if !won {
            nextRow()
        }
    }
    
    var won: Bool {
        var count = 0
        for letter in actualRowLetters() {
            if letter.rightPlace {
                count += 1
            }
        }
        if count == numberOfLetters {
            return true
        }
        return false
    }
    
    private mutating func checkFilledWord()->Bool {
        var success = true
        var wordToCheck = ""
        for letter in actualRowLetters() {
            wordToCheck = wordToCheck + letter.letter
            if letter.letter == "" {
                success = false
                break
            }
        }
        
        if !words.contains(where: {$0.uppercased() == wordToCheck}) {
            success = false
        }

        if !success {
            for index in actualRowIndizies() {
                letterField[index].shake.toggle()
            }
        }
        return success
    }
    
    mutating private func nextRow() {
        actualRow += actualRow < numberOfRows - 1 ? 1 : 0
        let indizies = actualRowIndizies()
        for index in indizies {
            letterField[index].isDisabled = false
        }
        letterField[indizies[0]].isSelected = true
        selectedIndex = indizies[0]
    }
    
    private func actualRowIndizies()->[Int] {
        var indexField = [Int]()
        for index in 0..<numberOfRows * numberOfLetters {
            if index / numberOfLetters == actualRow {
                indexField.append(index)
            }
        }
        return indexField
    }
    
    private func actualRowLetters()->[WordleLetter] {
        var letters = [WordleLetter]()
        for index in actualRowIndizies() {
            letters.append(letterField[index])
        }
        return letters
    }
    
    mutating private func readData() {
        if let path = Bundle.main.path(forResource: "german", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .ascii)
                words = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
