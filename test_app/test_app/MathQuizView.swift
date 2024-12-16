//
//  MathQuizView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/16.
//

import SwiftUI

struct MathQuizView: View {
    @State private var questions: [(String, Int)] = [] // 問題と正解のペア
    @State private var userAnswers: [String] = ["", "", ""]
    @State private var isCorrect = false
    @State private var showResult = false
    @Environment(\.presentationMode) var presentationMode // シート制御用

    var body: some View {
        NavigationStack {
            VStack {
                ForEach(0..<questions.count, id: \.self) { index in
                    HStack {
                        Text(questions[index].0) // 問題文
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentColor)
                        Spacer()
                        TextField("答え", text: $userAnswers[index])
                            .foregroundColor(Color.accentColor)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }
                    .padding()
                }

                Button(action: {
                    checkAnswers()
                }) {
                    Text("提出する")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding()

                if showResult {
                    Text(isCorrect ? "正解です！" : "不正解です。")
                        .font(.title2)
                        .foregroundColor(isCorrect ? .green : .red)
                        .padding()
                }
            }
            .padding()
            .onAppear {
                generateQuestions()
            }
            .navigationBarTitle("おはようエクササイズ", displayMode: .inline)
            .toolbar { ToolbarItem(placement: .principal) {
                Text("おはようエクササイズ")
                    .fontWeight(.medium)
                    .foregroundColor(Color("MainColor"))
                    .font(.system(size: 18))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.green.opacity(0.3), for: .navigationBar)
        }
    }

    // 問題を生成
    private func generateQuestions() {
        questions = [
            createMathQuestion(),
            createMathQuestion(),
            createMathQuestion()
        ]
    }

    private func createMathQuestion() -> (String, Int) {
        let isAddition = Bool.random()
        let firstNumber = Int.random(in: 1...20)
        let secondNumber = Int.random(in: 1...20)

        if isAddition {
            return ("\(firstNumber) + \(secondNumber)", firstNumber + secondNumber)
        } else {
            let sortedNumbers = [firstNumber, secondNumber].sorted(by: >)
            return ("\(sortedNumbers[0]) - \(sortedNumbers[1])", sortedNumbers[0] - sortedNumbers[1])
        }
    }

    private func checkAnswers() {
        isCorrect = userAnswers.indices.allSatisfy { index in
            Int(userAnswers[index]) == questions[index].1
        }
        showResult = true

        if isCorrect {
            test_app.sendWakeUpTimeToServer(wakeUpTime: Date())
            test_app.rescheduleWakeUpNotifications()
            sendEarlyRiseRecord()
            presentationMode.wrappedValue.dismiss() // シートを閉じる
        }
    }
    
    private func sendEarlyRiseRecord() {
        let userDefaults = UserDefaults.standard
        
        guard let wakeUpTime = userDefaults.object(forKey: "wakeUpTime") as? Date else {
            print("起床時間が設定されていません")
            return
        }
        let clearedAt = Date()
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、起床記録を作成できません")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/early_rises") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // トークン認証を想定
        
        let recordData: [String: Any] = [
            "wake_up_time": ISO8601DateFormatter().string(from: wakeUpTime),
            "cleared_at": ISO8601DateFormatter().string(from: clearedAt)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: recordData, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("エラー: \(error)")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                print("サーバーエラー: \(String(describing: response))")
                return
            }

            print("早起き記録を保存しました")
        }.resume()
    }
}
#Preview {
    MathQuizView()
}


