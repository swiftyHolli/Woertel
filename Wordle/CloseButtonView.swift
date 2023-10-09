//
//  CloseButtonView.swift
//  Wordle
//
//  Created by Holger Becker on 07.10.23.
//

import SwiftUI

struct CloseButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.red, .black], startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint:.bottom ))
                .frame(width: 50, height: 50, alignment: .center)
                .shadow(color: .black, radius: 10, x: 5, y: 5)
            Text("X")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CloseButtonView()
}
