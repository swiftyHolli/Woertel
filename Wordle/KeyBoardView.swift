//
//  KeyBoardView.swift
//  Wordle
//
//  Created by Holger Becker on 13.09.23.
//

import SwiftUI
struct KeyboardLetter: View {
    var letter: WordleModel.Letter
    
    var body: some View {
        Text(letter.character)
            .font(.title)
            .fontWeight(.semibold)
            .frame(width: 35, height: 35, alignment: .center)
            .aspectRatio(1, contentMode: .fill)
            .background {
                ZStack {
                    if letter.wrong {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.gray)
                    }
                    else if letter.rightLetter {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.yellow)
                    }
                    else if letter.rightPlace {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.green)
                    }

                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.black)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct KeyBoard: View {
    @Binding var character: String
    
    @EnvironmentObject var vm: WordleModel
    
    var firstRow = ["Q","W","E","R","T","Z","U","I","O","P"]
    var secondRow = ["A","S","D","F","G","H","J","K","L"]
    var thirdRow = ["Y","X","C","V","B","N","M"]

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                ForEach(firstRow, id: \.self) { myCharacter in
                    if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                        KeyboardLetter(letter: letter)
                            .onTapGesture {
                                character = letter.character
                            }
                    }
                }
            }
            HStack(spacing: 2) {
                ForEach(secondRow, id: \.self) { myCharacter in
                    if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                        KeyboardLetter(letter: letter)
                            .onTapGesture {
                                character = letter.character
                            }
                    }
                }
            }
            
            HStack(spacing: 2) {
                KeyboardLetter(letter: WordleModel.Letter("⏎"))
                ForEach(thirdRow, id: \.self) { myCharacter in
                    if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                        KeyboardLetter(letter: letter)
                            .onTapGesture {
                                character = letter.character
                            }
                    }
                }
                KeyboardLetter(letter: WordleModel.Letter("⌫"))
            }
            .offset(x: -17.5, y: 0)
        }
    }
}

struct KeyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            KeyBoard(character: .constant("A"))
                .environmentObject(WordleModel())
        }
    }
}
