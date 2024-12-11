//
//  AddFriendView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/10.
//

import SwiftUI

struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

struct AddFriendView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [User] = []
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                TextField("ユーザーを検索", text: $searchQuery, onCommit: search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(searchResults, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        Button("追加") {
                            print("フレンドを追加ボタンを押した")
                            addFriend(user: user)
                        }
                        .foregroundColor(.blue)
                    }
                }

                Spacer()
            }
            .navigationTitle("フレンド追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
            }
        }
    }

    func search() {
        guard let url = URL(string: "http://localhost:3000/users?query=\(searchQuery)") else { return }
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token"), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let users = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    self.searchResults = users
                }
            }
        }.resume()
    }

    func addFriend(user: User) {
        // トークンをUserDefaultsから取得
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Token not found")
            return
        }
        
        // APIエンドポイントを設定
        guard let url = URL(string: "http://localhost:3000/friends") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Authorizationヘッダーにトークンを設定
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // リクエストボディの設定
        let body = ["friend_id": user.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // データタスクを作成し、リクエストを送信
        URLSession.shared.dataTask(with: request) { data, response, error in
            // エラーチェック
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // レスポンスのステータスコードに基づいて処理
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    print("Friend added successfully")
                case 422:
                    print("Failed to add friend: Invalid user or friend cannot be yourself")
                default:
                    print("Failed to add friend with status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

}

#Preview {
    @State var isPresented = false
    return AddFriendView(isPresented: $isPresented)
}
