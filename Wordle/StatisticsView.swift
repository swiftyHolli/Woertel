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
    }
}

struct StatisticsView: View {
    
    @EnvironmentObject var vm: WordleModel
    @StateObject var statisticsViewModel = StatisticDataModel()
    
    var color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ResultField(name: "Games", value: statisticsViewModel.totalNumberOfGames)
                Spacer()
                ResultField(name: "Won", value: statisticsViewModel.numberOfWonGames)
                Spacer()
                ResultField(name: "Lost", value: statisticsViewModel.numberOfLostGames)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            VStack(spacing: 10) {
                Text("Number of Tries")
                    .font(.title2)
                    .fontWeight(.semibold)
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
                                    .frame(height: abs(geometry.size.height - 60) * max(CGFloat(drawPercentValue) , 0.01))
                            }
                        }
                    }
                }
            }
            .shadow(radius: 5)

        }
        .padding(.horizontal)
        .background (
            LinearGradient(colors: [Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)), Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    struct ResultField: View {
        var name: String
        var value: Int
        var body: some View {
            VStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 0)
                Text("\(value)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .padding(.bottom, 0)
                    

            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black, radius: 10, x: 10, y: 10)
        }
    }
}



struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle().fill(.white)
            StatisticsView()
        }
    }
}
