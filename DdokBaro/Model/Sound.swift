//
//  Sound.swift
//  DdokBaro
//
//  Created by yusang on 2023/07/21.
//

import Foundation
import AVFoundation

private var player: AVAudioPlayer?

enum Sound: String {
    case drop = "Drop"
    case rain = "Rain"
}

func playSoundDrop() {
    let soundName = Sound.drop.rawValue
    
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
        return
    }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        // print error...
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player?.numberOfLoops = -1
        player?.play()
        //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode:  AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
    } catch let error {
        print(error.localizedDescription)
    }
}

func playSoundRain() {
    let soundName2 = Sound.rain.rawValue
    
    guard let url = Bundle.main.url(forResource: soundName2, withExtension: "mp3") else {
        return
    }
    
    do {
        //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode:  AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        // print error...
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        //player?.numberOfLoops = -1
        player?.play()
        print("플레이 되는중")
//        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode:  AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopSound() {
    player?.stop()
}


