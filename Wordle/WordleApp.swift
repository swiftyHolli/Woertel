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
        let _ = AppState(vm: game)
        WindowGroup {
            WordleView(vm: game)
        }
    }
}

class AppState {
    @Published var isActive = true
    private let vm: WordleViewModel
    private var observers = [NSObjectProtocol]()
    
    init(vm: WordleViewModel) {
        self.vm = vm
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = true
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = false
                print("inactiv")
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
                print("will terminate")
                vm.willTerminate()
            }
        )
    }
    
    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
