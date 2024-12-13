//
//  EditAlarmView.swift
//  test_app
//
//  Created by ayana taba on 2024/06/02.
//

import SwiftUI
import UserNotifications

struct EditAlarmView: View {
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("起床時間")
                    .font(.headline)
                    .padding(.vertical, 5)
                ) {
                    DatePicker("起床時間", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("就寝時間")) {
                    DatePicker("就寝時間", selection: $bedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                }
            }
            .navigationBarTitle("アラーム編集", displayMode: .inline)
            .toolbar { ToolbarItem(placement: .principal) {
                Text("アラーム編集")
                    .fontWeight(.medium)
                    .foregroundColor(Color("MainColor"))
                    .font(.system(size: 18))
                }
            }
            .navigationBarItems(trailing: Button("完了") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 以前の通知をキャンセル
                scheduleNotification(at: wakeUpTime) // 起床時間に通知をスケジュール
                presentationMode.wrappedValue.dismiss()
            })
            //常時背景色を適用
            .toolbarBackground(.visible, for: .navigationBar)
            //背景色をグリーンにする
            .toolbarBackground(.green.opacity(0.3),for: .navigationBar)
        }
    }
}

func scheduleNotification(at date: Date) {
    let content = UNMutableNotificationContent()
    content.title = "アラーム"
    content.body = "起床時間です！"

    // カスタムサウンドを指定
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_sound.mp3"))
//    content.sound = UNNotificationSound.default

    // 時間だけに基づいて通知をスケジュールする
    let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
    print("通知が設定される時刻: \(triggerDate)")

    // 通知を毎日繰り返す
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("通知をスケジュールできませんでした: \(error.localizedDescription)")
        } else {
            print("毎日の通知がスケジュールされました")
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlarmView(wakeUpTime: .constant(Date()), bedTime: .constant(Date()))
    }
}
