//
//  ChartView.swift
//  Wordle
//
//  Created by Holger Becker on 05.10.23.
//

import SwiftUI
import Charts

class ChartViewModel: ObservableObject {
    struct SuccessfulTry: Identifiable {
        var id: String { return name }
        
        let name: String
        let value: Double
    }
    
    let chartData: [SuccessfulTry] = [
        SuccessfulTry(name: "1", value: 10),
        SuccessfulTry(name: "2", value: 30),
        SuccessfulTry(name: "3", value: 20),
        SuccessfulTry(name: "4", value: 20),
        SuccessfulTry(name: "5", value: 0.1),
        SuccessfulTry(name: "6", value: 5),
        SuccessfulTry(name: "X", value: 25)
    ]
}

struct ChartView: View {
    @ObservedObject var charViewModel: ChartViewModel
    
    let markerColor = Color.white.opacity(1)
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Anzahl der Versuche")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(markerColor)

            Chart(charViewModel.chartData) { data in
                BarMark(x: .value("Name", data.name),
                        y: .value("Value", data.value))
                .cornerRadius(5)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
                .foregroundStyle(Color.red)
                .annotation(position: .top, spacing: 0) {
                    Text("\(data.value, specifier: "%.0f")%")
                        .font(.caption)
                        .foregroundColor(.white)
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
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(centered: false, stroke: StrokeStyle(dash: [1,0,2]))
                        .foregroundStyle(markerColor)
                    AxisTick()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8.0)
        }
        
    }
}

#Preview {
    ChartView(charViewModel: ChartViewModel())
        .background {
            LinearGradient(colors: [Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),Color(uiColor: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))], startPoint: .topLeading, endPoint:.bottomTrailing )
                .ignoresSafeArea()
        }
}
