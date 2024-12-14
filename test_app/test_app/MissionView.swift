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
    var kind: String
    var checked: Bool
    var points: Int // 各ミッションに関連するポイント
}

struct MissionView: View {
    @StateObject private var pointViewModel = PointViewModel()
    
    @State var friends: [Friend] = [
        Friend(name: "喜納日菜妃", score: 30),
        Friend(name: "真栄喜楓鈴", score: 25),
        Friend(name: "津嘉山みやび", score: 10),
        Friend(name: "岸本志琉", score: 15),
        Friend(name: "島袋愛子", score: 5)
    ]
    
    @State private var mission: [Mission] = [
        Mission(kind: "決めた時間に起きよう", checked: false, points: 10),
        Mission(kind: "友達と同じ時間に起きよう", checked: false, points: 20),
        Mission(kind: "朝と夜のルーチンを達成しよう", checked: false, points: 30)
    ]
    @State private var totalPoints: Int = 0 // 合計ポイント
    
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
                        .onTapGesture {
                            // チェックフラグを切り替える
                            mission[index].checked.toggle()

                            // ポイントを加算または減算
                            if mission[index].checked {
                                totalPoints += mission[index].points
                                pointViewModel.createPointRecord(points: mission[index].points) // ポイントを送信
                            } else {
                                totalPoints -= mission[index].points
                                pointViewModel.createPointRecord(points: -mission[index].points) // 減算の場合はマイナスの値を送信
                            }
                        }
                        .backgroundStyle(.white)
                    }
                    .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
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
