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
    
    @Published var tryNumber = 0
    @Published var fieldNumber = 0

    @Published var animateField = -1
    @Published var letterInput = ""
    @Published var cheat = false
    
    let maxTries = 6

    
    var myStrings = [String]()
    
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
        newGame()
    }
    
    func newGame() {
        var myWord = myStrings.randomElement()
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
        for index in 0..<5 {
            if tries[fieldNumber][index].character == chosenWord[index] {
                tries[fieldNumber][index].rightPlace = true
                checkWord[index] = ""
            }
            else {
                tries[fieldNumber][index].rightPlace = false
                tries[fieldNumber][index].rightLetter = false
                tries[fieldNumber][index].wrong = true
            }
        }
        for index in 0..<5 {
            if checkWord.contains(where: {$0 == tries[fieldNumber][index].character}) {
                tries[fieldNumber][index].rightLetter = true
                tries[fieldNumber][index].wrong = false
                checkWord[index] = ""
            }
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
}

