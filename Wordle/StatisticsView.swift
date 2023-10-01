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
    @Published var numberOfWonGamesPercent = 0.0
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
    @AppStorage("series") var series: Int = 0
    @AppStorage("bestSeries") var bestSeries: Int = 0

    
    init() {
        loadStatistics()
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
        print("gewonnen% - \(numberOfWonGamesPercent)")
        let numberOfGames = totalNumberOfGames == 0 ? 1 : totalNumberOfGames
        statistics.append(Float(numberOfFirstTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfSecondTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfThirdTrys) / Float(numberOfGames))
        statistics.append(Float(numberOFourthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfFifthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfSixthTrys) / Float(numberOfGames))
        statistics.append(Float(numberOfLostGames) / Float(numberOfGames))
        
        multiplier = 1.0 / (statistics.max() ?? 0 == 0 ? 1.0 : statistics.max() ?? 0)
    }
}

struct StatisticsView: View {
    
    @StateObject var statisticsViewModel = StatisticDataModel()
    
    var color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ResultField(name: "Spiele", value: statisticsViewModel.totalNumberOfGames, percent: false)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "Gewonnen", value: Int(statisticsViewModel.numberOfWonGamesPercent), percent: true)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "Serie", value: statisticsViewModel.series, percent: false)
                Rectangle().frame(width: 2, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ResultField(name: "beste Serie", value: statisticsViewModel.bestSeries, percent: false)
            }
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background {
                    LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding()
            VStack(spacing: 0) {
                Text("Anzahl der Versuche")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                GeometryReader { geometry in
                HStack {
                    ForEach(0..<statisticsViewModel.statistics.count, id: \.self) {index in
                        let percentValue = statisticsViewModel.statistics[index]
                        let percentValueString = String(format: "%.0f", percentValue * 100)
                        let drawPercentValue = statisticsViewModel.multiplier * percentValue
                            VStack(spacing: 0) {
                                Spacer(minLength: 0)
                                Text("\(percentValueString)%")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.red)
                                    .frame(height: abs(geometry.size.height - 43) * max(CGFloat(drawPercentValue) , 0.01))
                                    .shadow(color: .black, radius: 2, x: 3, y: 3)
                                Text(index == 6 ? "X" : "\(index + 1)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 3.0)
                            }
                        }
                }.padding(.horizontal)
                }
            }
        }
        .background (
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()        )
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
            Rectangle().fill(.white)
            StatisticsView()
        }
    }
}

