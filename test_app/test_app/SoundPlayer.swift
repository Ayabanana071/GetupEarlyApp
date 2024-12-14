//
//  SoundPlayer.swift
//  test_app
//
//  Created by ayana taba on 2024/12/13.
//

import AVFoundation
import UIKit

class SoundPlayer: NSObject{
    let routineData = NSDataAsset(name: "Routine_sound")!.data
    
    var routinePlayer: AVAudioPlayer!
    
    func routinePlay() {
        do {
            
            routinePlayer = try AVAudioPlayer(data: routineData)
            
            routinePlayer.play()
            
        } catch {
            print("ルーチンサウンドで、エラーが発生しました！")
        }
    }
}
