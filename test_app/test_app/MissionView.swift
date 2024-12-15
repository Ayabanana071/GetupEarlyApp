//
//  MissionView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/23.
//

import SwiftUI

struct MissionView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack{
                // ランキングボックス
                RankingGroupView()                
                // Weeklyミッション
                MissionGroupView()
            }
            .padding()
        }
    }
}

#Preview {
    MissionView()
}
