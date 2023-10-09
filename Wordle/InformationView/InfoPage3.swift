//
//  InfoPage3.swift
//  Wordle
//
//  Created by Holger Becker on 01.10.23.
//

import SwiftUI

struct InfoViewPage3:View {
    @ObservedObject var vm: WordleViewModel
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("\"G\", \"O\" und \"N\" kommen im Wort nicht vor.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding(.top, 50)
            HStack {
                ForEach(vm.letterRow(type: .rightPlaceAndLetter)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .frame(maxWidth: vm.deviceGeometry.infoPageLettersWidth)
            .padding(.vertical)
            Spacer()
            Text("Du hast insgesamt sechs Versuche.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Text("Viel Spass beim Knobeln!")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Button("Statistik löschen") {
                vm.resetStatistic()
            }
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
    InfoViewPage3(vm: WordleViewModel(), selection: .constant(2))
}
