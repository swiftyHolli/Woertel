//
//  SolutionView.swift
//  Wordle
//
//  Created by Holger Becker on 30.09.23.
//

import SwiftUI

struct SolutionView : View {
    @ObservedObject var vm: WordleViewModel
    let text: String
    let show: Bool
    var body: some View {
        Text(text)
            .font(.system(size: vm.deviceGeometry.isIpad ? 100 : 50, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, vm.deviceGeometry.isIpad ? 50 : 25)
            .padding(.vertical, vm.deviceGeometry.isIpad ? 30 : 15)
            .background{
                LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topTrailing, endPoint: .bottomLeading)
            }
            .clipShape(.capsule)
            .opacity(show ? 1 : 0)
            .scaleEffect(CGSize(width: show ? 1 : 0, height: show ? 1 : 0))
            .animation(.spring(bounce: 0.8).delay(vm.lostAnimationDuration()), value: show)
    }
}

struct SolutionView_Previews: PreviewProvider {
    static var previews: some View {
        SolutionView(vm: WordleViewModel(), text: "Adler", show: true)
    }
}
