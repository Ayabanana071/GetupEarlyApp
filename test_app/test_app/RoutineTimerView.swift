//
//  RoutineTimerView.swift
//  test_app
//
//  Created by ayana taba on 2024/07/05.
//

import SwiftUI
import AVFoundation

struct RoutineTimerView: View {
    var routine: [Routine]
    @State private var currentStepIndex: Int = 0
    @State private var remainingTime: Int
    @State private var timer: Timer?
    
    let soundPlayer = SoundPlayer()
    
    init(routine: [Routine]) {
        self.routine = routine
        self._remainingTime = State(initialValue: (routine.first?.duration ?? 0) * 60)
    }
    
    var body: some View {
        ScrollView{
            VStack {
                GroupBox{
                    Text(routine[currentStepIndex].title)
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    GroupBox {
    //                    Spacer()
                        Text(String(format: "%02d:%02d", remainingTime / 60, remainingTime % 60))
                            .font(.system(size: 64))
                            .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                            .padding(1)
                        
                        HStack {
                            Spacer()
                            Button(action: startTimer) {
                                Image(systemName: "play.fill")
                                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                            }
                            
                            ProgressView(value: Double(routine[currentStepIndex].duration * 60 - remainingTime), total: Double(routine[currentStepIndex].duration * 60))
                                .padding()
                                .frame(width: 200.0)
                                .tint(Color(red: 48/255, green: 178/255, blue: 127/255))
                            
                            
                            Button(action: pauseTimer) {
                                Image(systemName: "pause.fill")
                                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                                
                            }
                            Spacer()
                        }
                    }
                    .padding(.bottom)
    //                .frame(width: nil, height: 200.0)
                    .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                }
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .padding()
                
                
                GroupBox{
                    ForEach(0..<routine.count, id: \.self) { index in
                        HStack {
                            Text(routine[index].title)
                            Spacer()
                            Text("\(routine[index].duration)分")
                        }
                        .padding()
                        .background(index < currentStepIndex ? Color(red: 200/255, green: 223/255, blue: 214/255) : (index == currentStepIndex ? Color.yellow.opacity(0.5) : Color.white))
                        .cornerRadius(8)
                    }
                }
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .padding()
        }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 1 {
                remainingTime -= 1
            } else if remainingTime > 0 {
                remainingTime -= 1
                soundPlayer.routinePlay()
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
        Routine(title: "歯みがき", duration: 1),
        Routine(title: "朝ごはん作る", duration: 1),
        Routine(title: "食事する", duration: 15),
        Routine(title: "歯磨き", duration: 5),
        Routine(title: "着替える", duration: 5)
    ])
}

