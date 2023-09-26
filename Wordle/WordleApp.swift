//
//  WordleApp.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI

@main
struct WordleApp: App {
    @StateObject var game = WordleViewModel()
    var body: some Scene {
        WindowGroup {
            WordleView(vm: game)
        }
    }
}
