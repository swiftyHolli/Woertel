//
//  StatisticsView.swift
//  Wordle
//
//  Created by Holger Becker on 16.09.23.
//

import SwiftUI

class StatisticsDataModel: ObservableObject {
    @Published var totalNumberOfGames = 0
    @Published var numberOfLostGames = 0
    @Published var numberOfWonGames = 0
    @Published var numberOfWonGamesPercent = 0.0
    
    @Published var statistics = [Float]()

    @AppStorage("totalGames") var numberOfGames: Int = 0
    @AppStorage("firstTry") var numberOfFirstTrys: Int = 0
    @AppStorage("secondTry") var numberOfSecondTrys: Int = 0
    @AppStorage("thirdTry") var numberOfThirdTrys: Int = 0
    @AppStorage("fourthTry") var numberOFourthTrys: Int = 0
    @AppStorage("fifthTry") var numberOfFifthTrys: Int = 0
    @AppStorage("sixthTry") var numberOfSixthTrys: Int = 0
    @AppStorage("series") var series: Int = 0
    @AppStorage("bestSeries") var bestSeries: Int = 0

    struct SuccessfulTry: Identifiable {
        var id: String { return name }
        
        var name: String
        var percentValue: Double
        var value: Int
    }
    
    @Published var chartData = [SuccessfulTry]()
    
    init() {
        loadStatistics()
        loadChardData()
    }
    
    private func loadChardData() {
        chartData = [
            SuccessfulTry(name: "1", 
                          percentValue: Double(numberOfFirstTrys) / Double(numberOfGames) * 100,
                          value: numberOfFirstTrys),
            SuccessfulTry(name: "2",
                          percentValue: Double(numberOfSecondTrys) / Double(numberOfGames) * 100,
                          value: numberOfSecondTrys),
            SuccessfulTry(name: "3",
                          percentValue: Double(numberOfThirdTrys) / Double(numberOfGames) * 100,
                          value: numberOfThirdTrys),
            SuccessfulTry(name: "4",
                          percentValue: Double(numberOFourthTrys) / Double(numberOfGames) * 100,
                          value: numberOFourthTrys),
            SuccessfulTry(name: "5",
                          percentValue: Double(numberOfFifthTrys) / Double(numberOfGames) * 100,
                          value: numberOfFifthTrys),
            SuccessfulTry(name: "6",
                          percentValue: Double(numberOfSixthTrys) / Double(numberOfGames) * 100,
                          value: numberOfSixthTrys),
            SuccessfulTry(name: "X",
                          percentValue: Double(numberOfLostGames) / Double(numberOfGames) * 100,
                          value: numberOfLostGames)
        ]
        for (index, successfulTry) in chartData.enumerated() {
            if successfulTry.value == 0 || successfulTry.percentValue.isNaN {
                chartData[index].percentValue = 0.4
            }
        }
    }
    
    private func loadStatistics() {
        totalNumberOfGames = numberOfGames
        numberOfLostGames = totalNumberOfGames - numberOfFirstTrys - numberOfSecondTrys - numberOfThirdTrys - numberOFourthTrys - numberOfFifthTrys - numberOfSixthTrys
        numberOfWonGames = numberOfFirstTrys + numberOfSecondTrys + numberOfThirdTrys + numberOFourthTrys + numberOfFifthTrys + numberOfSixthTrys

        if totalNumberOfGames > 0 {
            numberOfWonGamesPercent = Double(numberOfWonGames) / Double(totalNumberOfGames) * 100.0
        }
        else {
            numberOfWonGamesPercent = 0
        }
        let numberOfGames = totalNumberOfGames == 0 ? 1 : totalNumberOfGames
        statistics.append(Float(numberOfFirstTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfSecondTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfThirdTrys) / Float(numberOfGames))
        statistics.append(Float(numberOFourthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfFifthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfSixthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfLostGames) / Float(numberOfGames))
    }
}

struct StatisticsView: View {
    @ObservedObject var vm: WordleViewModel

    @StateObject var statisticsDataModel = StatisticsDataModel()

    var color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSubView(vm: vm)
            HStack {
                ResultField(name: "Spiele", value: statisticsDataModel.totalNumberOfGames, percent: false)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "Gewonnen", value: Int(statisticsDataModel.numberOfWonGamesPercent), percent: true)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "Serie", value: statisticsDataModel.series, percent: false)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "beste Serie", value: statisticsDataModel.bestSeries, percent: false)
            }
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background {
                    LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding()
            ChartView(statisticsDataModel: statisticsDataModel)
        }
        .background (
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()        
        )
    }
    
    
    struct ResultField: View {
        var name: String
        var value: Int
        var percent: Bool
        var body: some View {
            VStack {
                Text("\(value)\(percent ? "%" : "")" )
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .padding(.bottom, 0)
                Text(name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}



struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            Rectangle().fill(.white)
            StatisticsView(vm: WordleViewModel())
        }
    }
}

