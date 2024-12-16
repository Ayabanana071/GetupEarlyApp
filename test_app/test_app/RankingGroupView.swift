//
//  RankingGroupView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/15.
//

import SwiftUI

struct Friend: Identifiable, Codable {
    var id: Int
    var name: String
    var score: Int
}

struct RankingGroupView: View {
    @State private var friends: [Friend] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            GroupBox {
                HStack{
                    Spacer()
                    Text("ランキング")
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                        .fontWeight(.medium)
                        .font(.title3)
                    Spacer()
                }

                ForEach(Array(sortedFriends.enumerated()), id: \.element.id) { index, friend in
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
            .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
            .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear(perform: fetchRanking)
    }
    
    func fetchRanking() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            self.errorMessage = "ログインしていません"
            return
        }

        guard let url = URL(string: "http://localhost:3000/rankings/weekly") else {
            self.errorMessage = "無効なURLです"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "データ取得に失敗しました: \(error.localizedDescription)"
                }
                return
            }

            if let data = data, let fetchedFriends = try? JSONDecoder().decode([Friend].self, from: data) {
                DispatchQueue.main.async {
                    self.friends = fetchedFriends
                    self.errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "データの解析に失敗しました"
                }
            }
        }.resume()
    }
    
    var sortedFriends: [Friend] {
        friends.sorted(by: { $0.score > $1.score })
    }
}

#Preview {
    RankingGroupView()
}
