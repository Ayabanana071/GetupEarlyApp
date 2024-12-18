//
//  RecordView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/27.
//

import SwiftUI
import Charts

struct RecordView: View {
    @StateObject private var viewModel = EarlyRiseViewModel()
    
    let weekdays = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RecordCardView(title: "今週の平均起床時間", data: viewModel.wakeUpTimes, weekdays: weekdays)
                    .foregroundColor(Color("MainColor"))
                    .padding()
            }
            .onAppear {
                viewModel.fetchWakeUpTimes()
            }
        }
    }
}

struct RecordCardView: View {
    var title: String
    var data: [DateComponents]
    var weekdays: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            // 平均時間の計算
            let averageTime = calculateAverageTime(data)
            
            Text("\(formattedTime(from: averageTime))")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .padding([.leading, .bottom], 5)
            
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    let components = data[index]
                    let weekdayIndex = Calendar.current.component(.weekday, from: components.date ?? Date()) - 1 // `DateComponents`から曜日を計算
                    let weekdayName = weekdays[weekdayIndex]

                    // LineMark: 線を描画
                    LineMark(
                        x: .value("Day", weekdayName),
                        y: .value("Time", Double(components.hour ?? 0) + Double(components.minute ?? 0) / 60.0)
                    )
                }
            }
            .frame(height: 150)
            .padding()
        }
        .padding()
        .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
        .background(Color(red: 238/255, green: 240/255, blue: 237/255))
        .cornerRadius(10)
    }
    
    // 平均時間を計算する関数
    func calculateAverageTime(_ data: [DateComponents]) -> DateComponents {
        guard !data.isEmpty else {
            return DateComponents(hour: 0, minute: 0) // データがない場合のデフォルト値
        }
        
        let totalMinutes = data.reduce(0) { $0 + (($1.hour ?? 0) * 60 + ($1.minute ?? 0)) }
        let averageMinutes = totalMinutes / data.count
        return DateComponents(hour: averageMinutes / 60, minute: averageMinutes % 60)
    }
    
    // DateComponentsを文字列にフォーマットする関数
    func formattedTime(from dateComponents: DateComponents) -> String {
        guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
            return "N/A" // データがない場合の表示
        }
        return String(format: "%d:%02d", hour, minute)
    }
}


#Preview {
    RecordView()
}
