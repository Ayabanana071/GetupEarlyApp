//
//  AppDelegate.swift
//  test_app
//
//  Created by ayana taba on 2024/10/23.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // アプリ起動時に呼ばれる
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 通知のデリゲートを設定
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        return true
    }

    // アプリがフォアグラウンドにいるときでも通知を表示し、音を鳴らすためのメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 通知がアクティブ時にバナーとサウンドを表示
        completionHandler([.banner, .sound])
    }

    // その他のメソッドがここに続きます...
}
