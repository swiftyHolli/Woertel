//
//  WordleModel.swift
//  Wordle
//
//  Created by Holger Becker on 13.09.23.
//

import SwiftUI

class WordleModel: ObservableObject {
    
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
    
    let maxTries = 6

    
    var myStrings = [String]()
    var originalWord = ""
    
    struct Letter {
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
        initKeyboard()
        newGame()
    }
    func initKeyboard() {
        for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            keyboard.append(Letter(String(letter)))
        }
    }
    
    func newGame() {
        var myWord = myStrings.randomElement()
        originalWord = myWord ?? ""
        cheat = false
        myWord = myWord?.uppercased()
        chosenWord.removeAll()
        tryNumber = 0
        fieldNumber = 0
        print(myWord ?? "Scheiße")
        if let myWord = myWord {
            for chr in myWord {
                chosenWord.append(String(chr))
            }
        }
        tries.removeAll()
        for _ in 0..<maxTries {
            tries.append([Letter(""), Letter(""), Letter(""), Letter(""), Letter("")])
        }
    }
        
    func checkRow() {
        var wordToCheck = ""
        for chr in tries[fieldNumber] {
            wordToCheck = wordToCheck + chr.character
        }
        
        tryNumber = 0

        if !myStrings.contains(where: {$0.uppercased() == wordToCheck}) {
            animateField = fieldNumber
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.animateField = -1
            }
            return
        }

        if tries[fieldNumber].contains(where: {$0.character == ""}) {
            animateField = fieldNumber
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.animateField = -1
            }
            return
        }
        
        var checkWord = chosenWord
        var letter: Letter

        for index in 0..<5 {
            letter = tries[fieldNumber][index]
            if letter.character == chosenWord[index] {
                letter.rightPlace = true
                checkWord[index] = ""
            }
            else {
                letter.rightPlace = false
                letter.rightLetter = false
                letter.wrong = true
            }
            if let keyIndex = keyboard.firstIndex(where: {$0.character == letter.character}) {
                keyboard[keyIndex].rightPlace = letter.rightPlace
                keyboard[keyIndex].rightLetter = letter.rightLetter
                keyboard[keyIndex].wrong = letter.wrong
            }
            tries[fieldNumber][index] = letter
        }
        for index in 0..<5 {
            letter = tries[fieldNumber][index]
            if checkWord.contains(where: {$0 == letter.character}) {
                letter.rightLetter = true
                letter.wrong = false
                checkWord[index] = ""
            }
            if let keyIndex = keyboard.firstIndex(where: {$0.character == letter.character}) {
                keyboard[keyIndex].rightPlace = letter.rightPlace
                keyboard[keyIndex].rightLetter = letter.rightLetter
                keyboard[keyIndex].wrong = letter.wrong
            }
            tries[fieldNumber][index] = letter
        }
        fieldNumber += 1
    }
    
    func setNextInputField() {
        letterInput = ""
        if !(tryNumber == 4) {
            tryNumber += 1
            print("\(tryNumber)")
        }
        
    }
    
    func backspace() {
        letterInput = ""
        tries[fieldNumber][tryNumber].character = ""
        tries[fieldNumber][tryNumber].rightPlace = false
        tries[fieldNumber][tryNumber].rightLetter = false
        tries[fieldNumber][tryNumber].wrong = false
        if !(tryNumber == 0) {
            tryNumber -= 1
            print("\(tryNumber)")
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

