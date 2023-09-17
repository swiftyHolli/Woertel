//
//  WordleView.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI


struct WordleView: View {
    @EnvironmentObject var vm: WordleModel
    @State var showingStatistics = false
    
    @FocusState private var focusedField: WordleModel.Field?
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    let width = min(geometry.size.width / 6, geometry.size.height / 7)
                    let _ = print("width: \(width)")
                    VStack (alignment: .center){
                        ForEach(Array(zip(vm.tries.indices, vm.tries)), id: \.0) { (rowIndex, letterRow) in
                            HStack {
                                ForEach(Array(zip(letterRow.indices, letterRow)), id: \.0) { (index, letter) in
                                    LetterView(letter: letter, rowIndex: rowIndex, index: index, width: width, tryNumber: vm.tryNumber, fieldNumber: vm.fieldNumber, animateField: $vm.animateField)
                                        .onTapGesture {
                                            vm.tryNumber = index
                                        }
                                    
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    //.padding()
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
                        focusedField = .name
                    }
            }
            //.padding()
            .toolbar{Toolbar(vm: vm)}
        }
        .onAppear {
            focusedField = .location
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
struct WordleView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView()
            .environmentObject(WordleModel())
    }
}
