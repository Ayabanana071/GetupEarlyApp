//
//  ContentView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/01.
//

import SwiftUI


struct ContentView: View {
    @State var selectedTag = 1
    
//    init() {
//        // 文字色
//        UITabBar.appearance().unselectedItemTintColor = .white
//        // 背景色
//        UITabBar.appearance().backgroundColor = .black
//        
//    }
    

    
    var body: some View {

        
        TabView(selection: $selectedTag) {
            
            NavigationStack{
                FriendView()
                    .navigationTitle("フレンド")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {Label("Friend",systemImage: "person.2")}
                .tag(4)
            
            NavigationStack{
                AlarmView()
                    .navigationTitle("アラーム")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {Label("Alarm",systemImage: "alarm.fill")}
                .tag(2)
            
            NavigationStack{
                HomeView()
                    .navigationTitle("ホーム")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {Label("Home",systemImage: "house")}
                .tag(1)
            
            
            NavigationStack{
                MissionView()
                    .navigationTitle("ミッション")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {Label("Mission",systemImage: "shield.fill")}
                .tag(3)
            
            NavigationStack{
                AccountView()
                    .navigationTitle("アカウント")
                    .navigationBarTitleDisplayMode(.inline)
            }.tabItem {Label("Account",systemImage: "person.circle")}
                .tag(5)
            
        }
    }
}


#Preview {
    ContentView()
}
