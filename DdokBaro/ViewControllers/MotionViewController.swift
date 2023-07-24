//
//  MotionViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/13.
//

import Combine
import UIKit
import CoreMotion
import Lottie
import UserNotifications
import CoreHaptics

class MotionViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var turtleimage: UIImageView!
    
    var intPitch: Int = 0
    
    var rabbit:Bool = false
    
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    
    var badSoundTimer = Timer()
    
    var dangerSoundTimer = Timer()
    
    var worstTimer = Timer()
    
    private var timer = Timer()
    
    private var hapticManager: HapticManager?
    
    enum angle: Int {
        case notgood = -10
        case bad = -20
        case danger = -30
        case worst = -40
    }
    
    override func viewDidLoad() {
        hapticManager = HapticManager()
        
        NotificationManager().requestAuthorization()
        super.viewDidLoad()
        textView.text = "에어팟 프로를 연결해주세요"
        
        let animation = LottieAnimation.named("TurtleBody")
        let animationView = LottieAnimationView(animation: animation)
        
        let animation2 = LottieAnimation.named("TurtleHead")
        let animationView2 = LottieAnimationView(animation: animation2)
        
        let animation3 = LottieAnimation.named("WaterDrops1")
        let animationView3 = LottieAnimationView(animation: animation3)
        
        let animation4 = LottieAnimation.named("WaterDrops2")
        let animationView4 = LottieAnimationView(animation: animation4)
        
        let animation5 = LottieAnimation.named("WaterDrops3")
        let animationView5 = LottieAnimationView(animation: animation5)
        
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
                    intPitch = degreeInt(pitch)
                    
                    //디스패치큐 사용해서 cpu효율적으로 사용, 디스패치큐는 딱히 사용할 필요는 없음
                    DispatchQueue.main.async { [self] in
                        var str = "Attitude:\n"
                        str += degreeText("Pitch 고개 위 아래", pitch)
                        str += degreeText("Roll 고개 꺽는거(근데 앞으로 빼도 수치가 좀 바뀜!!)", roll)
                        str += degreeText("Yaw 고개 옆으로 돌리는거 ", yaw)
                        
                        str += "\nQuaternion:\n"
                        str += quaternion(x, y, z, w)
                        textView.text = str
                        
                        self.view.addSubview(animationView2)
                        animationView2.frame = self.view.bounds
                        animationView2.center = self.view.center
                        animationView2.contentMode = .scaleAspectFit
                        animationView2.animationSpeed = 1.0
                        
                        if pitch > 0 {
                            animationView2.currentProgress = AnimationProgressTime(0)
                        }
                        else{
                            animationView2.currentProgress = AnimationProgressTime(-pitch/40)
                        }
                        
                        self.view.addSubview(animationView)
                        
                    }
                    
                    
                    //만약 목 각도가 정해진 기준 이상이면(notgood - 1단계, bad - 2단계, danger - 3단계)
                    if intPitch < angle.notgood.rawValue {
                        self.view.addSubview(animationView3)
                        animationView3.frame = self.view.bounds
                        animationView3.center = self.view.center
                        animationView3.contentMode = .scaleAspectFit
                        animationView3.play()
                        
                        if intPitch < angle.bad.rawValue {
                            self.view.addSubview(animationView4)
                            //animationView4.transform.rotated(by: degrees(90))
                            animationView4.frame = self.view.bounds
                            animationView4.center = self.view.center
                            animationView4.contentMode = .scaleAspectFit
                            animationView3.stop()
                            //customHaptics.turtlehaptic()
                            animationView4.play()
                            if badSoundTimer.isValid {
                                
                            }
                            else {
                                badSoundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(badSound), userInfo: nil, repeats: false)
                            }
                            
                            if intPitch < angle.danger.rawValue {
                                badSoundTimer.invalidate()
                                self.view.addSubview(animationView5)
                                animationView5.frame = self.view.bounds
                                animationView5.center = self.view.center
                                animationView5.contentMode = .scaleAspectFit
                                animationView4.stop()
                                animationView5.play()
                                if dangerSoundTimer.isValid {
                                    
                                }
                                else {
                                    dangerSoundTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(dangerSound), userInfo: nil, repeats: false)
                                }
                            }
                            
                        }
                        
                        
                        if timer.isValid {
                            
                        }
                        else {
                            timer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(turtleAlert), userInfo: nil, repeats: false)
                            //print("타이머 실행")
                            //timerCounting = true
                        }
                    }
                    
                    //만약 목 각도가 기준선 이하로 돌아오면 타이머 삭제
                    else{
                        timer.invalidate()
                        
                        stopSound()
                        dangerSoundTimer.invalidate()
                    }
                    
                } else {
                    textView.text = "ERROR: \(error?.localizedDescription ?? "")"
                }
                
            })
        
        //거북이 몸통을 위에 겹치기 위해 여기에 작성
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        animationView.play()
        
    }
    
    //degree 텍스트 출력위해
    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", num)
    }
    
    //degree int로 바꿈
    func degreeInt(_ num: Double) -> Int {
        return Int(num)
    }
    
    //에어팟 연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결 성공"
        print("에어팟 연결 성공")
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결 끊김"
        rabbit = true
        print(rabbit)
        print("에어팟 연결 끊김")
    }
    
    //우리가 아는 각도로 바꿔주는 함수
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    //Quaternion 값들 String으로 바꾸기
    func quaternion(_ x: Double, _ y: Double, _ z: Double, _ w: Double) -> String {
        // Absolute value just makes it look nicer
        var str = ""
        str += String(format: "X: %.2f\n", x)
        str += String(format: "Y: %.2f\n", y)
        str += String(format: "Z: %.2f\n", z)
        str += String(format: "W: %.2f\n", w)
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
        //print("타이머 실험")
        NotificationManager().scheduleNotification()
        //Vibration.light.vibrate()
    }
    @objc func badSound(){
        playSound(soundName: "Drop", rate: 1.0)
    }
    @objc func dangerSound(){
        playSound(soundName: "Drop", rate: 1.0)
    }
    @objc func haptic(){
        hapticManager?.playPattern()
    }
}
    


