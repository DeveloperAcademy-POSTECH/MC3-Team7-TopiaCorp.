//
//  MotionViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/13.
//

import UIKit
import CoreMotion
import Lottie

class MotionViewController: UIViewController, CMHeadphoneMotionManagerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //헤드폰 모니터링 할려면 delegate 대리자 필요
        manager.delegate = self
        
        print("권한 허가됨 ", CMAuthorizationStatus.authorized)
        
        manager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [self]
            (deviceMotion, error) -> Void in
         
            if let motion = deviceMotion {
                
                let attitude = motion.attitude
                let roll = degrees(attitude.roll)
                let pitch = degrees(attitude.pitch)
                let yaw = degrees(attitude.yaw)
                
                let intpitch = degreeInt(pitch)
                
                //디스패치큐 사용해서 실시간으로 바뀌는거 로딩없이 받을수 있게
                DispatchQueue.main.async { [self] in
                    var str = "Attitude:\n"
                    str += degreeText("Pitch 고개 위 아래", pitch)
                    str += degreeText("Roll 고개 꺽는거(근데 앞으로 빼도 수치가 좀 바뀜)", roll)
                    str += degreeText("Yaw 고개 옆으로 돌리는거 ", yaw)
                    textView.text = str

                    //animationView.play(fromFrame: AnimationFrameTime(intpitch)*2.5, toFrame: AnimationFrameTime(intpitch)*2.5)
                    //animationView.currentFrame = AnimationFrameTime(intpitch)
                    //print(animationView.animation?.endFrame)
                    
                    //animationView.loopMode = .loop
                    //animationView.animation?.endFrame
                    //animationView.currentFrame = pitch*2
                    //animationView.play(fromProgress: pitch, toProgress: pitch)
                }
                
                
                let animation = LottieAnimation.named("sample")
                let animationView = LottieAnimationView(animation: animation)
                self.view.addSubview(animationView)
                
                animationView.frame = self.view.bounds
                animationView.center = self.view.center
                animationView.contentMode = .scaleAspectFit
                
                //animationView.loopMode = .loop
                
                animationView.animationSpeed = 1.0
                //animationView.loopMode = .loop
                animationView.play(fromFrame: AnimationFrameTime(intpitch)*2.7, toFrame: AnimationFrameTime(intpitch)*2.8)
                
                //animationView.frame = intpitch
                //animationView.currentFrame = AnimationFrameTime(intpitch)
                //print(animationView.animation?.endFrame)
                
                
            } else {
                textView.text = "ERROR: \(error?.localizedDescription ?? "")"
            }
        })
        

    }
    //degree 텍스트 출력위해
    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", abs(num))
    }
    //degree int로 바꿈
    func degreeInt(_ num: Double) -> Int {
        return Int(abs(num))
    }
    
    //연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결됨"
        print("에어팟 연결 성공")
    }
    //연결 안됐을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결 안됨"
    }
    
    //우리가 아는 각도로 바꿔주는거
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    //willappear랑 disappear 이용하면 되돌릴수도 있을것 같아서 해보는중
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopDeviceMotionUpdates()
    }
}
