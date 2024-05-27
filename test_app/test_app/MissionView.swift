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
        Friend(name: "きなひなき", score: 30),
        Friend(name: "みやびーむ", score: 25),
        Friend(name: "まえきかりん", score: 10),
        Friend(name: "あやばなな", score: 15),
        Friend(name: "あいこ氏", score: 5),
        Friend(name: "きんじょーこーき", score: 4),
        Friend(name: "ふなてぃあん", score: 20),
        Friend(name: "がじゃらいき", score: 10),
        Friend(name: "ゆいと", score: 22)
    ]
    
    @State var mission: [Mission] = [
        Mission("設定した時間に起きる"),
        Mission("友達と設定した時間に起きる"),
        Mission("朝のルーチンを達成する")
    ]
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                // ランキングボックス
                GroupBox {
                    Text("ランキング")
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
                            .frame(width: 260, height: 20.0)
                        }
                        .backgroundStyle(.white)
                    }
                }
                .compositingGroup()
                .backgroundStyle(.green.opacity(0.1))
                .shadow(color: .init(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 0, y: 3)
                .padding()

                
                // Weeklyミッション
                GroupBox {
                    Text("ミッション")
                        .font(.title3)
                    
                    ForEach(0..<mission.count, id: \.self) { index in
                        
                        GroupBox {
                            HStack {
                                Image(systemName: mission[index].checked ? "checkmark.circle.fill" : "circle")
                                Text("\(mission[index].kind)")
                                Spacer()
                            }
                            .frame(width: 260.0, height: 20.0)
                        }
                        
                        /// checkedフラグを変更する
                        .onTapGesture {
                            mission[index].checked.toggle()
                        }
                    }
                    .backgroundStyle(.white)
                }
                .compositingGroup()
                .backgroundStyle(.green.opacity(0.1))
                .shadow(color: .init(red: 197/255, green: 197/255, blue: 197/255), radius: 3, x: 0, y: 3)
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
