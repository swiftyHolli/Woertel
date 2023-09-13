//
//  KeyBoardView.swift
//  Wordle
//
//  Created by Holger Becker on 13.09.23.
//

import SwiftUI
struct KeyboardLetter: View {
    var letter: String
    var body: some View {
        Text(letter)
            .font(.title)
            .fontWeight(.semibold)
            .frame(width: 35, height: 35, alignment: .center)
            .aspectRatio(1, contentMode: .fill)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color.gray)
                    }
            .fixedSize(horizontal: false, vertical: true)
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
                    KeyboardLetter(letter: letter)
                        .onTapGesture {
                            character = letter
                        }
                }
            }
            HStack(spacing: 2) {
                ForEach(secondRow, id: \.self) { letter in
                    KeyboardLetter(letter: letter)
                        .onTapGesture {
                            character = letter
                        }
                }
            }
            HStack(spacing: 2) {
                ForEach(thirdRow, id: \.self) { letter in
                    KeyboardLetter(letter: letter)
                        .onTapGesture {
                            character = letter
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

struct KeyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            KeyBoard(character: .constant("A"))
        }
    }
}
