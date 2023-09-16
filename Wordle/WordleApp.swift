//
//  WordleApp.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI

@main
struct WordleApp: App {
    let vm = WordleModel()
    var body: some Scene {
        WindowGroup {
            WordleView()
                .environmentObject(vm)
        }
    }
}
