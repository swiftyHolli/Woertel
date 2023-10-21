//
//  ChartView.swift
//  Wordle
//
//  Created by Holger Becker on 05.10.23.
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var statisticsDataModel: StatisticsDataModel
    
    let markerColor = Color.white.opacity(1)
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Anzahl der Versuche")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(markerColor)

            Chart(statisticsDataModel.chartData) { data in
                BarMark(x: .value("Name", data.name),
                        y: .value("PercentValue", data.percentValue))
                .cornerRadius(5)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
                .foregroundStyle(Color.red)
                .annotation(position: .top, alignment: .center, spacing: 0) {
                    Text("\(data.value)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-90))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisGridLine()
                        .foregroundStyle(markerColor)
                    AxisTick()
                    AxisValueLabel()
                        .foregroundStyle(markerColor)
                        .font(.callout)
                    
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine(centered: false, stroke: StrokeStyle(dash: [1,0,2]))
                        .foregroundStyle(markerColor)
                    AxisTick()
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)%")
                                .foregroundStyle(markerColor)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8.0)
        }
        
    }
}

#Preview {
    ChartView(statisticsDataModel: StatisticsDataModel())
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
}
