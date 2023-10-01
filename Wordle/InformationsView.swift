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
        VStack {
            VStack(spacing: 0) {
                header
                TabView(selection: $selection,
                        content:  {
                    InfoViewPage1(vm: vm, selection: $selection).tag(0)
                    InfoViewPage2(vm: vm, selection: $selection).tag(1)
                    InfoViewPage3(vm: vm, selection: $selection).tag(2)
                })
                .frame(width: UIScreen.main.bounds.size.width, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            Spacer()
            
        }
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
                .frame(width: UIScreen.main.bounds.size.width - 50, height: 100)
                .background{
                    LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.9440218806, green: 0.5319081545, blue: 0.1445603669, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))], startPoint: .top, endPoint: .bottom)
                }
                .clipShape(.capsule)
                .offset(y: 50)
            Button(action: {
                vm.showSettings.toggle()
            }, label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.red, .black], startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint:.bottom ))
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 5, y: 5)
                    Text("X")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
            })
            .offset(x: (UIScreen.main.bounds.size.width - 120) / 2, y: 10)
        }
        .zIndex(2)
    }
}

struct InfoViewPage1:View {
    @ObservedObject var vm: WordleViewModel
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("Finde das gesuchte Wort!")
                .font(.title)
                .fontWeight(.semibold)
            HStack {
                ForEach(vm.letterRow(type: .allRightPlace)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .padding(.vertical)
            Text("Tippe zum Start ein beliebiges Wort ein.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                ForEach(vm.letterRow(type: .allWrong)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .padding(.vertical)
            Text("Die Farben der Kästchen zeigen den Fortschritt an.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(.white)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 0
                        }
                    }
                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 1
                        }
                    }

                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 2
                        }
                    }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(width: UIScreen.main.bounds.size.width, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                  .fill(RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))], center: .center, startRadius: 0, endRadius: 400))
            }
        }
    }
}

struct InfoViewPage2:View {
    @ObservedObject var vm: WordleViewModel
    @Binding var selection: Int

    var body: some View {
        VStack {
            Spacer()
            Text("Markierte Buchstaben können mehrmals vorkommen")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                ForEach(vm.letterRow(type: .oneRightPlace)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .padding(.vertical)
            Text("Der Buchstabe \"A\" ist an der richtigen Stelle.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                ForEach(vm.letterRow(type: .oneRightLetter)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .padding(.vertical)
            Text("Die Buchstaben \"L\" und \"A\" stehen an der falschen Stelle.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 0
                        }
                    }
                Circle()
                    .fill(.white)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 1
                        }
                    }
                
                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 2
                        }
                    }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(width: UIScreen.main.bounds.size.width, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))], center: .center, startRadius: 0, endRadius: 400))
        }
    }
}

struct InfoViewPage3:View {
    @ObservedObject var vm: WordleViewModel
    @Binding var selection: Int

    var body: some View {
        VStack {
            Spacer()
            Text("\"G\", \"O\" und \"N\" kommen im Wort nicht vor.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding(.top, 40.0)
            HStack {
                ForEach(vm.letterRow(type: .rightPlaceAndLetter)) { letter in
                    LetterView(vm: WordleViewModel(), letter: letter)
                }
            }
            .padding(.vertical)
            Spacer()
            Text("Du hast insgesamt sechs Versuche.")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Text("Viel Spass beim Knobeln!")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Button("Statistik löschen") {
                vm.resetStatistic()
            }
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 0
                        }
                    }
                Circle()
                    .fill(.black)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 1
                        }
                    }
                
                Circle()
                    .fill(.white)
                    .frame(maxWidth: 20)
                    .onTapGesture {
                        withAnimation {
                            selection = 2
                        }
                    }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(width: UIScreen.main.bounds.size.width, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))], center: .center, startRadius: 0, endRadius: 400))
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationsView(vm: WordleViewModel())
    }
}
