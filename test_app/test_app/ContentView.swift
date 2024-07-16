//
//  ContentView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/01.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTag = 1
    @State private var isEditing: Bool = false
    @State private var wakeUpTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var bedTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    @State private var routines: [Routine] = Routine.sampleData
    
    init(){
        UITabBar.appearance().backgroundColor
        = UIColor(red: 200/255, green: 236/255, blue: 195/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = .lightGray
    }
    
    var body: some View {
        TabView(selection: $selectedTag) {
            
            NavigationStack {
                FriendView()
                    .navigationTitle("フレンド")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
            }
            .tabItem { Label("Friend", systemImage: "person.2") }
            .tag(4)
            
            NavigationStack {
                AlarmView(isEditing: $isEditing, wakeUpTime: $wakeUpTime, bedTime: $bedTime)
                    .navigationTitle("アラーム")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
                    .navigationBarItems(trailing: Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Text("編集")
                    })
            }
            .tabItem { Label("Alarm", systemImage: "alarm") }
            .tag(2)
            
            NavigationStack {
                HomeView(wakeUpTime: $wakeUpTime, bedTime: $bedTime, routines: $routines)
                    .navigationTitle("ホーム")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(1)
            
            NavigationStack {
                MissionView()
                    .navigationTitle("ミッション")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
            }
            .tabItem { Label("Mission", systemImage: "trophy") }
            .tag(3)
            
            NavigationStack {
                AccountView()
                    .navigationTitle("アカウント")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
            }
            .tabItem { Label("Account", systemImage: "person.circle") }
            .tag(5)
            
        }
        .accentColor(.green)
    }
}

struct Routine: Identifiable {
    let id = UUID()
    var title: String
    var duration: Int
}

extension Routine {
    static let sampleData: [Routine] = [
        Routine(title: "カーテンを開ける", duration: 1),
        Routine(title: "歯磨き", duration: 5),
        Routine(title: "朝ごはん作る", duration: 10),
        Routine(title: "食事する", duration: 15),
        Routine(title: "歯磨き", duration: 5),
        Routine(title: "着替える", duration: 5)
    ]
}

#Preview {
    ContentView()
}
