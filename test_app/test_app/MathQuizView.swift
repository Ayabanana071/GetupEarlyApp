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
                Text("提出")
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
            rescheduleWakeUpNotifications()
            presentationMode.wrappedValue.dismiss() // シートを閉じる
        }
    }

    private func sendWakeUpTimeToServer() {
        print("起床時間をサーバーに送信しました")
    }

    private func rescheduleWakeUpNotifications() {
        print("通知を再スケジュールしました")
    }
}

#Preview {
    MathQuizView()
}


