//
//  InformationsView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 24.09.23.
//

import SwiftUI

struct InformationsView: View {
    @Binding var blindMode: Bool
    @Binding var showInfo: Bool
    @State var selection = 0
    @State private var minHeight: CGFloat = 1
    
    var deviceGeometry = DeviceGeometry()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                header
                TabView(selection: $selection,
                        content:  {
                    InfoViewPage1(blindMode: $blindMode, selection: $selection, deviceGeometry: deviceGeometry).tag(0)
                    InfoViewPage2(blindMode: $blindMode, selection: $selection, deviceGeometry: deviceGeometry).tag(1)
                    InfoViewPage3(blindMode: $blindMode, selection: $selection, deviceGeometry: deviceGeometry).tag(2)
                })
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(width: deviceGeometry.infoViewWidth,
                       height: deviceGeometry.infoViewHeight,
                       alignment: .center)
            }
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
    }
     
    var header: some View {
        ZStack {
            Text("Spielanleitung")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: deviceGeometry.infoViewHeaderWidth,
                       height: deviceGeometry.infoViewHeaderHeight)
                .background{
                    LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))], startPoint: .top, endPoint: .bottom)
                }
                .clipShape(.capsule)
                .offset(y: -deviceGeometry.infoViewHeight / 2)
            Button(action: {
                showInfo.toggle()
            }, label: {
                CloseButtonView()
            })
            .offset(deviceGeometry.infoViewCloseButtonOffset)
        }
        .zIndex(2)
    }
}

struct LetterRows {
    enum RowType {
        case allRightPlace
        case allWrong
        case rightPlaceAndLetter
        case oneRightPlace
        case oneRightLetter
    }
    
    func letterRow(type: RowType)->[WoertelModel.WordleLetter] {
        var row = [WoertelModel.WordleLetter]()
        switch type {
        case .allRightPlace:
            row.append(WoertelModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "D", id: 1, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "L", id: 2, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "E", id: 3, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "R", id: 4, rightPlace: true, rightLetter: false, wrongLetter: false))
        case .allWrong:
            row.append(WoertelModel.WordleLetter(letter: "U", id: 0, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "N", id: 1, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "I", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "O", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "N", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))
        case .rightPlaceAndLetter:
            row.append(WoertelModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "R", id: 1, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "G", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "O", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "N", id: 4, rightPlace: false, rightLetter: false , wrongLetter: true))
        case .oneRightPlace:
            row.append(WoertelModel.WordleLetter(letter: "A", id: 0, rightPlace: true, rightLetter: false, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "N", id: 1, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "T", id: 2, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "I", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "K", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))
        case .oneRightLetter:
            row.append(WoertelModel.WordleLetter(letter: "K", id: 0, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "L", id: 1, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "A", id: 2, rightPlace: false, rightLetter: true, wrongLetter: false))
            row.append(WoertelModel.WordleLetter(letter: "N", id: 3, rightPlace: false, rightLetter: false, wrongLetter: true))
            row.append(WoertelModel.WordleLetter(letter: "G", id: 4, rightPlace: false, rightLetter: false, wrongLetter: true))
            
        }
        return row
    }
}


#Preview {
    InformationsView(blindMode: .constant(false), showInfo: .constant(true))
}
