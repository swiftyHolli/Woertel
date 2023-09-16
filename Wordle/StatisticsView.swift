//
//  StatisticsView.swift
//  Wordle
//
//  Created by Holger Becker on 16.09.23.
//

import SwiftUI

class StatisticDataModel: ObservableObject {
    @Published var totalNumberOfGames = 0
    @Published var numberOfLostGames = 0
    @Published var numberOfWonGames = 0
    @Published var firstTry: Float = 0
    @Published var secondTry: Float = 0
    @Published var thirdTry: Float = 0
    @Published var fourthTry: Float = 0
    @Published var firthTry: Float = 0
    @Published var sixthTry: Float = 0
    @Published var multiplier: Float = 1.0
    
    @Published var statistics = [Float]()

    @AppStorage("totalGames") var numberOfGames: Int = 0
    @AppStorage("firstTry") var numberOfFirstTrys: Int = 0
    @AppStorage("secondTry") var numberOfSecondTrys: Int = 0
    @AppStorage("thirdTry") var numberOfThirdTrys: Int = 0
    @AppStorage("fourthTry") var numberOFourthTrys: Int = 0
    @AppStorage("fifthTry") var numberOfFifthTrys: Int = 0
    @AppStorage("sixthTry") var numberOfSixthTrys: Int = 0


    
    init() {
        loadStatistics()
    }
    
    private func loadStatistics() {
        totalNumberOfGames = numberOfGames
        numberOfLostGames = totalNumberOfGames - numberOfFirstTrys - numberOfSecondTrys - numberOfThirdTrys - numberOFourthTrys - numberOfFifthTrys - numberOfSixthTrys
        numberOfWonGames = numberOfFirstTrys + numberOfSecondTrys + numberOfThirdTrys + numberOFourthTrys + numberOfFifthTrys + numberOfSixthTrys
        statistics.append(Float(numberOfFirstTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOfSecondTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOfThirdTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOFourthTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOfFifthTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOfSixthTrys) / Float(totalNumberOfGames))
        statistics.append(Float(numberOfLostGames) / Float(totalNumberOfGames))
        
        multiplier = 1.0 / (statistics.max() ?? 1.0)/// Float(totalNumberOfGames)
        print(multiplier)
    }
}

struct StatisticsView: View {
    
    @EnvironmentObject var vm: WordleModel
    @StateObject var statisticsViewModel = StatisticDataModel()
    
    var color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    
    var body: some View {
        VStack() {
            HStack {
                ResultField(name: "Games", value: statisticsViewModel.totalNumberOfGames)
                Spacer()
                ResultField(name: "Won", value: statisticsViewModel.numberOfWonGames)
                Spacer()
                ResultField(name: "Lost", value: statisticsViewModel.numberOfLostGames)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            VStack {
                Text("Number of Tries")
                    .font(.headline)
                    .foregroundColor(.white)
                HStack {
                    ForEach(0..<statisticsViewModel.statistics.count, id: \.self) {index in
                        let percentValue = statisticsViewModel.statistics[index]
                        let percentValueString = String(format: "%.0f", percentValue * 100)
                        let drawPercentValue = statisticsViewModel.multiplier * percentValue
                        GeometryReader { geometry in
                            VStack {
                                Text(index == 6 ? "X" : "\(index + 1)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow)
                                Spacer()
                                
                                Text("\(percentValueString)%")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(height: (geometry.size.height - 60) * max(CGFloat(drawPercentValue) , 0.01))
                            }
                            .background(Color.green)
                        }
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: .black, radius: 10, x: 10, y: 10)
            }
            .shadow(radius: 5)

        }
        .padding(.horizontal)
//        .foregroundStyle(.ultraThinMaterial)
//        .background (
//            Material.ultraThinMaterial
//            LinearGradient(colors: [Color(#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
//        )
    }
    
    struct ResultField: View {
        var name: String
        var value: Int
        var body: some View {
            VStack {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 0.0)
                Text("\(value)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .black, radius: 10, x: 10, y: 10)
                    }
                    .padding(.bottom, 8)
                    

            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black, radius: 10, x: 10, y: 10)
        }
    }
}



struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
                StatisticsView()
    }
}
