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
                        .fill(WordleColors.wordleColor(letter: letter, shadow: false))
                        .shadow(color: WordleColors.wordleColor(letter: letter, shadow: true),
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
        var letter = WordleModel.WordleLetter(letter: "L", id: 5, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: false, wrongLetter: true, shake: false)
        VStack(spacing: 20) {
            HStack {
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "", id: 1, isSelected: false, isDisabled: true, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "A", id: 2, isSelected: false, isDisabled: false, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "D", id: 3, isSelected: true, isDisabled: false, isChecked: false, rightPlace: false, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
            }
            HStack {
                LetterView(vm: vm, letter: letter)
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "E", id: 6, isSelected: false, isDisabled: false, isChecked: true, rightPlace: false, rightLetter: true, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
                LetterView(vm: vm, letter: WordleModel.WordleLetter(letter: "R", id: 7, isSelected: false, isDisabled: false, isChecked: true, rightPlace: true, rightLetter: false, wrongLetter: false, shake: false))
                    .frame(width: 55, height: 55, alignment: .center)
            }
            Button("Verloren") {
                withAnimation {
                    letter.isPartOfLostGame.toggle()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
    }
}
