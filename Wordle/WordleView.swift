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
        NavigationView {
            VStack {
                ForEach(Array(zip(vm.tries.indices, vm.tries)), id: \.0) { (rowIndex, letterRow) in
                    HStack {
                        ForEach(Array(zip(letterRow.indices, letterRow)), id: \.0) { (index, letter) in
                            LetterView(letter: letter, rowIndex: rowIndex, index: index, tryNumber: vm.tryNumber, fieldNumber: vm.fieldNumber, animateField: $vm.animateField)
                                .onTapGesture {
                                    vm.tryNumber = index
                                }
                        }
                    }
                }
                Spacer()
                if vm.cheat {
                    Text("\(vm.chosenWord[0])\(vm.chosenWord[1])\(vm.chosenWord[2])\(vm.chosenWord[3])\(vm.chosenWord[4])")
                }
                if vm.won {
                    Text("Gewonnen!")
                }
                KeyBoard(character: $vm.letterInput)
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
            .padding()
            .toolbar{toolBarContent(showingStatistics: $showingStatistics, vm: vm)}
            .navigationTitle("Wordle")
        }
        .onAppear {
            focusedField = .location
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView()
                .presentationDetents([.medium])
                .presentationBackground(.thinMaterial)
        }
    }
    
    //MARK: - ToolBar
    struct toolBarContent: ToolbarContent {
        @Binding var showingStatistics: Bool
        var vm: WordleModel
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation{
                        vm.checkRow()
                    }
                } label: {
                    Image(systemName: "checkmark.bubble")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation{
                        showingStatistics.toggle()
                    }
                } label: {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.newGame()
                } label: {
                    Image(systemName: "restart.circle")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation{
                        vm.cheat.toggle()
                    }
                } label: {
                    Image(systemName: "eye")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct WordleView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView()
            .environmentObject(WordleModel())
    }
}
