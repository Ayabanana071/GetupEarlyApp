//
//  CharacterView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/13.
//

import SwiftUI

struct CharacterView: View {
    var body: some View {
        ZStack {
            // キャラクターの緑色の本体
            Circle()
                .fill(Color("MainColor"))
                .frame(width: 150, height: 150)
                .overlay(
                    Circle()
                        .stroke(Color("MainColor").opacity(0.8), lineWidth: 5)
                        .blur(radius: 2)
                )

            // 顔のパーツ
            VStack(spacing: 10) {
                // 目
                HStack(spacing: 40) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 15, height: 15)

                    Circle()
                        .fill(Color.black)
                        .frame(width: 15, height: 15)
                }
                HStack{
                    Spacer()
                    // 口
                    Path { path in
                        path.move(to: CGPoint(x: 55, y: 90))
                        path.addQuadCurve(to: CGPoint(x: 95, y: 90), control: CGPoint(x: 75, y: 110))
                    }
                    .stroke(Color.black, lineWidth: 3)
                    
                    Spacer()
                }

            }
        }
    }
}

struct ContentsView: View {
    var body: some View {
        CharacterView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white) // 背景色
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentsView()
}

