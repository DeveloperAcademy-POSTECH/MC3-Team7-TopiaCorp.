//
//  Temp+Connect.swift
//  DdokBaro
//
//  Created by yusang on 2023/09/02.
//

import Foundation
import CoreMotion
import Lottie
import UserNotifications
import UIKit

extension MainViewController {
    
    //에어팟 연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        dismiss(animated: true)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = false
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: "바른 자세를 유지해"))
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (text as NSString).range(of: "양동이의 물을 지켜주세요!"))
        self.titleLabel.attributedText = attributeString
        
        
        if isPause {
            print("일시정지 하고 빼고 꼈을때")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
            titleLabel.text = "아직은 휴식 시간!"
            titleLabel.textColor = .white
            titleLabel.numberOfLines = 0
            titleLabel.layer.zPosition = 1
        }
        else{
            print("일시정지 안하고 빼고 꼈을때")
            
            backGroundColor.setGradient2(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
            backGroundColor.layer.zPosition = -1
            
            self.view.addSubview(backGroundColor)
            self.view.sendSubviewToBack(backGroundColor)
            
            self.view.addSubview(animationView1)
            self.view.addSubview(animationView2)
            self.view.addSubview(animationView3)
            self.view.addSubview(animationView4)
            
            self.view.sendSubviewToBack(animationView1)
            self.view.sendSubviewToBack(animationView2)
            self.view.sendSubviewToBack(animationView3)
            self.view.sendSubviewToBack(animationView4)
            
            restView.removeFromSuperview()
            
            if notFirstConnect {
                startTime = Date() //현재 시간으로 업데이트
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: .common)
                isPaused = false
                startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 일시 정지", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
                audioPlayer.play()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.animationView1.setPlay()
            }
        }
        print("에어팟 연결 성공")
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        if nextView {
            nextView = false
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let noConnectionViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController")
            noConnectionViewController.modalPresentationStyle = .formSheet
            noConnectionViewController.isModalInPresentation = true
            self.present(noConnectionViewController, animated: true, completion: nil)
        }
        
        animationView1.setStop()
        
        backGroundColor.setGradient2(color1: .black, color2: UIColor(hexCode: "ECF2FF"))
        
        restView.frame = self.view.bounds
        restView.center = self.view.center
        
        self.view.addSubview(restView)
        self.view.sendSubviewToBack(restView)
        
        animationView1.removeFromSuperview()
        animationView2.removeFromSuperview()
        animationView3.removeFromSuperview()
        animationView4.removeFromSuperview()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = true
        
        if isPause{
            print("일시정지 하고 에어팟 연결 끊었을때")
            
        }else{
            print("여기는 일시정지 안하고 에어팟 연결 끊었을떄")
            timer.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isPaused = true
            notFirstConnect = true
            startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 다시 시작", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
            audioPlayer.pause()
        }
        print("에어팟 연결 끊김")
    }
}
