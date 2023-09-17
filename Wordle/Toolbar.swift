//
//  Toolbar.swift
//  Wordle
//
//  Created by Holger Becker on 17.09.23.
//

import SwiftUI

//MARK: - ToolBar
struct Toolbar: ToolbarContent {
    var vm: WordleModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                vm.newGame()
            } label: {
                Image(systemName: "restart.circle")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
        ToolbarItem(placement: .navigation) {
            Text("Wordl")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation{
                    vm.cheat.toggle()
                }
            } label: {
                Image(systemName: "eye")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
    }
}
