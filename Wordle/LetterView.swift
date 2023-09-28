//
//  LetterView.swift
//  Wordle
//
//  Created by Holger Becker on 26.09.23.
//

import SwiftUI

struct LetterView : View {
    @ObservedObject var vm: WordleViewModel
    let letter: WordleModel.WordleLetter
    var  body: some View {
        Button {
            vm.letterTapped(letter)
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
                        .fill(WordleColors.wordleColor(letter: letter, shadow: false))
                        .shadow(color: WordleColors.wordleColor(letter: letter, shadow: true), radius: 0, x: 3, y: 3)
                    letterText
                }
                .opacity(letter.isChecked ? 1 : 0)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .disabled(letter.isDisabled)
        .rotationEffect(Angle(degrees: letter.rightPlace ? 0 : 360))
        .rotationEffect(Angle(degrees: letter.rightLetter ? 360 : 0))
        .animation(.easeInOut(duration: 0.5).delay(0.5 * Double(letter.id % vm.numberOfLetters)), value: letter.isChecked)
        .animation(.easeInOut(duration: 0.5).delay(0.5 * Double(vm.numberOfLetters) + 0.1 * Double(letter.id % vm.numberOfLetters)), value: letter.isDisabled)
        .modifier(ShakeEffect(shakes: letter.shake ? 1 : 0))
        .animation(.easeInOut(duration: 0.5), value: letter.shake)
        .animation(.easeInOut(duration: 0.1).delay(WordleViewModel.Constants.ShowNotInListTime), value: letter.isSelected && vm.showNotInList)
        .animation(.easeInOut(duration: 0.1), value: letter.isSelected)
    }
    
    private var letterText: some View {
        Text(letter.letter)
            .font(.system(size: 800))
            .fontWeight(.bold)
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(letter.isChecked ? .white : .primary)
    }
}



struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = WordleViewModel()
        VStack(spacing: 20) {
            HStack {
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "", id: 1, isSelected: false, isDisabled: true, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "A", id: 2, isSelected: false, isDisabled: false, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "B", id: 3, isSelected: true, isDisabled: false, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
            }
            HStack {
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "C", id: 5, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: false, wrongLetter: true, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "D", id: 6, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: true, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "E", id: 7, isSelected: false, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
            }
        }
    }
}
