//
//  EarlyRiseViewModel.swift
//  test_app
//
//  Created by ayana taba on 2024/12/16.
//

import Foundation

struct WakeUpTime: Decodable {
    let hour: Int
    let minute: Int
}

struct TotalSuccessResponse: Codable {
    let totalSuccessCount: Int
}

class EarlyRiseViewModel: ObservableObject {
    @Published var wakeUpTimes: [DateComponents] = []
    
    @Published var totalSuccessCount: Int = 0
    @Published var errorMessage: String? = nil

    func fetchWakeUpTimes() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、トークンが見つかりませんでした")
            return
        }
        let url = URL(string: "http://localhost:3000/early_rises")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization") // トークンを設定

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([WakeUpTime].self, from: data)
                DispatchQueue.main.async {
                    self?.wakeUpTimes = decodedResponse.map {
                        DateComponents(hour: $0.hour, minute: $0.minute)
                    }
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

    func fetchTotalSuccessCount() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていない")
            errorMessage = "ログインしていない"
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/early_rises/total_success_count") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // トークンを設定

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Network error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid response from server"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // ここでキー変換を指定
                let decodedResponse = try decoder.decode(TotalSuccessResponse.self, from: data)
                DispatchQueue.main.async {
                    self.totalSuccessCount = decodedResponse.totalSuccessCount
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error: \(error)")
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
