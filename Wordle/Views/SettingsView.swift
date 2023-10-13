//
//  SettingsView.swift
//  Wordle
//
//  Created by Holger Becker on 07.10.23.
//

import SwiftUI
import GameKit

struct SettingsView: View {
    @ObservedObject var vm: WordleViewModel
    @Binding var blindMode: Bool

    var deviceGeometry = DeviceGeometry()
    
    var letterRows = LetterRows()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Modus für Farbenblinde", isOn: $vm.blindMode)
                }
                HStack {
                    ForEach(letterRows.letterRow(type: .rightPlaceAndLetter)) { letter in
                        InfoLetterView(blindMode: $blindMode, letter: letter)
                    }
                }
                .frame(maxWidth: deviceGeometry.infoPageLettersWidth)
                .padding(.vertical)

                Section {
                    Button("Statistik zurücksetzen", systemImage: "trash") {
                        vm.resetStatistic()
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar(content: {
                Button(action: {
                    vm.showSettings.toggle()
                }, label: {
                    CloseButtonView()
                })

            })
            Spacer()
        }
    }
}

#Preview {
    SettingsView(vm: WordleViewModel(), blindMode: .constant(true), deviceGeometry: DeviceGeometry())
}
