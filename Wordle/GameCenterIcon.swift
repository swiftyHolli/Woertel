//
//  GameCenterIcon.swift
//  Wordle
//
//  Created by Holger Becker on 12.10.23.
//

import SwiftUI
import GameKit

final class GameCenterViewModel: ObservableObject {
    
    static let shared = GameCenterViewModel()
    let localPlayer = GKLocalPlayer.local
    @AppStorage("score") var score: Int = 0

    private init() { 
        authenticateUser()
    }
    
    @Published var playerImage: UIImage?
    @Published var displayName: String = ""
    var isGKActive = false

    func authenticateUser() {
        localPlayer.authenticateHandler = { [self] vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = false
            Task{
                try await self.loadPhoto()
            }
            GKAccessPoint.shared.showHighlights = false
            GKAccessPoint.shared.isActive = false
            getHighScoreFromLeadboard()

        }
    }
    
    func setHighSore(score: Int) async{
        Task{
            try await GKLeaderboard.submitScore(
                score,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: ["de.chhb.wordle"]
            )
        }
    }
    
    func loadPhoto() async throws {
        if GKLocalPlayer.local.isAuthenticated {
            let image = try await GKLocalPlayer.local.loadPhoto(for: .normal)
            await MainActor.run {
                withAnimation {
                    playerImage = image
                    displayName = GKLocalPlayer.local.displayName
                    isGKActive = playerImage != nil
                }
            }
        }
    }
    
    func getHighScoreFromLeadboard() {
        // Check if the user is authenticated
        if (GKLocalPlayer.local.isAuthenticated) {
            // Load the leaderboards that will be accessed
            GKLeaderboard.loadLeaderboards(
                IDs: ["de.chhb.wordle"]          // Leaderboards'id  that will be accessed
            ) { leaderboards, _ in          // completionHandler 01: .loadLeaderboards
                
                // Access the first leaderboard
                leaderboards?[0].loadEntries(
                    for: [GKLocalPlayer.local], // User who will be accessed within the leaderboard, in this case the local user
                    timeScope: .allTime)        // Choose which period of the leaderboard you will access (all time, weekly, daily...)
                { player, _, _ in           // completionHandler 02: .loadEntries
                    
                    // Save on UserDefault
                   // UserDefaults.standard.set(player?.score, forKey: "score")
                    if let tempScore = player?.score {
                        if self.score < player!.score {
                            self.score = player!.score
                        }
                    }
                }
            }
        }
    }

}


struct GameCenterIcon: View {
    @ObservedObject var vm = GameCenterViewModel.shared
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
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                        Image(uiImage: vm.playerImage!)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                })
                .overlay {
                    FlyingScore(scoreToAdd: $scoreToAdd)
                }
                Text("\(score)")
                    .padding(.horizontal, 5.0)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .animation(.easeInOut(duration: 1), value: score)
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
                        FlyingScore(scoreToAdd: $scoreToAdd)
                }
                Text("\(score)")
                    .padding(.horizontal, 5.0)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .animation(.easeInOut(duration: 1), value: score)
            }
        }
    }
}

#Preview {
    GameCenterIcon(showLeaderboard: .constant(true), scoreToAdd: .constant(0), score: 288)
}
