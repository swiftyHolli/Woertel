//
//  GameCenterManager.swift
//  Wordle
//
//  Created by Holger Becker on 13.10.23.
//

import SwiftUI
import GameKit

final class GameCenterManager: ObservableObject {
    
    static let shared = GameCenterManager()
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
                leaderboardIDs: ["de.chhb.woertel"]
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
                IDs: ["de.chhb.woertel"]          // Leaderboards'id  that will be accessed
            ) { leaderboards, _ in          // completionHandler 01: .loadLeaderboards
                
                // Access the first leaderboard
                leaderboards?[0].loadEntries(
                    for: [GKLocalPlayer.local], // User who will be accessed within the leaderboard, in this case the local user
                    timeScope: .allTime)        // Choose which period of the leaderboard you will access (all time, weekly, daily...)
                { player, _, _ in           // completionHandler 02: .loadEntries
                    
                    // Save on UserDefault
                    // UserDefaults.standard.set(player?.score, forKey: "score")
                    if let _ = player?.score {
                        if self.score < player!.score {
                            self.score = player!.score
                        }
                    }
                }
            }
        }
    }
}

