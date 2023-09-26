//
//  WordleView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI

struct WordleView: View {
    @ObservedObject var vm: WordleViewModel
    
    var body: some View {
        VStack {
            LazyVGrid(columns: gridItems(), spacing: 0) {
                ForEach(vm.letters.indices, id:\.self) {index in
                    LetterView(vm: vm, letter: vm.letters[index])
                        .padding(3)
                }
            }
            .aspectRatio(CGFloat(vm.numberOfLetters) / CGFloat(vm.numberOfRows), contentMode: .fit)
            .padding()
            Spacer()
            Text(vm.won ? "gewonnen" : vm.word)
            KeyboardView(vm: vm)
        }
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
        .sheet(isPresented: $vm.showStatistics) {
            StatisticsView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $vm.showSettings) {
            SettingsView(vm: vm)
        }
    }
    
    func gridItems()->[GridItem] {
        var items = [GridItem]()
        for _ in 0..<vm.numberOfLetters {
            items.append(GridItem(.adaptive(minimum: 800) ,spacing: 0))
        }
        return items
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView(vm: WordleViewModel())
    }
}
