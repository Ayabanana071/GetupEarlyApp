//
//  test_appApp.swift
//  test_app
//
//  Created by ayana taba on 2024/05/01.
//

import SwiftUI

@main
struct test_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
