//
//  HomeView.swift
//  test_app
//
//  Created by ayana taba on 2024/05/16.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = PointViewModel()
    
    @State var nowDate = Date()
    @State var dateText = ""
    private let dateFormatter = DateFormatter()
    @State private var currentTime: Date = Date()
    @State private var showRoutineTimer = false
    
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    @Binding var routines: [Routine]
    
    var point: CGFloat = 100
    
    init(wakeUpTime: Binding<Date>, bedTime: Binding<Date>, routines: Binding<[Routine]>) {
        _wakeUpTime = wakeUpTime
        _bedTime = bedTime
        _routines = routines
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Text(dateText.isEmpty ? "\(dateFormatter.string(from: nowDate))" : dateText)
                    .font(.system(size: 64))
                    .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            self.nowDate = Date()
                            dateText = "\(dateFormatter.string(from: nowDate))"
                        }
                    }
                    .padding(.top, 60)
                
                HStack{
                    Image(systemName: "sun.max.fill")
                        .foregroundStyle(.yellow)
                        .symbolRenderingMode(.multicolor)
                    Text("起床時間 : \(dateFormatter.string(from: wakeUpTime))")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Image(systemName: "sun.max.fill")
                        .foregroundStyle(.yellow)
                        .symbolRenderingMode(.multicolor)
                }
                HStack{
                    Image(systemName: "moon.stars.fill")
                        .foregroundStyle(.yellow)
                    Text("就寝時間 : \(dateFormatter.string(from: bedTime))")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Image(systemName: "moon.stars.fill")
                        .foregroundStyle(.yellow)
                }
                
                GroupBox{
                    Text("まりも")
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                    
                    GroupBox{
                        HStack{
                            Text("大きさ")
                            Spacer()
                            Text("\(viewModel.totalPoints) mm")
                        }
                    }
                    .backgroundStyle(.white)
                    
                    GroupBox{
                        ScrollView([.vertical, .horizontal]){
                            ZStack{
                                AqourBallView()
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Circle()
                                            .stroke(
                                                Color.accentColor,
                                                style:
                                                 StrokeStyle(
                                                     lineWidth: 2,
                                                     dash: [3, 3, 3, 3]
                                             )
                                            )
                                            .overlay(
                                                Image("MarimoFace")
                                                    .resizable()
                                                    .scaledToFill()
                                            )
                                            .frame(width: CGFloat(viewModel.totalPoints + 10))
                                            .padding()
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: 300, height: 200)
                    .backgroundStyle(Color("AqourColor"))
                    .cornerRadius(5)
                }
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .buttonStyle(PlainButtonStyle())
                .padding()
                .onAppear {
                    viewModel.fetchUserPoints()
                }
                
                GroupBox {
                    Text("朝のルーチン")
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
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
//                            .padding(.horizontal)
//                            .padding(.vertical, 2)
                        }
                    }
                }
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .buttonStyle(PlainButtonStyle())
                .padding([.leading, .bottom, .trailing])
                
                Spacer()
            }
            .padding([.leading, .bottom, .trailing])
            .sheet(isPresented: $showRoutineTimer) {
                RoutineTimerView(routine: routines)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    HomeView(wakeUpTime: .constant(Date()), bedTime: .constant(Date()), routines: .constant(Routine.sampleData))
}
