//
//  KeyboardView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 23.09.23.
//

import SwiftUI

struct KeyboardLetter: View {
    @ObservedObject var vm: WordleViewModel
    var letter: WordleModel.WordleLetter
    let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / 12
    var body: some View {
        Button {
            vm.keyPressed(letter)
            vm.showNotInList = false
        } label: {
            Text(letter.letter)
                .font(.system(size: 800))
                .padding(width * 0.1)
                .fontWeight(.bold)
                .foregroundColor(letter.rightLetter || letter.rightPlace || letter.wrongLetter ? .white : .white)
                .minimumScaleFactor(0.01)
                .frame(width: width, height: width ,alignment: .center)
                .background(letterBackground)
                .padding(width * 0.1)
                .animation(.easeIn(duration: 1).delay(Double(vm.numberOfLetters) * 0.5), value: letter.rightLetter || letter.rightPlace || letter.wrongLetter)
        }
    }
    
    var letterBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: width * 0.2)
                .fill( LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))], startPoint: .top, endPoint:.bottom))
                .shadow(color: .black, radius: width * 0.1, x: 0, y: width * 0.1)
            RoundedRectangle(cornerRadius: width * 0.2)
                .fill(WordleColors.wordleColor(letter: letter, shadow: false))
                .opacity(letter.rightLetter || letter.rightPlace || letter.wrongLetter ? 1 : 0)
        }
    }
}


struct KeyboardView: View {
    @ObservedObject var vm: WordleViewModel
    @State var showingAlert = false
    
    let backgroundColor = Color(uiColor: #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
    
    var body: some View {
        VStack(spacing: 5) {
            Rectangle()
                .fill(
                    LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))], startPoint: .leading, endPoint:.trailing )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 5)
            HStack {
                Button {
                    vm.chartButtonTapped()
                } label: {
                    Text("\(Image(systemName: "chart.bar.xaxis"))   ")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                Button {
                    vm.settingsButtonTapped()
                } label: {
                    Text("\(Image(systemName: "info"))   ")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                .padding()
                Button {
                    if !vm.won && !vm.lost{
                        showingAlert = true
                    }
                    else {
                        vm.newGame()
                    }
                } label: {
                    Text("\(Image(systemName: "checkmark.circle.badge.xmark"))    ")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(vm.enableNewGame ? .white : .gray)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                .alert("Dieses Spiel abbrechen und ein Neues starten?", isPresented: $showingAlert) {
                    Button("Nein", role: .cancel) { }
                    Button("Ja", role: .destructive) {vm.newGame()}
                }
                .disabled(!vm.enableNewGame)
                Spacer()
                Button {
                    vm.check()
                } label: {
                    Text("\(Image(systemName: "checkmark"))")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(vm.won || vm.lost ? .gray : .white)
                        .frame(maxWidth: 300)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                .disabled(vm.won || vm.lost)
            }
            .padding(.horizontal)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<10) { index in
                        KeyboardLetter(vm: vm, letter: vm.keys[index])
                    }
                }
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(10..<19) { index in
                        KeyboardLetter(vm: vm, letter: vm.keys[index])
                    }
                    Spacer()
                }
                HStack(spacing: 0) {
                    ForEach(19..<27) { index in
                        KeyboardLetter(vm: vm, letter: vm.keys[index])
                    }
                }
            }
        }
        .background {
            //backgroundColor
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .top, endPoint:.bottom )

                .ignoresSafeArea()
                .opacity(0)
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hallo")
            Spacer()
            KeyboardView(vm: WordleViewModel())
        }
    }
}
