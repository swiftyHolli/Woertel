//
//  InfoPage2.swift
//  Wordle
//
//  Created by Holger Becker on 01.10.23.
//

import SwiftUI

struct InfoViewPage2:View {
    @ObservedObject var vm: WordleViewModel
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("Markierte Buchstaben können mehrmals vorkommen")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding(.top, 50.0)
            HStack {
                ForEach(vm.letterRow(type: .oneRightPlace)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .frame(maxWidth: vm.deviceGeometry.infoPageLettersWidth)
            .padding(.vertical)
            Text("Der Buchstabe \"A\" ist an der richtigen Stelle.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                ForEach(vm.letterRow(type: .oneRightLetter)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .frame(maxWidth: vm.deviceGeometry.infoPageLettersWidth)

            .padding(.vertical)
            Text("Die Buchstaben \"L\" und \"A\" stehen an der falschen Stelle.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .frame(width: vm.deviceGeometry.infoPageWidth,
               height: vm.deviceGeometry.infoViewHeight,
               alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))], center: .center, startRadius: 0, endRadius: 400))
        }
    }
}

#Preview {
    InfoViewPage2(vm: WordleViewModel(), selection: .constant(1))
}
