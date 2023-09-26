//
//  WordleView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI

struct WordleView: View {
    @ObservedObject var vm: WordleViewModel
    
    var body: some View {
        VStack {
            LazyVGrid(columns: gridItems(), spacing: 0) {
                ForEach(vm.letters.indices, id:\.self) {index in
                    LetterView(vm: vm, letter: vm.letters[index])
                        .padding(3)
                }
            }
            .aspectRatio(CGFloat(vm.numberOfLetters) / CGFloat(vm.numberOfRows), contentMode: .fit)
            .padding()
            Spacer()
            Text(vm.won ? "gewonnen" : vm.word)
            KeyboardView(vm: vm)
        }
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
        .sheet(isPresented: $vm.showStatistics) {
            StatisticsView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $vm.showSettings) {
            SettingsView(vm: vm)
        }
    }
    
    func gridItems()->[GridItem] {
        var items = [GridItem]()
        for _ in 0..<vm.numberOfLetters {
            items.append(GridItem(.adaptive(minimum: 800) ,spacing: 0))
        }
        return items
    }
}

struct LetterView : View {
    @ObservedObject var vm: WordleViewModel
    var letter: WordleModel.WordleLetter
    var  body: some View {
        Button {
            vm.letterTapped(letter)
        } label: {
            ZStack {
                ZStack {
                    letterText
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
        .aspectRatio(1, contentMode: .fill)
        .disabled(letter.isDisabled)
        .rotationEffect(Angle(degrees: letter.rightPlace ? 0 : 360))
        .rotationEffect(Angle(degrees: letter.rightLetter ? 360 : 0))
        .animation(.easeInOut(duration: 0.5).delay(0.5 * Double(letter.id % vm.numberOfLetters)), value: letter.isChecked)
        .animation(.easeInOut(duration: 0.5).delay(0.5 * Double(vm.numberOfLetters) + 0.1 * Double(letter.id % vm.numberOfLetters)), value: letter.isDisabled)
        .modifier(ShakeEffect(shakes: letter.shake ? 1 : 0))
        .animation(.easeInOut(duration: 0.5), value: letter.shake)
    }
    
    var letterText: some View {
        Text(letter.letter)
            .font(.system(size: 800))
            .fontWeight(.semibold)
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(letter.isChecked ? .white : .primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView(vm: WordleViewModel())
    }
}
