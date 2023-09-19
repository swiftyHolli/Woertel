//
//  KeyBoardView.swift
//  Wordle
//
//  Created by Holger Becker on 13.09.23.
//

import SwiftUI
struct KeyboardLetter: View {
    var letter: WordleModel.Letter
    @EnvironmentObject var vm: WordleModel
    var body: some View {
        Button {
            if !vm.won {
                vm.letterInput = letter.character
            }
        } label: {
            Text(letter.character)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(letter.rightLetter || letter.rightPlace || letter.wrong ? .white : .black)
                .frame(width: UIScreen.main.bounds.width / 11, height: UIScreen.main.bounds.width / 11, alignment: .center)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    ZStack {
                        if letter.wrong && !letter.rightPlace && !letter.rightLetter {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(WordleColors.wrong)
                        }
                        if letter.rightLetter && !letter.rightPlace {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(WordleColors.rightLetter)
                        }
                        if letter.rightPlace {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(WordleColors.rightPlace)
                        }
                        
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.black)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
        }

    }
}

struct KeyBoard: View {
    @Binding var character: String
    @Binding var showingStatistics: Bool
    
    @EnvironmentObject var vm: WordleModel
    
    let backgroundColor = Color(uiColor: #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
    
    var firstRow = ["Q","W","E","R","T","Z","U","I","O","P"]
    var secondRow = ["A","S","D","F","G","H","J","K","L"]
    var thirdRow = ["Y","X","C","V","B","N","M"]
    
    var body: some View {
        VStack(spacing: 5) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 5)
            HStack {
                Button {
                    showingStatistics.toggle()
                    
                } label: {
                    Text("\(Image(systemName: "chart.bar.xaxis"))   ")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                Button {
                    if !vm.won {
                        character = "⏎"
                    }
                    
                } label: {
                    Text("Enter")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
                Button {
                    if !vm.won {
                        character = "⏎"
                    }
                    
                } label: {
                    Text("\(Image(systemName: "info"))    ")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 66)
                        .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint:.bottom ))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8.0)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 5)
                .padding(.vertical, 8.0)
            
            let keySpacing = 3.0

            VStack(spacing: 5.0) {
                HStack(spacing: keySpacing) {
                    ForEach(firstRow, id: \.self) { myCharacter in
                        if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                            KeyboardLetter(letter: letter)
                        }
                    }
                }
                HStack(spacing: keySpacing) {
                    ForEach(secondRow, id: \.self) { myCharacter in
                        if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                            KeyboardLetter(letter: letter)
                        }
                    }
                }
                
                HStack(spacing: keySpacing) {
                    ForEach(thirdRow, id: \.self) { myCharacter in
                        if let letter = vm.keyboard.first(where: {$0.character == myCharacter}) {
                            KeyboardLetter(letter: letter)
                        }
                    }
                    KeyboardLetter(letter: WordleModel.Letter("⌫"))
                }
                .offset(x: 0, y: 0)
            }
        }
        .background {
            backgroundColor
                .ignoresSafeArea()
        }
    }
}

struct KeyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            KeyBoard(character: .constant("A"), showingStatistics: .constant(false))
                .environmentObject(WordleModel())
        }
    }
}
