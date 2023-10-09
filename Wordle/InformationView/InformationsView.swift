//
//  InformationsView.swift
//  Wordle MVVM
//
//  Created by Holger Becker on 24.09.23.
//

import SwiftUI

struct InformationsView: View {
    @ObservedObject var vm: WordleViewModel
    @State var selection = 0
    @State private var minHeight: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                header
                TabView(selection: $selection,
                        content:  {
                    InfoViewPage1(vm: vm, selection: $selection).tag(0)
                    InfoViewPage2(vm: vm, selection: $selection).tag(1)
                    InfoViewPage3(vm: vm, selection: $selection).tag(2)
                })
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(width: vm.deviceGeometry.infoViewWidth,
                       height: vm.deviceGeometry.infoViewHeight,
                       alignment: .center)
            }
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
    }
     
    var header: some View {
        ZStack {
            Text("Spielanleitung")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: vm.deviceGeometry.infoViewHeaderWidth,
                       height: vm.deviceGeometry.infoViewHeaderHeight)
                .background{
                    LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))], startPoint: .top, endPoint: .bottom)
                }
                .clipShape(.capsule)
                .offset(y: -vm.deviceGeometry.infoViewHeight / 2)
            Button(action: {
                vm.showInfo.toggle()
            }, label: {
                CloseButtonView()
            })
            .offset(vm.deviceGeometry.infoViewCloseButtonOffset)
        }
        .zIndex(2)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationsView(vm: WordleViewModel())
    }
}
