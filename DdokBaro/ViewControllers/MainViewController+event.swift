//
//  Temp+envent.swift
//  DdokBaro
//
//  Created by yusang on 2023/09/01.
//

import Foundation
import CoreMotion
import Lottie
import UserNotifications
import UIKit

extension MainViewController {
    
    func turtleMotion(_ motion: CMDeviceMotion)
    {
        let pitch = degrees(motion.attitude.pitch)
        intPitch = degreeInt(pitch)
        //currentWeight = (pitch, degreeInt(pitch))
        //print(intPitch)
        DispatchQueue.main.async { [weak self] in
            if pitch > 0 {
                self?.animationView2.setProgress(currentProgress: AnimationProgressTime(0))
            }
            else {
                self?.animationView2.setProgress(currentProgress: AnimationProgressTime(max(-(pitch - userWeight.0)/40, 0)))
            }
            
            //만약 목 각도가 정해진 기준 이상이면(notgood - 1단계, bad - 2단계, danger - 3단계)
            if intPitch - userWeight.1 < angle.notgood.rawValue {
                
                self?.animationView3.setPlay()
                
                if self!.isPause {
                    self!.currentProgress -= self!.dropWhenBad * 0.00001
                }
                if self!.currentProgress <= 0 {
                    isZero = true
                    ZeroCheckModel.shared.zeroCheck = true
                    self!.currentProgress = 0
                    self!.createData()
                }
                
                self!.waterWaveView.setupProgress(self!.currentProgress)
                
                if intPitch - userWeight.1 < angle.bad.rawValue {
                    self?.animationView3.setStop()
                    self?.animationView4.setPlay()
                    
                    if !self!.isPause {
                        self!.currentProgress -= self!.dropWhenWorst * 0.00001
                    }
                    
                    self!.waterWaveView.setupProgress(self!.currentProgress)
                    
                    if self!.motionTimer.isValid {
                        
                    }
                    else {
                        self!.motionTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(self?.badSound), userInfo: nil, repeats: false)
                    }
                }
            }
            
            //만약 목 각도가 기준선 이하로 돌아오면 타이머 삭제
            else{
                self!.motionTimer.invalidate()
                //stopSound()
                self?.animationView4.setStop()
                self?.animationView3.setStop()
            }
        }
    }
    
    func stopDeviceMotionUpdates(){
        
    }

    //degree 텍스트 출력위해
    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", num)
    }
    
    //degree int로 바꿈
    func degreeInt(_ num: Double) -> Int {
        return Int(num)
    }
    
    //우리가 아는 각도로 바꿔주는 함수
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
}
