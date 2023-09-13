//
//  ContentView.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI

enum Field: Int, Hashable {
    case name, location, date, addAttendee
}


class WordleModel: ObservableObject {
    
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

struct ContentView: View {
    @StateObject var vm = WordleModel()
        
    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationView {
            VStack {
//                HStack {
//                    ForEach(vm.chosenWord, id: \.self) { chr in
//                        Text(chr)
//                            .font(.largeTitle)
//                            .fontWeight(.semibold)
//                            .frame(width: 40, height: 40, alignment: .center)
//                            .background {
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(lineWidth: 1)
//                            }
//                    }
//                }
                ForEach(Array(zip(vm.tries.indices, vm.tries)), id: \.0) { (rowIndex, letterRow) in
                    HStack {
                        ForEach(Array(zip(letterRow.indices, letterRow)), id: \.0) { (index, letter) in
                            LetterView(letter: letter, rowIndex: rowIndex, index: index, fieldNumber: vm.fieldNumber, tryNumber: vm.tryNumber, animateField: vm.animateField)
                                .onTapGesture {
                                    vm.tryNumber = index
                                }
                        }
                    }
                }
                Spacer()
                if vm.cheat {
                    Text("\(vm.chosenWord[0])\(vm.chosenWord[1])\(vm.chosenWord[2])\(vm.chosenWord[3])\(vm.chosenWord[4])")
                }
                KeyBoard(character: $vm.letterInput)
                    .onChange(of: vm.letterInput) { newValue in
                        if newValue != "" {
                            if newValue == "🔙" {
                                vm.backspace()
                                return
                            }
                            vm.tries[vm.fieldNumber][vm.tryNumber].character = newValue
                            vm.setNextInputField()
                        }
                        focusedField = .name
                    }
            }
            .padding()
            .navigationTitle("Wordle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation{
                            vm.checkRow()
                        }
                    } label: {
                        Image(systemName: "checkmark.bubble")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation{
                            vm.newGame()
                        }
                    } label: {
                        Image(systemName: "restart.circle")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation{
                            vm.cheat.toggle()
                        }
                    } label: {
                        Image(systemName: "eye")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            focusedField = .location
        }

    }
    struct LetterView: View {
        var letter: WordleModel.Letter
        var rowIndex: Int
        var index: Int
        
        var fieldNumber: Int
        var tryNumber: Int
        
        var animateField: Int

        var body: some View {
            Text(letter.character)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    if letter.rightPlace {
                        Color.green
                    }
                    else if letter.rightLetter {
                        Color.yellow
                    }
                    else if letter.wrong {
                        Color.gray
                    }
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: rowIndex == fieldNumber ? 3 : 1)
                        .foregroundColor(rowIndex == fieldNumber ? Color.black : Color.gray)
                        .background {
                            if rowIndex == fieldNumber && index == tryNumber {
                                Color.gray
                            }
                        }
                }
                .fixedSize(horizontal: false, vertical: true)
                .modifier(ShakeEffect(shakes: animateField == rowIndex ? 2 : 0))
        }
    }
    
    struct KeyboardLetter: View {
        var letter: WordleModel.Letter
        var rowIndex: Int
        var index: Int
        
        var fieldNumber: Int
        var tryNumber: Int
        
        var animateField: Int

        var body: some View {
            Text(letter.character)
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35, alignment: .center)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    if letter.rightPlace {
                        Color.green
                    }
                    else if letter.rightLetter {
                        Color.yellow
                    }
                    else if letter.wrong {
                        Color.gray
                    }
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: rowIndex == fieldNumber ? 3 : 1)
                        .foregroundColor(rowIndex == fieldNumber ? Color.black : Color.gray)
                        .background {
                            if rowIndex == fieldNumber && index == tryNumber {
                                Color.gray
                            }
                        }
                }
                .fixedSize(horizontal: false, vertical: true)
                .modifier(ShakeEffect(shakes: animateField == rowIndex ? 2 : 0))

        }
    }
    
    struct KeyBoard: View {
        @Binding var character: String
        var firstRow = ["Q","W","E","R","T","Z","U","I","O","P"]
        var secondRow = ["A","S","D","F","G","H","J","K","L"]
        var thirdRow = ["Y","X","C","V","B","N","M"]

        var body: some View {
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(firstRow, id: \.self) { letter in
                        let myLetter = WordleModel.Letter(letter, wrong: false)
                        KeyboardLetter(letter: myLetter, rowIndex: 0, index: 0, fieldNumber: 1, tryNumber: 1, animateField: 0)
                            .onTapGesture {
                                character = myLetter.character
                            }
                    }
                }
                HStack(spacing: 2) {
                    ForEach(secondRow, id: \.self) { letter in
                        let myLetter = WordleModel.Letter(letter, wrong: false)
                        KeyboardLetter(letter: myLetter, rowIndex: 0, index: 0, fieldNumber: 1, tryNumber: 1, animateField: 0)
                            .onTapGesture {
                                character = myLetter.character
                            }
                    }
                }
                HStack(spacing: 2) {
                    ForEach(thirdRow, id: \.self) { letter in
                        let myLetter = WordleModel.Letter(letter, wrong: false)
                        KeyboardLetter(letter: myLetter, rowIndex: 0, index: 0, fieldNumber: 1, tryNumber: 1, animateField: 0)
                            .onTapGesture {
                                character = myLetter.character
                            }
                    }
                    Text("🔙")
                        .frame(width: 60, height: 35)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 8.0)
                        .onTapGesture {
                            character = "🔙"
                        }
                        
                }
                .offset(x: 17.5, y: 0)
            }
        }
    }
    
    struct ShakeEffect: GeometryEffect {
        func effectValue(size: CGSize) -> ProjectionTransform {
            return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
        }
        
        init(shakes: Int) {
            position = CGFloat(shakes)
        }
        
        var position: CGFloat
        var animatableData: CGFloat {
            get { position }
            set { position = newValue }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
