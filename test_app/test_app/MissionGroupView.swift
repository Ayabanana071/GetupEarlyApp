//
//  MissionGroupView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/15.
//

import SwiftUI

struct Mission: Identifiable, Codable {
    var id = UUID()
    var kind: String
    var checked: Bool
    var points: Int // 各ミッションに関連するポイント
}

struct MissionGroupView: View {
    @StateObject private var missionViewModel = MissionViewModel()
    @StateObject private var pointViewModel = PointViewModel()
    @State private var totalPoints: Int = 0

    var body: some View {
        GroupBox {
            Text("ミッション")
                .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                .fontWeight(.medium)
                .font(.title3)

            ForEach(missionViewModel.currentMissions) { mission in
                GroupBox {
                    HStack {
                        Image(systemName: mission.checked ? "checkmark.circle.fill" : "circle")
                        Text(mission.kind)
                        Spacer()
                        Text("\(mission.points) point").font(.caption2)
                    }
                }
                .onTapGesture {
                    let wasChecked = mission.checked
                    missionViewModel.toggleMissionChecked(mission)

                    // ポイントを送信
                    if !wasChecked {
                        totalPoints += mission.points
                        pointViewModel.createPointRecord(points: mission.points) // ポイント加算
                    } else {
                        totalPoints -= mission.points
                        pointViewModel.createPointRecord(points: -mission.points) // ポイント減算
                    }
                    
                    missionViewModel.sendMissionUpdateToServer(
                        date: Date(),
                        completedCount: missionViewModel.currentMissions.filter { $0.checked }.count,
                        totalPoints: totalPoints
                    )
                }
                .backgroundStyle(.white)
            }
            .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
        }
        .compositingGroup()
        .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
        .padding()
        .onAppear {
            missionViewModel.updateCurrentMissions()
        }
    }
}

#Preview {
    MissionGroupView()
}
