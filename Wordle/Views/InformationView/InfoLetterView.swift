//
//  InfoLetterView.swift
//  Wordle
//
//  Created by Holger Becker on 13.10.23.
//

import SwiftUI

struct InfoLetterView : View {
    @Binding var blindMode: Bool
    typealias Constants  = WordleViewModel.Constants
    
    let letter: WordleModel.WordleLetter
    var  body: some View {
        Button {
        } label: {
            ZStack {
                ZStack {
                    letterText.padding(0)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: letter.isSelected ? 10 : 1)
                }
                .opacity(letter.isChecked ? 0 : 1)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(WordleColors.wordleColor(letter: letter, shadow: false, blind: blindMode))
                        .shadow(color: WordleColors.wordleColor(letter: letter, shadow: true, blind: blindMode),
                                radius: 0, x: 3, y: 3)
                    letterText
                }
                .opacity(letter.isChecked ? 1 : 0)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .disabled(letter.isDisabled)
    }
    
    private var letterText: some View {
        Text(letter.letter)
            .font(.system(size: 800))
            .fontWeight(.bold)
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(letter.isChecked ? .white : .white)
    }
}

#Preview {
    InfoLetterView(blindMode: .constant(false), letter: WordleModel.WordleLetter(letter: "A", id: 0, isSelected: true, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false)).frame(width: 100, height: 100, alignment: .center)
}
