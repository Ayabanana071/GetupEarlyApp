//
//  FriendView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/23.
//

import SwiftUI

struct FriendView: View {
    @State private var friends: [User] = []
    @State private var isAddingFriend = false
    @State private var errorMessage: String? = nil // エラーメッセージ用

    var body: some View {
        ZStack{
            VStack {
                List(friends, id: \.id) { friend in
                    HStack{
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 40))
                            .foregroundColor(Color("AccentColor").opacity(0.3))
                        Text(friend.name)
                            .foregroundColor(Color("AccentColor"))
                            .fontWeight(.semibold)
                            .padding()
                    }
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(5)
                    .listRowBackground(Color.white)
                }
                .onAppear(perform: fetchFriends)
                .listStyle(.plain)
                .listRowSeparatorTint(Color("MainColor"))
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        print("Button")
                        isAddingFriend = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .padding()
                            .foregroundColor(Color("AccentColor"))
                    }
                    .sheet(isPresented: $isAddingFriend) {
                        AddFriendView(isPresented: $isAddingFriend)
                    }
                }
            }
        }
    }

    func fetchFriends() {
        print("fetchFriends()を実行")
        
        // トークンをUserDefaultsから取得
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、フレンドを取得できません")
            errorMessage = "ログインしていないため、フレンドを取得できません"
            return
        }
        
        // APIエンドポイントを設定
        guard let url = URL(string: "http://localhost:3000/friends") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Authorizationヘッダーにトークンを設定
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // データタスクを作成し、リクエストを送信
        URLSession.shared.dataTask(with: request) { data, response, error in
            // エラーチェック
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "エラーが発生しました: \(error.localizedDescription)"
                }
                return
            }

            // レスポンスのステータスコードをチェック
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                        if let fetchedFriends = try? JSONDecoder().decode([User].self, from: data) {
                            DispatchQueue.main.async {
                                self.friends = fetchedFriends
                                self.errorMessage = nil // 成功時はエラーメッセージをリセット
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "フレンドの情報を取得できませんでした"
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.errorMessage = "フレンドを取得できませんでした: ステータスコード \(httpResponse.statusCode)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "レスポンスが不正です"
                }
            }
        }.resume()
    }
}


#Preview {
    FriendView()
}
