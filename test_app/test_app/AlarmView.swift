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
//    @State private var wakeUpTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
//    @State private var bedTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
//    @State private var isEditing: Bool = false
    
    @Binding var isEditing: Bool
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date

    var body: some View {
        VStack {
            AlarmTimeView(title: "起床時間", time: wakeUpTime)
            AlarmTimeView(title: "就寝時間", time: bedTime)
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
            GroupBox{
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
//        .shadow(color: .init(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 0, y: 3)
        .padding()
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

//struct AlarmView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmView()
//    }
//}


#Preview {
    AlarmView(isEditing: .constant(false), wakeUpTime: .constant(Date()), bedTime: .constant(Date()))
}
