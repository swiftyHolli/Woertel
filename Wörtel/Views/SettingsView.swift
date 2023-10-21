//
//  SettingsView.swift
//  Wordle
//
//  Created by Holger Becker on 07.10.23.
//

import SwiftUI
import GameKit

struct SettingsView: View {
    @ObservedObject var vm: WoertelViewModel
    @Binding var blindMode: Bool
    @State var showStatisticsDeleteDialog =  false

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
                        showStatisticsDeleteDialog = true
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
            .alert("Wollen Sie die Statistik wirklich löschen?", isPresented: $showStatisticsDeleteDialog) {
                Button("Ja", role: .destructive) {
                    vm.resetStatistic()
                    showStatisticsDeleteDialog = false
                }
                Button("Abbrechen", role: .cancel) {
                    showStatisticsDeleteDialog = false
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SettingsView(vm: WoertelViewModel(), blindMode: .constant(true), deviceGeometry: DeviceGeometry())
}
