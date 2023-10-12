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

    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                Toggle(isOn: $vm.blindMode, label: {
                    VStack(alignment: .leading) {
                        Text("Modus für Farbenblinde")
                            .font(.headline)
                        Text("höherer Kontrast")
                            .font(.subheadline)
                    }
                })
                .padding(.horizontal)
                Divider()
                Button("Satistik zurücksetzen") {
                    vm.resetStatistic()
                }
                Divider()
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
    SettingsView(vm: WordleViewModel())
}
