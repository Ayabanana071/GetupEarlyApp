//
//  SignupView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/09.
//

import SwiftUI

struct SignupView: View {
    @Binding var isLogin: Bool
    
    @State private var name = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("Signup")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                Spacer()
            }
            TextField("名前", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("パスワード（確認用）", text: $passwordConfirmation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("新規登録") {
                signup()
            }
            .padding(.horizontal, 15.0)
            .padding()
            .background(Color(red: 48/255, green: 178/255, blue: 127/255))
            .foregroundColor(.white)
            .cornerRadius(30)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
            }

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
            }
        }
        .padding(.bottom, 80.0)
        .padding(.horizontal)
    }

    func signup() {
//        guard let url = URL(string: "https://mysite-dv0d.onrender.com/signup") else { return }
        guard let url = URL(string: "http://BOBnoMacBook-Pro.local:3000/signup") else { return }
        print($password)
        print($passwordConfirmation)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "user": [
                "name": name,
                "password": password,
                "password_confirmation": passwordConfirmation
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                DispatchQueue.main.async {
                    successMessage = "新規登録が成功しました！"
                    name = ""
                    password = ""
                    passwordConfirmation = ""
                    isLogin = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                DispatchQueue.main.async {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let errors = json["errors"] as? [String] {
                        errorMessage = errors.joined(separator: "\n")
                    } else {
                        errorMessage = "新規登録に失敗しました。"
                    }
                }
            }
        }.resume()
    }
}


#Preview {
    @State var isLoginPreview = false
    return SignupView(isLogin: $isLoginPreview)
}
