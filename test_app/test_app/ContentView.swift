//
//  ContentView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/01.
//

import SwiftUI

struct ContentView: View {
    @State private var isLogin = false
    
    @State var selectedTag = 1
    @State private var isEditing: Bool = false
    @State private var wakeUpTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var bedTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    @State private var routines: [Routine] = Routine.sampleData
    
    // UserDefaults Keys
    private let wakeUpTimeKey = "wakeUpTime"
    private let bedTimeKey = "bedTime"
    
    init(){
        UITabBar.appearance().backgroundColor
        = UIColor(red: 200/255, green: 236/255, blue: 195/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: Color(red: 48/255, green: 178/255, blue: 127/255)]
        
    }
    
    var body: some View {
        if (!isLogin) {
            LoginView(isLogin: $isLogin)
        }
        else {
            TabView(selection: $selectedTag) {
                
                NavigationStack {
                    FriendView()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("フレンド")
                                    .font(.headline)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
                }
                .tabItem { Label("Friend", systemImage: "person.2") }
                .tag(4)
                
                NavigationStack {
                    AlarmView(isEditing: $isEditing, wakeUpTime: $wakeUpTime, bedTime: $bedTime)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("アラーム")
                                    .font(.headline)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
//                        .navigationBarItems(trailing: Button(action: {
//                            self.isEditing.toggle()
//                        }) {
//                            Text("編集")
//                                .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
//                        })
                }
                .tabItem { Label("Alarm", systemImage: "alarm") }
                .tag(2)
                
                NavigationStack {
                    HomeView(wakeUpTime: $wakeUpTime, bedTime: $bedTime, routines: $routines)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("ホーム")
                                    .font(.headline)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
                }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(1)
                
                NavigationStack {
                    MissionView()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("ミッション")
                                    .font(.headline)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
                }
                .tabItem { Label("Mission", systemImage: "trophy") }
                .tag(3)
                
                NavigationStack {
                    AccountView(isLogin: $isLogin)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("アカウント")
                                    .font(.headline)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarBackground(.green.opacity(0.4), for: .navigationBar)
                }
                .tabItem { Label("Account", systemImage: "person.circle") }
                .tag(5)
                
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("通知が許可されました")
                    } else {
                        print("通知が拒否されました")
                    }
                }
                loadTimesFromUserDefaults()
            }
            .accentColor(.accentColor)
        }
    }
    
    private func loadTimesFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let savedWakeUpTime = defaults.object(forKey: wakeUpTimeKey) as? Date {
            wakeUpTime = savedWakeUpTime
        }
        if let savedBedTime = defaults.object(forKey: bedTimeKey) as? Date {
            bedTime = savedBedTime
        }
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
