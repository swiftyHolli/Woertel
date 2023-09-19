//
//  LetterView.swift
//  Wordle
//
//  Created by Holger Becker on 16.09.23.
//

import SwiftUI



struct LetterView: View {
    @EnvironmentObject var vm: WordleModel
    
    var letter: WordleModel.Letter
    var rowIndex: Int
    var index: Int
    var width: CGFloat
        
    var tryNumber: Int
    var fieldNumber: Int
    
    @State var wordleColor = Color.white
    @State var wordleShadowColor = Color.black
    @State var animateField = false
    @State var letterColor = Color.black

    @Binding var animateColors: Bool
    @Binding var animateFieldNumber: Int

    var body: some View {
        ZStack {
            Text(letter.character)
                .foregroundColor(letterColor)
                .font(.system(size: width - 10, weight: .semibold, design: .default))
                .frame(width: width - 5, height: width - 5)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    if letter.character == " "{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: rowIndex == fieldNumber && index == tryNumber ? 3 : 1)
                            .foregroundColor(rowIndex == fieldNumber && index == tryNumber ? Color.black : Color.gray)
                        
                    }
                    else if letter.character != " "{
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: rowIndex == fieldNumber && index == tryNumber ? 6 : 1)
                                .foregroundColor(rowIndex == fieldNumber && index == tryNumber ? Color.black : Color.gray)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(wordleColor)
                                .shadow(color: wordleShadowColor, radius: 3, x: 3, y: 3)
                            
                        }
                    }
                }
                .onTapGesture {
                    if !vm.won && vm.actualRow == rowIndex {
                        vm.actualColumn = index
                    }
                }

        }
        .rotationEffect(letter.rightPlace || letter.rightLetter ? .degrees(0) : .degrees(360))
        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.5), value: letter.rightPlace || letter.rightLetter || letter.wrong)

        .modifier(ShakeEffect(shakes: animateField ? 1 : 0))
        .animation(.easeInOut(duration: 0.5), value: animateField)

        .onChange(of: animateColors) { _ in
            withAnimation(.easeInOut(duration: 0.5).delay(0.5 * Double(index))) {
                if letter.rightPlace {
                    wordleColor = WordleColors.rightPlace
                    wordleShadowColor = WordleColors.rightPlaceShadow
                    letterColor = .white
                }
                else if letter.rightLetter {
                    wordleColor = WordleColors.rightLetter
                    wordleShadowColor = WordleColors.rightLetter
                    letterColor = .white
                }
                else if letter.wrong {
                    wordleColor = WordleColors.wrong
                    wordleShadowColor = WordleColors.wrongShadow
                    letterColor = .white
                }
                animateColors = false
            }
        }
        .onChange(of: animateFieldNumber) { _ in
            if animateFieldNumber == rowIndex {
                animateField.toggle()
            }
        }
        .onChange(of: letter.character) { newValue in
            if letter.character == " " {
                wordleColor = .white
                wordleShadowColor = .black
                letterColor = .black
            }
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


struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView(letter: WordleModel.Letter("A"), rowIndex: 0, index: 0,width: 55, tryNumber: 0, fieldNumber: 0, animateColors: .constant(false), animateFieldNumber: .constant(-1))
        
            .padding()
    }
}
