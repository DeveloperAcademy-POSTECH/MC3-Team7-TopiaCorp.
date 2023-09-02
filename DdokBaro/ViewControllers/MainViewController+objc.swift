//
//  Temp+objc.swift
//  DdokBaro
//
//  Created by yusang on 2023/09/02.
//

import Foundation
import UIKit

extension MainViewController {
    
    //설정한 시간동안 거북목일 경우 알람 울리게 한다
    @objc func turtleAlert() {
        //print("타이머 실험")
        NotificationManager().scheduleNotification()
        //Vibration.light.vibrate()
    }
    
    @objc func badSound(){
        playSound(soundName: "Drop", rate: 1.0)
    }
    
    @objc func haptic(){
        //hapticManager?.playPattern()
    }
    
    @objc func updateTimer(){
        let currentTime = Date()
        let elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
        
        let hour = Int(elapsedTime / 3600)
        let minute = Int((elapsedTime / 60).truncatingRemainder(dividingBy: 60))
        
        timeLabel.setupLabelAndButton(view: timeLabel, systemName: "clock", text: emptyString +  showhour + labelHour + showminute + labelMinute, imageColor: .pointBlue ?? .black, textColor: .pointBlue ?? .black, font: .boldSystemFont(ofSize: 28), pointSize: 28, weight: .bold)
        
        if minute >= 60 {
            let extraHours = minute / 60
            showhour = String(format:"%02d", minute + extraHours)
        } else {
            showhour = String(format: "%02d", minute)
        }
        showhour = String(format:"%02d", hour)
        showminute = String(format:"%02d", minute)
    }
    
    @objc func checkZero() {
        // if else로 모달뷰 띄울지
        if ZeroCheckModel.shared.zeroCheck {
            ZeroCheckModel.shared.zeroCheck = false
            accumulatedTime += Date().timeIntervalSince(startTime)
            createFailure()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let failViewController = storyboard.instantiateViewController(withIdentifier: "FailViewController") as? FailViewController {
                // Perform the segue programmatically
                navigationController?.pushViewController(failViewController, animated: true)
            }
        } else {
            //showModalView()
        }
    }
}
