//
//  WordleView.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI

struct WordleColors {
    static let rightPlace = Color(uiColor: #colorLiteral(red: 0.244219631, green: 0.7725548148, blue: 0.7890618443, alpha: 1))
    static let rightPlaceShadow = Color(uiColor: #colorLiteral(red: 0.1710186601, green: 0.5491942167, blue: 0.5561188459, alpha: 1))
    static let rightLetter = Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1))
    static let rightLetterShadow = Color(uiColor: #colorLiteral(red: 0.8136706352, green: 0.4051097035, blue: 0.01514841989, alpha: 1))
    static let wrong = Color(uiColor: #colorLiteral(red: 0.5058823824, green: 0.505882442, blue: 0.5058823824, alpha: 1))
    static let wrongShadow = Color(uiColor: #colorLiteral(red: 0.3137255013, green: 0.3137255013, blue: 0.3137255013, alpha: 1))
}

class WordleViewModel: ObservableObject {
    let model = WordleModel()
    
    //MARK: - intends
    func enter() {
        
    }
    
}


struct WordleView: View {
    @StateObject var vm = WordleModel()
    @State var showingStatistics = false
        
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    let width = min(geometry.size.width / 6, geometry.size.height / 7)
                    VStack (alignment: .center){
                        ForEach(Array(zip(vm.tries.indices, vm.tries)), id: \.0) { (rowIndex, letterRow) in
                            HStack {
                                ForEach(Array(zip(letterRow.indices, letterRow)), id: \.0) { (index, letter) in
                                    LetterView(letter: letter, rowIndex: rowIndex, index: index, width: max(width, 6), tryNumber: vm.tryNumber, fieldNumber: vm.fieldNumber, animateField: $vm.animateField, animateColors: $vm.animateColors)
                                        .onTapGesture {
                                            vm.tryNumber = index
                                        }
                                }
                            }
                            .modifier(ShakeEffect(shakes: $vm.animateField.wrappedValue == rowIndex ? 1 : 0))
                            .animation(.easeInOut(duration: 0.5), value: $vm.animateField.wrappedValue == rowIndex)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                Spacer()
                if vm.cheat {
                    Text("\(vm.chosenWord[0])\(vm.chosenWord[1])\(vm.chosenWord[2])\(vm.chosenWord[3])\(vm.chosenWord[4])")
                }
                if vm.won {
                    Text("Gewonnen!")
                }

                KeyBoard(character: $vm.letterInput, showingStatistics: $showingStatistics)
                    .onChange(of: vm.letterInput) { newValue in
                        if newValue != "" {
                            if newValue == "⌫" {
                                vm.backspace()
                                return
                            }
                            if newValue == "⏎" {
                                vm.checkRow()
                                if vm.won {
                                    showingStatistics.toggle()
                                }
                                return
                            }
                            vm.tries[vm.fieldNumber][vm.tryNumber].character = newValue
                            vm.setNextInputField()
                        }
                    }
            }
            .toolbar{Toolbar(vm: vm)}
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .environmentObject(vm)
    }

}
struct WordleView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView()
    }
}
