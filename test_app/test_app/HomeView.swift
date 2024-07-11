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
    @State private var showRoutineTimer = false
    
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    @Binding var routines: [Routine]
    
    init(wakeUpTime: Binding<Date>, bedTime: Binding<Date>, routines: Binding<[Routine]>) {
        _wakeUpTime = wakeUpTime
        _bedTime = bedTime
        _routines = routines
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View {
        VStack {
            Text(dateText.isEmpty ? "\(dateFormatter.string(from: nowDate))" : dateText)
                .font(.system(size: 64))
                .foregroundColor(.green)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.nowDate = Date()
                        dateText = "\(dateFormatter.string(from: nowDate))"
                    }
                }
                .padding(.top, 60)
            
            Text("☀️起床時間 : \(dateFormatter.string(from: wakeUpTime))")
                .font(.title2)
                .foregroundColor(.gray)
 
            Text("🌙就寝時間 : \(dateFormatter.string(from: bedTime))")
                .font(.title2)
                .foregroundColor(.gray)
            
            GroupBox {
                Text("朝のルーチン")
//                    .font(.headline)
                
                ForEach(routines) { routine in
                    Button(action: {
                        showRoutineTimer = true
                    }) {
                        HStack {
                            Text(routine.title)
                            Spacer()
                            Text("\(routine.duration)分")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
//                        .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .backgroundStyle(.green.opacity(0.1))
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $showRoutineTimer) {
            RoutineTimerView(routine: routines)
        }
    }
}

#Preview {
    HomeView(wakeUpTime: .constant(Date()), bedTime: .constant(Date()), routines: .constant(Routine.sampleData))
}
