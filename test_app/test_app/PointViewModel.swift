//
//  PointViewModel.swift
//  test_app
//
//  Created by ayana taba on 2024/12/13.
//
import Foundation

class PointViewModel: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var currentWeekPoints: [[String: Any]] = []
    @Published var weeklyPointsTotal: Int = 0
    @Published var errorMessage: String?

    func fetchUserPoints() {
        print("fetchUserPoints()を実行")
        
        // トークンをUserDefaultsから取得
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、ポイントを取得できません")
            errorMessage = "ログインしていないため、ポイントを取得できません"
            return
        }
        
        // APIエンドポイントを設定
        guard let url = URL(string: "http://localhost:3000/points") else {
            print("無効なURLです")
            errorMessage = "無効なURLです"
            return
        }
        
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
                        do {
                            // 取得したデータをデコード
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                self.totalPoints = json["total_points"] as? Int ?? 0
                                self.currentWeekPoints = json["current_week_points"] as? [[String: Any]] ?? []
                                self.weeklyPointsTotal = json["weekly_points_total"] as? Int ?? 0
                                DispatchQueue.main.async {
                                    self.errorMessage = nil // 成功時はエラーメッセージをリセット
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.errorMessage = "ポイントデータの解析に失敗しました"
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.errorMessage = "ポイントを取得できませんでした: ステータスコード \(httpResponse.statusCode)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "レスポンスが不正です"
                }
            }
        }.resume()
        
        print(errorMessage as Any)
    }

    func createPointRecord(points: Int) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、ポイントを作成できません")
            return
        }

        // APIエンドポイントを設定
        guard let url = URL(string: "http://localhost:3000/points") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // リクエストボディにポイント数を追加
        let body: [String: Any] = ["amount": points]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("リクエストボディの作成に失敗しました: \(error.localizedDescription)")
            return
        }

        // データタスクを作成してリクエストを送信
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("データがありません")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("ステータスコード: \(httpResponse.statusCode)")
                switch httpResponse.statusCode {
                case 201: // 成功時
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("ポイント作成成功: \(json)")
                        }
                    } catch {
                        print("データ解析に失敗しました: \(error.localizedDescription)")
                    }
                default:
                    print("ポイント作成に失敗しました: ステータスコード \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
