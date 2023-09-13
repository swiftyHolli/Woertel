//
//  ContentView.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI


struct ContentView: View {
    @StateObject var vm = WordleModel()
        
    @FocusState private var focusedField: WordleModel.Field?

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
