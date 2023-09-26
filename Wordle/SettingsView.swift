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
        VStack {
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
