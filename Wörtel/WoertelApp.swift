//
//  WoertelApp.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI

@main
struct WoertelApp: App {
    @StateObject var game = WoertelViewModel()
    var body: some Scene {
        let _ = AppState(vm: game)
        WindowGroup {
            WoertelView(vm: game)
        }
    }
}

class AppState {
    @Published var isActive = true
    private let vm: WoertelViewModel
    private var observers = [NSObjectProtocol]()
    
    init(vm: WoertelViewModel) {
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
