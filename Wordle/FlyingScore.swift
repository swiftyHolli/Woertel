//
//  FlyingScore.swift
//  Wordle
//
//  Created by Holger Becker on 12.10.23.
//

import SwiftUI

struct FlyingScore: View {
    @Binding var scoreToAdd: Int
    @State private var offset: CGFloat = 0
    var body: some View {
        if scoreToAdd != 0 {
            Text(scoreToAdd, format: .number.sign(strategy: .always()))
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(scoreToAdd >= 0 ? .green : .red)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .opacity(offset != 0 ? 0 : 1)
                .offset(x: 0, y: offset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 3)) {
                        offset = scoreToAdd < 0 ? 100 : -100
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
}

#Preview {
    FlyingScore(scoreToAdd: .constant(-6))
}
