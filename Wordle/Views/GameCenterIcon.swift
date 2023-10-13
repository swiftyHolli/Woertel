//
//  GameCenterIcon.swift
//  Wordle
//
//  Created by Holger Becker on 12.10.23.
//

import SwiftUI
import GameKit

struct GameCenterIcon: View {
    @ObservedObject var vm = GameCenterManager.shared
    @Binding var showLeaderboard: Bool
    @Binding var scoreToAdd: Int
    var score: Int

    var body: some View {
        if vm.playerImage != nil {
            HStack {
                Button(action: {
                    showLeaderboard = true
                }
                       , label: {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 3)
                            .foregroundColor(.red)
                            .frame(width: 40, height: 40)
                        Image(uiImage: vm.playerImage!)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                })
                .overlay {
                    FlyingScore(scoreToAdd: scoreToAdd)
                }
                scoreView
            }
        }
        else {
            HStack {
                Button(action: {
                    showLeaderboard = true
                }
                       , label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                })
                .overlay {
                        FlyingScore(scoreToAdd: scoreToAdd)
                }
                scoreView
            }
        }
    }
    
    var scoreView: some View {
        Text("\(score)")
            .padding(.horizontal, 5.0)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.capsule)
            .animation(.easeInOut(duration: 1), value: score)
        
    }
}

#Preview {
    GameCenterIcon(showLeaderboard: .constant(true), scoreToAdd: .constant(0), score: 288)
}
