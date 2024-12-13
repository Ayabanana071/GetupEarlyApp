//
//  AqourBallView.swift
//  test_app
//
//  Created by ayana taba on 2024/12/13.
//

import SwiftUI

struct AqourBallView: View {
    // アニメーション
    @State private var scale: CGFloat = 1.0
    @State private var offsetY1: CGFloat = 0.0
    @State private var offsetY2: CGFloat = 0.0
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "circle")
                    .offset(y: offsetY1) // Y軸のオフセットを設定
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), // 永続的なアニメーション
                        value: offsetY1
                    )
                    .onAppear {
                        offsetY1 = -10 // アニメーション開始時の移動量
                    }
                    .foregroundColor(.blue.opacity(0.3))
                    .scaleEffect(scale) // スケールを変更してパルスを表現
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 1.1 // アニメーション開始時にスケールを変更
                    }
                    .padding()
            }
            .padding(.trailing, 150.0)
            
            HStack{
                Image(systemName: "circle")
                    .offset(y: offsetY2) // Y軸のオフセットを設定
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), // 永続的なアニメーション
                        value: offsetY2
                    )
                    .onAppear {
                        offsetY2 = 10 // アニメーション開始時の移動量
                    }
                    .foregroundColor(.blue.opacity(0.3))
                    .scaleEffect(scale) // スケールを変更してパルスを表現
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 1.1 // アニメーション開始時にスケールを変更
                    }
                    .padding()
                Spacer()
            }
            .padding(.leading, 150.0)
        }

    }
}

#Preview {
    AqourBallView()
}
