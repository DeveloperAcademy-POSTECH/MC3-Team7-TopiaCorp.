//
//  MotionViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/13.
//

import UIKit
import CoreMotion
import Lottie
import UserNotifications

class MotionViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var Image: UIImageView!
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    private var timer = Timer()
    override func viewDidLoad() {
        NotificationManager().requestAuthorization()
        super.viewDidLoad()
        //var timerCounting:Bool = false
        textView.text = "에어팟 프로를 연결해주세요"
        
        //헤드폰 모니터링 할려면 delegate 대리자 필요
        manager.delegate = self
        
        print("권한 허가됨 ", CMAuthorizationStatus.authorized)
        
        manager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [self]
                (deviceMotion, error) -> Void in
                
                //if 에어팟 연결되었을때
                if let motion = deviceMotion {
                    
                    let attitude = motion.attitude
                    let roll = degrees(attitude.roll)
                    let pitch = degrees(attitude.pitch)
                    let yaw = degrees(attitude.yaw)
                    
                    let x = motion.attitude.quaternion.x
                    let y = motion.attitude.quaternion.y
                    let z = motion.attitude.quaternion.z
                    let w = motion.attitude.quaternion.w
                    let intpitch = degreeInt(pitch)
                    
                    //디스패치큐 사용해서 cpu효율적으로 사용, 디스패치큐는 딱히 사용할 필요는 없음
                    DispatchQueue.main.async { [self] in
                        var str = "Attitude:\n"
                        str += degreeText("Pitch 고개 위 아래", pitch)
                        str += degreeText("Roll 고개 꺽는거(근데 앞으로 빼도 수치가 좀 바뀜)", roll)
                        str += degreeText("Yaw 고개 옆으로 돌리는거 ", yaw)
                        
                        str += "\nQuaternion:\n"
                        str += quaternion(x, y, z, w)
                        textView.text = str
                    }
                    
                    if intpitch > 40 {
                        print("피치 40 이상")
                        if timer.isValid {
                            
                        }
                        else {
                            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(turtleAlert), userInfo: nil, repeats: false)
                            print("타이머 실행")
                            //timerCounting = true
                        }
                    }
                    else{
                        timer.invalidate()
                    }
                    
                    //                let animation = LottieAnimation.named("sample")
                    //                let animationView = LottieAnimationView(animation: animation)
                    //                self.view.addSubview(animationView)
                    //                animationView.frame = self.view.bounds
                    //                animationView.center = self.view.center
                    //                animationView.contentMode = .scaleAspectFit
                    //                animationView.animationSpeed = 1.0
                    //                animationView.play(fromFrame: AnimationFrameTime(intpitch)*2.7, toFrame: AnimationFrameTime(intpitch)*2.8)
                    
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
    
    //에어팟 연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결됨"
        print("에어팟 연결 성공")
    }
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결 끊김"
        print("에어팟 연결 끊김")
    }
    
    //우리가 아는 각도로 바꿔주는 함수
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    //Quaternion 값들 String으로 바꾸기
    func quaternion(_ x: Double, _ y: Double, _ z: Double, _ w: Double) -> String {
        // Absolute value just makes it look nicer
        var str = ""
        str += String(format: "X: %.1f\n", abs(x))
        str += String(format: "Y: %.1f\n", abs(y))
        str += String(format: "Z: %.1f\n", abs(z))
        str += String(format: "W: %.1f\n", abs(w))
        return str
    }
    
    //willappear - 다른 뷰에서 다시 올때 해주고 싶은 작업
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    //뷰가 사라질때 하고 싶은 작업
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopDeviceMotionUpdates()
    }
    
    //설정한 시간동안 거북목일 경우 알람 울리게 한다
    @objc func turtleAlert() {
        print("타이머 실험")
        NotificationManager().scheduleNotification()
    }
}


