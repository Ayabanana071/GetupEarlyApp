//
//  HomeView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/16.
//

import SwiftUI

struct HomeView: View {
    @State var nowDate = Date()
    @State var dateText = ""
    private let dateFormatter = DateFormatter()
    @State private var currentTime: Date = Date()
    
    @Binding var wakeUpTime: Date
        @Binding var bedTime: Date
    
    init(wakeUpTime: Binding<Date>, bedTime: Binding<Date>) {
        _wakeUpTime = wakeUpTime
        _bedTime = bedTime
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View {
        VStack {
            Text(dateText.isEmpty ? "\(dateFormatter.string(from: nowDate))" : dateText)
//                .font(.title)
                .font(.system(size: 64))
                .foregroundColor(.green)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.nowDate = Date()
                        dateText = "\(dateFormatter.string(from: nowDate))"
                    }
                }
                .padding(.top,60)
            Text("☀️起床時間 : \(dateFormatter.string(from: wakeUpTime))")
                .font(.title2)
                .foregroundColor(.gray)
 
            Text("🌙就寝時間 : \(dateFormatter.string(from: bedTime))")
                .font(.title2)
                .foregroundColor(.gray)
            
            GroupBox{
                Text("朝のルーチン")
                GroupBox{
                    Text("ルーチン１")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .backgroundStyle(.white)
            }
            .backgroundStyle(.green.opacity(0.1))
            .padding()
            
            
            Spacer()
        }
    }
}

#Preview {
    HomeView(wakeUpTime: .constant(Date()), bedTime: .constant(Date()))
}
