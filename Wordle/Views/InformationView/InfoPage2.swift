//
//  InfoPage2.swift
//  Wordle
//
//  Created by Holger Becker on 01.10.23.
//

import SwiftUI

struct InfoViewPage2:View {
    @Binding var blindMode: Bool
    @Binding var selection: Int
    var deviceGeometry: DeviceGeometry

    var letterRows = LetterRows()

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
                ForEach(letterRows.letterRow(type: .oneRightPlace)) { letter in
                    InfoLetterView(blindMode: $blindMode, letter: letter)
                }
            }
            .frame(maxWidth: deviceGeometry.infoPageLettersWidth)
            .padding(.vertical)
            Text("Der Buchstabe \"A\" ist an der richtigen Stelle.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                ForEach(letterRows.letterRow(type: .oneRightLetter)) { letter in
                    InfoLetterView(blindMode: $blindMode, letter: letter)
                }
            }
            .frame(maxWidth: deviceGeometry.infoPageLettersWidth)

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
        .frame(width: deviceGeometry.infoPageWidth,
               height: deviceGeometry.infoViewHeight,
               alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))], center: .center, startRadius: 0, endRadius: 400))
        }
    }
}

#Preview {
    InfoViewPage2(blindMode: .constant(false), selection: .constant(1), deviceGeometry: DeviceGeometry())
}
