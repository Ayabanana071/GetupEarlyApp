//
//  RecordView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/27.
//

import SwiftUI
import Charts

struct RecordView: View {
    @State var wakeUpTimes: [DateComponents] = [
        DateComponents(hour: 7, minute: 25),
        DateComponents(hour: 6, minute: 30),
        DateComponents(hour: 7, minute: 0),
        DateComponents(hour: 7, minute: 15),
        DateComponents(hour: 6, minute: 50),
        DateComponents(hour: 7, minute: 40),
        DateComponents(hour: 7, minute: 5)
    ]
    
    @State var bedTimes: [DateComponents] = [
        DateComponents(hour: 0, minute: 25),
        DateComponents(hour: 0, minute: 30),
        DateComponents(hour: 0, minute: 15),
        DateComponents(hour: 0, minute: 45),
        DateComponents(hour: 1, minute: 0),
        DateComponents(hour: 0, minute: 55),
        DateComponents(hour: 0, minute: 35)
    ]
    
    @State var sleepHours: [DateComponents] = [
        DateComponents(hour: 7, minute: 0),
        DateComponents(hour: 7, minute: 10),
        DateComponents(hour: 7, minute: 15),
        DateComponents(hour: 7, minute: 5),
        DateComponents(hour: 7, minute: 20),
        DateComponents(hour: 6, minute: 50),
        DateComponents(hour: 7, minute: 30)
    ]
    
    let weekdays = ["日", "月", "火", "水", "木", "金", "土"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RecordCardView(title: "今週の平均起床時間", data: wakeUpTimes, weekdays: weekdays)
                RecordCardView(title: "今週の平均就寝時間", data: bedTimes, weekdays: weekdays)
                RecordCardView(title: "今週の平均睡眠時間", data: sleepHours, weekdays: weekdays)
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
                .foregroundColor(.green)
                .padding(.bottom, 5)
            
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Day", weekdays[index]),
                        y: .value("Time", Double(data[index].hour ?? 0) + Double(data[index].minute ?? 0) / 60.0)
                    )
                }
            }
            .frame(height: 150)
            .padding()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    // 平均時間を計算する関数
    func calculateAverageTime(_ data: [DateComponents]) -> DateComponents {
        let totalMinutes = data.reduce(0) { $0 + (($1.hour ?? 0) * 60 + ($1.minute ?? 0)) }
        let averageMinutes = totalMinutes / data.count
        return DateComponents(hour: averageMinutes / 60, minute: averageMinutes % 60)
    }
    
    // DateComponentsを文字列にフォーマットする関数
    func formattedTime(from dateComponents: DateComponents) -> String {
        guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return "" }
        return String(format: "%d:%02d", hour, minute)
    }
}

#Preview {
    RecordView()
}
