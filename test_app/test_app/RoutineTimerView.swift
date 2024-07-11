//
//  RoutineTimerView.swift
//  test_app
//
//  Created by ayana taba on 2024/07/05.
//

import SwiftUI

struct RoutineTimerView: View {
    var routine: [Routine]
    @State private var currentStepIndex: Int = 0
    @State private var remainingTime: Int
    @State private var timer: Timer?
    
    init(routine: [Routine]) {
        self.routine = routine
        self._remainingTime = State(initialValue: routine.first?.duration ?? 0 * 60) // 秒数に変換
    }
    
    var body: some View {
        VStack {
            GroupBox{
                Text(routine[currentStepIndex].title)
                    .font(.title3)
                    .padding()
                
                GroupBox {
                    Text(String(format: "%02d:%02d", remainingTime / 60, remainingTime % 60))
                        .font(.system(size: 64))
                        .foregroundColor(.green)
                        .padding()
                    
                    HStack {
                        Button(action: startTimer) {
                            Image(systemName: "play.fill")
                                .foregroundColor(.green)
                        }
                        
                        Button(action: pauseTimer) {
                            Image(systemName: "pause.fill")
                                .foregroundColor(.green)

                        }
                    }
                }
                .backgroundStyle(.white)
            }
            .backgroundStyle(.green.opacity(0.1))
            
            GroupBox{
                ForEach(0..<routine.count, id: \.self) { index in
                    HStack {
                        Text(routine[index].title)
                        Spacer()
                        Text("\(routine[index].duration)分")
                    }
                    .padding()
                    .background(index < currentStepIndex ? Color.green : (index == currentStepIndex ? Color.yellow : Color.white))
                    .cornerRadius(8)
                }
            }
            .backgroundStyle(.green.opacity(0.1))
            .padding()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                moveToNextStep()
            }
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }
    
    private func moveToNextStep() {
        if currentStepIndex < routine.count - 1 {
            currentStepIndex += 1
            remainingTime = routine[currentStepIndex].duration * 60
        } else {
            timer?.invalidate()
        }
    }
}

#Preview {
    RoutineTimerView(routine: [
        Routine(title: "歯磨き", duration: 5),
        Routine(title: "朝ごはん作る", duration: 10),
        Routine(title: "食事する", duration: 15),
        Routine(title: "歯磨き", duration: 5),
        Routine(title: "着替える", duration: 5)
    ])
}
