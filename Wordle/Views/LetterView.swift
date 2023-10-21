//
//  LetterView.swift
//  Wordle
//
//  Created by Holger Becker on 26.09.23.
//

import SwiftUI

struct LetterView : View {
    @ObservedObject var vm: WordleViewModel
    typealias Constants  = WordleViewModel.Constants
        
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
                        .fill(WordleColors.wordleColor(letter: letter, shadow: false, blind: vm.blindMode))
                        .shadow(color: WordleColors.wordleColor(letter: letter, shadow: true, blind: vm.blindMode),
                                radius: 0, x: 3, y: 3)
                    letterText
                }
                .opacity(letter.isChecked ? 1 : 0)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .disabled(letter.isDisabled)
        .rotationEffect(Angle(degrees: letter.rightPlace ? 0 : 360))
        .rotationEffect(Angle(degrees: letter.rightLetter ? 360 : 0))
        .animation(.easeInOut(duration: Constants.checkDuration)
            .delay(vm.checkDelay(id: letter.id)), value: letter.isChecked)
        .animation(.easeInOut(duration: Constants.checkDuration)
            .delay(vm.rowCheckDuration() + vm.rowSelectDuration()), value: letter.isDisabled)
        .modifier(ShakeEffect(shakes: letter.shake ? 1 : 0))
        .animation(.easeInOut(duration: Constants.checkDuration), value: letter.shake)
        .animation(.easeInOut(duration: Constants.selectDuration)
            .delay(Constants.ShowNotInListTime), value: letter.isSelected && vm.showNotInList)
        .animation(.easeInOut(duration: Constants.selectDuration), value: letter.isSelected)
        .offset(
            x: letter.isPartOfLostGame ? CGFloat.random(in: -500...500) : 0,
            y: letter.isPartOfLostGame ? CGFloat.random(in: -500...500) : 0
        )
        .opacity(letter.isPartOfLostGame ? 0 : 1)
        .animation(
            .spring(duration: Constants.lostAnimationDuration, bounce: 0.5)
            .delay(vm.rowCheckDuration()), value: letter.isPartOfLostGame)
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



struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = WordleViewModel()
        let framesize:CGFloat = 200
        ZStack {
            VStack(spacing: framesize / 30) {
                HStack(spacing: framesize/30) {
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "T", id: 1, isSelected: false, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "A", id: 2, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: true, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "D", id: 3, isSelected: true, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: false, wrongLetter: true, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                }
                HStack(spacing: framesize / 30) {
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "T", id: 1, isSelected: false, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "I", id: 6, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: false, wrongLetter: true, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "R", id: 7, isSelected: false, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                }
                HStack(spacing: framesize / 30) {
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "T", id: 1, isSelected: false, isDisabled: false, isChecked: false, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "E", id: 6, isSelected: false, isDisabled: false, isChecked: false, rightPlace: false, rightLetter: true, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                    LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "R", id: 7, isSelected: true, isDisabled: false, isChecked: false, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                        .frame(width: framesize, height: framesize, alignment: .center)
                }
            }
            RoundedRectangle(cornerRadius: 750 * 0.2 * 0)
                .stroke(lineWidth: 1)
                .foregroundColor(.white)
                .frame(width: 751, height: 751)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RadialGradient(colors: [Color.blue, Color.black], center: .center, startRadius: 0, endRadius: 500)
        }
    }
}
