//
//  LoginView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/04.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLogin: Bool
    
    @State private var name = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    Spacer()
                    Text("Login")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                    Spacer()
                }
                TextField("名前", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("ログイン") {
                    login()
                }
                .padding(.horizontal, 15.0)
                .padding()
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

                    NavigationLink(destination: SignupView()) {
                        Text("サインアップ")
                            .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                            .underline()
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }

    func login() {
        guard let url = URL(string: "http://localhost:3000/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["name": name, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("ログイン成功: \(String(data: data, encoding: .utf8) ?? "")")
                    isLogin = true
                } else {
                    errorMessage = "ログイン失敗: 名前またはパスワードが正しくありません"
                }
            }
        }.resume()
    }
}




#Preview {
    @State var isLoginPreview = false
    return LoginView(isLogin: $isLoginPreview)
}
