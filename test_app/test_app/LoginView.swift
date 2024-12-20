//
//  LoginView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/04.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLogin: Bool
    
    @State private var searchName = ""
    @State private var sarchPassword = ""
    
    @State private var name = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("Login")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                    Spacer()
                }
                TextField("名前", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none) // 入力フィールドの自動キャピタライズをオフ

                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("ログイン") {
                    searchName = name
                    sarchPassword = password
                    login()
                }
                .padding(.horizontal, 30.0)
                .padding(.vertical)
                .background(Color(red: 48/255, green: 178/255, blue: 127/255))
                .foregroundColor(.white)
                .cornerRadius(30)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                HStack {
                    Text("アカウントをお持ちでない方→")
                        .font(.system(size: 15))

                    NavigationLink(destination: SignupView(isLogin: $isLogin)) {
                        Text("サインアップ")
                            .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                            .underline()
                    }
                }
                .padding(.bottom)
            }
            .padding()
        }
    }

    func login() {
        guard let url = URL(string: "http://BOBnoMacBook-Pro.local:3000/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["name": searchName, "password": sarchPassword]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "通信エラー: \(error.localizedDescription)"
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    errorMessage = "不明なエラー"
                    return
                }

                guard response.statusCode == 200, let data = data else {
                    errorMessage = "ログイン失敗: 名前またはパスワードが正しくありません"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        UserDefaults.standard.set(token, forKey: "userToken")
                        isLogin = true
                    } else {
                        errorMessage = "サーバーからのレスポンスが不正です"
                    }
                } catch {
                    errorMessage = "データ解析エラー: \(error.localizedDescription)"
                }
            }
        }.resume()
    }


}




#Preview {
    @State var isLoginPreview = false
    return LoginView(isLogin: $isLoginPreview)
}
