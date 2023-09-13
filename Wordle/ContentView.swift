//
//  ContentView.swift
//  Wordle
//
//  Created by Holger Becker on 09.09.23.
//

import SwiftUI


struct ContentView: View {
    @StateObject var vm = WordleModel()
        
    @FocusState private var focusedField: WordleModel.Field?

    var body: some View {
        NavigationView {
            VStack {
                ForEach(Array(zip(vm.tries.indices, vm.tries)), id: \.0) { (rowIndex, letterRow) in
                    HStack {
                        ForEach(Array(zip(letterRow.indices, letterRow)), id: \.0) { (index, letter) in
                            LetterView(letter: letter, rowIndex: rowIndex, index: index, fieldNumber: vm.fieldNumber, tryNumber: vm.tryNumber, animateField: vm.animateField)
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
                KeyBoard(character: $vm.letterInput)
                    .onChange(of: vm.letterInput) { newValue in
                        if newValue != "" {
                            if newValue == "🔙" {
                                vm.backspace()
                                return
                            }
                            vm.tries[vm.fieldNumber][vm.tryNumber].character = newValue
                            vm.setNextInputField()
                        }
                        focusedField = .name
                    }
            }
            .padding()
            .toolbar{toolBarContent(vm: vm)}
            .navigationTitle("Wordle")
        }
        .onAppear {
            focusedField = .location
        }
    }
    
    //MARK: - ToolBar
    struct toolBarContent: ToolbarContent {
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
                        vm.deleteWord()
                    }
                } label: {
                    Image(systemName: "folder.badge.minus")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation{
                        vm.newGame()
                    }
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
    
    
    struct LetterView: View {
        var letter: WordleModel.Letter
        var rowIndex: Int
        var index: Int
        
        var fieldNumber: Int
        var tryNumber: Int
        
        var animateField: Int

        var body: some View {
            Text(letter.character)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .aspectRatio(1, contentMode: .fill)
                .background {
                    if letter.rightPlace {
                        Color.green
                    }
                    else if letter.rightLetter {
                        Color.yellow
                    }
                    else if letter.wrong {
                        Color.gray
                    }
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: rowIndex == fieldNumber ? 3 : 1)
                        .foregroundColor(rowIndex == fieldNumber ? Color.black : Color.gray)
                        .background {
                            if rowIndex == fieldNumber && index == tryNumber {
                                Color.gray
                            }
                        }
                }
                .fixedSize(horizontal: false, vertical: true)
                .modifier(ShakeEffect(shakes: animateField == rowIndex ? 2 : 0))
        }
    }
    

    
    struct ShakeEffect: GeometryEffect {
        func effectValue(size: CGSize) -> ProjectionTransform {
            return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
        }
        
        init(shakes: Int) {
            position = CGFloat(shakes)
        }
        
        var position: CGFloat
        var animatableData: CGFloat {
            get { position }
            set { position = newValue }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
