//
//  SettingsView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 24.09.23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: WordleViewModel
    var body: some View {
        VStack(spacing: 100) {
            Button("Reset Statistic") {
                vm.resetStatistic()
            }
            Button("Dismiss") {
                vm.showSettings = false
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vm: WordleViewModel())
    }
}
