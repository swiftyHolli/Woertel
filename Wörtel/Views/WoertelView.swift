//
//  WoertelView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 21.09.23.
//

import SwiftUI
import GameKit

struct WoertelView: View {
    @ObservedObject var vm: WoertelViewModel
    @State var cheating = false
    @State var showLeaderboard = false

    var body: some View {
        VStack {
            HStack {
                GameCenterIcon(showLeaderboard: $showLeaderboard, scoreToAdd: $vm.scoreToAdd, score: vm.oldScore)
                Spacer()
                Button{
                    vm.showSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                }
                .font(.largeTitle)
                .fontWeight(.semibold)
            }
            .padding(.horizontal)
            ZStack {
                letterGrid
                notInListFlyingText(show: vm.showNotInList)
            }
            .onTapGesture {
                if vm.lost {
                    vm.newGame()
                }
            }
            Spacer()
            KeyboardView(vm: vm)
        }
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
        .sheet(isPresented: $vm.showStatistics, onDismiss: {
            vm.statisticsDismissed()
        }) {
            StatisticsView(vm: vm)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $vm.showInfo) {
            InformationsView(blindMode: $vm.blindMode, showInfo: $vm.showInfo)
        }
        .fullScreenCover(isPresented: $vm.showSettings) {
            SettingsView(vm: vm, blindMode: $vm.blindMode)
        }
        .fullScreenCover(isPresented: $showLeaderboard, onDismiss: {
            showLeaderboard = false
        }) {
            GameCenterView(format: GameCenterManager.shared.isGKActive ? .leaderboards : .default)
                .ignoresSafeArea()
        }
    }
    

    
    var letterGrid: some View {
        LazyVGrid(columns: gridItems(), spacing: 0) {
            ForEach(vm.letters.indices, id:\.self) {index in
                LetterView(vm: vm, letter: vm.letters[index])
                    .padding(3)
            }
        }
        .aspectRatio(CGFloat(vm.numberOfLetters) / CGFloat(vm.numberOfRows), contentMode: .fit)
        .padding()
        .overlay(alignment: .center) {
            SolutionView(vm: vm, text: vm.word, show: vm.lost)
        }
    }
    
    struct notInListFlyingText: View {
        let show: Bool
        let color = Color(uiColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
        @State private var offset: CGFloat = 0
        var body: some View {
            if show {
                Text("Wort nicht in der Liste!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                    .offset(x: 0, y: offset)
                    .opacity(offset != 0 ? 0 : 1)
                    .onAppear {
                        withAnimation(.easeIn(duration: WoertelViewModel.Constants.ShowNotInListTime)) {
                            offset = -200
                        }
                    }
                    .onDisappear {
                        offset = 0
                    }
            }
        }
    }
            
    private func gridItems()->[GridItem] {
        var items = [GridItem]()
        for _ in 0..<vm.numberOfLetters {
            items.append(GridItem(.adaptive(minimum: 800) ,spacing: 0))
        }
        return items
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WoertelView(vm: WoertelViewModel())
    }
}
