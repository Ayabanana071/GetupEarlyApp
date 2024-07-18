//
//  MissionView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/23.
//

import SwiftUI

struct Friend {
    var name: String
    var score: Int
}

struct Mission {
    var checked: Bool
    var kind: String
    var mission_count: Int
    
    init(_ kind: String) {
        self.checked = false
        self.kind = kind
        self.mission_count = 0
    }
}

struct MissionView: View {
    @State var friends: [Friend] = [
        Friend(name: "喜納日菜妃", score: 30),
        Friend(name: "真栄喜楓鈴", score: 25),
        Friend(name: "津嘉山みやび", score: 10),
        Friend(name: "岸本志琉", score: 15),
        Friend(name: "島袋愛子", score: 5)
    ]
    
    @State var mission: [Mission] = [
        Mission("決めた時間に起きよう"),
        Mission("友達と同じ時間に起きよう"),
        Mission("朝と夜のルーチンを達成しよう")
    ]
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                // ランキングボックス
                GroupBox {
                    Text("ランキング")
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                        .fontWeight(.medium)
                        .font(.title3)
                    
                    ForEach(Array(sortedFriends.enumerated()), id: \.element.name) { index, friend in
                        GroupBox {
                            HStack {
                                Text("\(index+1)位")
                                    .font(.title3)
                                Spacer()
                                Text(friend.name)
                                Spacer()
                                Text("\(friend.score)point").font(.caption2)
                            }
                        }
                        .backgroundStyle(.white)
                    }
                }
                .compositingGroup()
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))                .padding()

                
                // Weeklyミッション
                GroupBox {
                    Text("ミッション")
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                        .fontWeight(.medium)
                        .font(.title3)
                    
                    ForEach(0..<mission.count, id: \.self) { index in
                        
                        GroupBox {
                            HStack {
                                Image(systemName: mission[index].checked ? "checkmark.circle.fill" : "circle")
                                Text("\(mission[index].kind)")
                                Spacer()
                            }
                        }
                        
                        /// checkedフラグを変更する
                        .onTapGesture {
                            mission[index].checked.toggle()
                        }
                    }
                    .backgroundStyle(.white)
                }
                .compositingGroup()
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .padding()
            }
            .padding()
        }
        
    }
    // ランキング表示のためのソート
    var sortedFriends: [Friend] {
        friends.sorted(by: { $0.score > $1.score })
    }
}

#Preview {
    MissionView()
}
