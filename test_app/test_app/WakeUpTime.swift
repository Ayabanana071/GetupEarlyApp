//
//  WakeUpTimeToServer.swift
//  test_app
//
//  Created by ayana taba on 2024/12/16.
//

import SwiftUI
import Foundation

func sendWakeUpTimeToServer(wakeUpTime: Date) {
    guard let token = UserDefaults.standard.string(forKey: "userToken") else {
        print("ログインしていないため、起床時間を作成できません")
        return
    }
    guard let url = URL(string: "http://BOBnoMacBook-Pro.local:3000/wake_up_times") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let dateFormatter = ISO8601DateFormatter()
    let wakeUpTimeString = dateFormatter.string(from: wakeUpTime)

    let body: [String: Any] = [
        "wake_up_time": [
            "wake_up_time": wakeUpTimeString
        ]
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
            print("Failed to save wake up time")
            return
        }

        print("Wake up time saved successfully")
    }.resume()
}

func rescheduleWakeUpNotifications() {
    // UserDefaults Keys
    let wakeUpTimeKey = "wakeUpTime"
    
    // 起床通知を全てキャンセル
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    print("既存の起床通知をキャンセルしました")
    
    // UserDefaultsから起床時間を取得
    let defaults = UserDefaults.standard
    guard let savedWakeUpTime = defaults.object(forKey: wakeUpTimeKey) as? Date else {
        print("ユーザーデフォルトに起床時間が保存されていません")
        return
    }
    
    print("保存された起床時間: \(savedWakeUpTime)")
    
    // 新しい起床通知をスケジュール
    for i in 0..<3 { // 3回通知をスケジュール
        let content = UNMutableNotificationContent()
        content.title = "アラーム"
        content.body = "起床時間です！エクササイズをして目覚めましょう！"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_sound.mp3"))

        // 通知時刻を計算
        let triggerDate = Calendar.current.date(byAdding: .minute, value: i * 2, to: savedWakeUpTime) ?? savedWakeUpTime
        let triggerComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "wakeUpTimeNotification_\(i)", // ユニークなIDを設定
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("起床通知のスケジュールエラー: \(error.localizedDescription)")
            } else {
                print("起床通知がスケジュールされました: \(triggerDate)")
            }
        }
    }
}

struct WakeUpView: View {
    @State private var isQuizPresented = false
    
    var body: some View {
        Button("起きる！") {
            isQuizPresented = true
        }
        .sheet(isPresented: $isQuizPresented) {
            MathQuizView()
        }
        .padding(.horizontal, 30.0)
        .padding(.vertical)
        .background(Color(red: 48/255, green: 178/255, blue: 127/255))
        .foregroundColor(.white)
        .cornerRadius(30)
    }
}

struct WakeUpView_Previews: PreviewProvider {
    static var previews: some View {
        WakeUpView()
    }
}
