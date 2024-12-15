//
//  AlarmView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/16.
//

import SwiftUI
import UserNotifications

struct AlarmTime {
    var name: String
    var score: Int
}

struct AlarmView: View {
    @Binding var isEditing: Bool
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    
    // UserDefaults Keys
    private let wakeUpTimeKey = "wakeUpTime"
    private let bedTimeKey = "bedTime"
    
    var body: some View {
        VStack {
            AlarmTimeView(title: "起床時間", time: wakeUpTime)
            AlarmTimeView(title: "就寝時間", time: bedTime)
            
            Button(action: {
                isEditing = true
            }) {
                Text("時間を編集")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $isEditing) {
            EditAlarmView(wakeUpTime: $wakeUpTime, bedTime: $bedTime)
        }
        .padding()
    }
}

struct AlarmTimeView: View {
    var title: String
    var time: Date

    var body: some View {
        VStack(alignment: .leading) {
            GroupBox {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                
                Text(formattedTime(from: time))
                    .font(.system(size: 64))
                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 238/255, green: 240/255, blue: 237/255))
                    .cornerRadius(10)
            }
            .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
        }
        .padding()
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    AlarmView(
        isEditing: .constant(false), // 初期値としてfalseを渡す
        wakeUpTime: .constant(Date()), // 現在の日時を初期値として渡す
        bedTime: .constant(Date()) // 同じく現在の日時を渡す
    )
}
