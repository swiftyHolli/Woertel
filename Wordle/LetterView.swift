//
//  LetterView.swift
//  Wordle
//
//  Created by Holger Becker on 16.09.23.
//

import SwiftUI

struct LetterView: View {
    var letter: WordleModel.Letter
    var rowIndex: Int
    var index: Int
        
    let greenColor: UIColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
    let greenShadowColor: UIColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.508950745)
    let orangeColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    let orangeShadowColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.4962748344)
    
    var tryNumber: Int
    var fieldNumber: Int
    
    @Binding var animateField: Int
    
    var body: some View {
        
        Text(letter.character)
            .foregroundColor(letter.rightLetter || letter.rightPlace || letter.wrong ? .white : .black)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .aspectRatio(1, contentMode: .fill)
            .background {
                if letter.rightPlace {
                    Color(uiColor: greenColor)
                        .shadow(color: .black, radius: 1, x: 5, y: 3)
                }
                else if letter.rightLetter {
                    Color(uiColor: orangeColor)
                        .shadow(color: Color(uiColor: orangeShadowColor), radius: 1, x: 5, y: 5)
                }
                else if letter.wrong {
                    Color.gray
                        .shadow(color: .gray, radius: 1, x: 3, y: 3)
                }
                else if letter.character == " "{
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
                            .fill(Color.white)
                            .shadow(color: .black, radius: 3, x: 3, y: 3)
                        
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .modifier(ShakeEffect(shakes: animateField == rowIndex ? 2 : 0))
            .rotationEffect(letter.rightPlace || letter.rightLetter ? .degrees(0) : .degrees(360))
//            
//            .animation(.easeInOut(duration: 1), value: letter.rightPlace || letter.rightLetter)
//            .animation(.easeInOut(duration: 1), value: letter.wrong)
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
        LetterView(letter: WordleModel.Letter("A"), rowIndex: 0, index: 0, tryNumber: 0, fieldNumber: 0, animateField: .constant(-1))
    }
}
