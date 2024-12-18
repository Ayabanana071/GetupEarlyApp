//
//  MissionViewModel.swift
//  test_app
//
//  Created by ayana taba on 2024/12/15.
//


import Foundation
import Combine

struct TotalClearMissionsResponse: Codable {
    let totalClearMissionsCount: Int

    private enum CodingKeys: String, CodingKey {
        case totalClearMissionsCount = "total_clear_missions_count"
    }
}

class MissionViewModel: ObservableObject {
    @Published var morningMissions: [Mission] = []
    @Published var nightMissions: [Mission] = []
    @Published var currentMissions: [Mission] = []
    @Published var errorMessage: String?
    
    @Published var totalClearMissionsCount: Int = 0
    
    private let allMorningMissions = [
        Mission(kind: "決めた時間に起きよう", checked: false, points: 5),
        Mission(kind: "朝食を食べよう", checked: false, points: 2),
        Mission(kind: "軽い運動をしよう", checked: false, points: 5),
        Mission(kind: "水を一杯飲もう", checked: false, points: 2),
        Mission(kind: "寝起きにストレッチをしよう", checked: false, points: 4)
    ]
    private let allNightMissions = [
        Mission(kind: "寝る前にスマホを控えよう", checked: false, points: 5),
        Mission(kind: "翌日の計画を立てよう", checked: false, points: 2),
        Mission(kind: "リラックスする時間を持とう", checked: false, points: 3),
        Mission(kind: "早めに布団に入ろう", checked: false, points: 3),
        Mission(kind: "寝る前に軽い読書をしよう", checked: false, points: 5)
    ]

    private let userDefaults = UserDefaults.standard

    init() {
        loadMissions()
        updateCurrentMissions()
    }

    func loadMissions() {
        let today = Calendar.current.startOfDay(for: Date())
        if let lastUpdate = userDefaults.object(forKey: "lastMissionUpdate") as? Date,
           Calendar.current.isDate(today, inSameDayAs: lastUpdate) {
            if let savedMorning = userDefaults.object(forKey: "morningMissions") as? Data,
               let savedNight = userDefaults.object(forKey: "nightMissions") as? Data {
                morningMissions = (try? JSONDecoder().decode([Mission].self, from: savedMorning)) ?? []
                nightMissions = (try? JSONDecoder().decode([Mission].self, from: savedNight)) ?? []
            }
        } else {
            generateNewMissions()
        }
    }

    func saveMissions() {
        userDefaults.set(try? JSONEncoder().encode(morningMissions), forKey: "morningMissions")
        userDefaults.set(try? JSONEncoder().encode(nightMissions), forKey: "nightMissions")
        userDefaults.set(Date(), forKey: "lastMissionUpdate")
    }

    func generateNewMissions() {
        morningMissions = Array(allMorningMissions.shuffled().prefix(3))
        nightMissions = Array(allNightMissions.shuffled().prefix(3))
        saveMissions()
    }

    func updateCurrentMissions() {
        let hour = Calendar.current.component(.hour, from: Date())
        currentMissions = hour < 12 ? morningMissions : nightMissions
    }

    func toggleMissionChecked(_ mission: Mission) {
        // morningMissionsまたはnightMissionsの該当ミッションも更新する
        if let index = morningMissions.firstIndex(where: { $0.id == mission.id }) {
            morningMissions[index].checked.toggle()
        } else if let index = nightMissions.firstIndex(where: { $0.id == mission.id }) {
            nightMissions[index].checked.toggle()
        }
        
        // currentMissionsを更新して同期
        updateCurrentMissions()
        saveMissions()
    }
    
    // 達成済みのミッションを永続化するためのキー
    private let completedMissionsKey = "completedMissions"

    // 達成済みミッションのIDリストを保存
    private var completedMissionIDs: Set<UUID> {
        get {
            if let data = userDefaults.object(forKey: completedMissionsKey) as? Data,
               let ids = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
                return ids
            }
            return []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: completedMissionsKey)
        }
    }

    func isMissionCompleted(_ mission: Mission) -> Bool {
        return completedMissionIDs.contains(mission.id)
    }
    
    func sendMissionUpdateToServer(date: Date, completedCount: Int, totalPoints: Int) {
        print("sendMissionUpdateToServerを実行ーーーーーーーーー")
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、ポイントを取得できません")
            errorMessage = "ログインしていないため、ポイントを取得できません"
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/clear_missions") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "date": ISO8601DateFormatter().string(from: date),
            "completed_missions_count": completedCount,
            "total_points": totalPoints
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending mission data: \(error.localizedDescription)")
                return
            }
            print("Mission data sent successfully.")
        }.resume()
    }
    
    func fetchTotalClearMissionsCount() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("ログインしていないため、ミッション数を取得できません")
            errorMessage = "ログインしていないため、ポイントを取得できません"
            return
        }
        guard let url = URL(string: "http://localhost:3000/clear_missions/total_clear_missions_count") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        self.errorMessage = "Invalid response code: \(httpResponse.statusCode)"
                        return
                    }
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(TotalClearMissionsResponse.self, from: data)
                    self.totalClearMissionsCount = decodedResponse.totalClearMissionsCount
                    print("Total Clear Missions Count: \(decodedResponse.totalClearMissionsCount)")
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    print()
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

}
