//
//  Sound.swift
//  DdokBaro
//
//  Created by yusang on 2023/07/21.
//

import Foundation
import AVFoundation
import AudioToolbox

private var player: AVAudioPlayer?

func playSound(soundName: String, rate: Float) {
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
        print("Error: Sound file not found.")
        return
    }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode:  AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.duckOthers])
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player?.enableRate = true
        player?.rate = rate
        player?.play()
    } catch let error {
        print(error.localizedDescription)
    }

}

func stopSound() {
    player?.stop()
    do {
        try AVAudioSession.sharedInstance().setActive(false)
    } catch {
        
    }
}

func zeroSound() {
    let soundID: SystemSoundID = 1000 // 1000은 표준 사운드
    
    AudioServicesPlaySystemSound(soundID)
}
