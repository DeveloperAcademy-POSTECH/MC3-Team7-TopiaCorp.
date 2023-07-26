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
    
    var timer = Timer()
    
    var badSoundTimer = Timer()
    
    var dangerSoundTimer = Timer()
    
    var worstTimer = Timer()
    
    private var hapticManager: HapticManager?
    
    let animationView = LottieAnimationView(animation: LottieAnimation.named("TurtleBody"))
    
    let animationView2 = LottieAnimationView(animation: LottieAnimation.named("TurtleHead"))
    
    let animationView3 = LottieAnimationView(animation: LottieAnimation.named("WaterDrops1"))
    
    let animationView4 = LottieAnimationView(animation: LottieAnimation.named("WaterDrops2"))
    
    let animationView5 = LottieAnimationView(animation: LottieAnimation.named("WaterDrops3"))
    
    
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
        //헤드폰 모니터링 할려면 delegate 대리자 필요
        manager.delegate = self
        
        print("권한 허가됨 ", CMAuthorizationStatus.authorized)
        
        textView.text = "에어팟 프로를 연결해주세요"
        
        manager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [weak self] deviceMotion, error in guard let motion = deviceMotion, error == nil else { return }
                self?.turtleMotion(motion)
            }
        )
        
        animationView2.frame = self.view.bounds
        animationView2.center = self.view.center
        animationView2.contentMode = .scaleAspectFit
        animationView2.animationSpeed = 1.0
        self.view.addSubview(animationView2)
        
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        self.view.addSubview(animationView)
        
        animationView3.frame = self.view.bounds
        animationView3.center = self.view.center
        animationView3.contentMode = .scaleAspectFit
        self.view.addSubview(animationView3)
        //animationView3.stop()
        
        animationView4.frame = self.view.bounds
        animationView4.center = self.view.center
        animationView4.contentMode = .scaleAspectFit
        self.view.addSubview(animationView4)
        //animationView4.stop()
        
        animationView5.frame = self.view.bounds
        animationView5.center = self.view.center
        animationView5.contentMode = .scaleAspectFit
        self.view.addSubview(animationView5)
        //animationView5.stop()
        
        DispatchQueue.main.async { [weak self] in
            //거북이 몸통을 위에 겹치기 위해 여기에 작성
            self?.animationView.play()
        }
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
    
    func setTurtleImage(){
        
    }
    
    func turtleMotion(_ motion: CMDeviceMotion)
    {
        let pitch = degrees(motion.attitude.pitch)
        intPitch = degreeInt(pitch)
        
        //디스패치큐 사용
        DispatchQueue.main.async { [weak self] in
            
            if pitch > 0 {
                self?.animationView2.currentProgress = AnimationProgressTime(0)
            }
            else{
                self?.animationView2.currentProgress = AnimationProgressTime(-pitch/40)
            }
            
            //만약 목 각도가 정해진 기준 이상이면(notgood - 1단계, bad - 2단계, danger - 3단계)
            if self!.intPitch < angle.notgood.rawValue {
                self?.animationView3.play()
                
                if self!.intPitch < angle.bad.rawValue {
                    self?.animationView3.stop()
                    self?.animationView4.play()
                    
                    if self!.intPitch < angle.danger.rawValue {
                        self?.animationView4.stop()
                        self?.animationView5.play()
                    }
                    
                    if self!.timer.isValid {
                        
                    }
                    else {
                        self!.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self?.badSound), userInfo: nil, repeats: false)
                        //timerCounting = true
                    }
                }
            }
            //만약 목 각도가 기준선 이하로 돌아오면 타이머 삭제
            else{
                self!.timer.invalidate()
                stopSound()
                //self?.dangerSoundTimer.invalidate()
            }
        }
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
        animationView.play()
        print("에어팟 연결 성공")
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "에어팟 연결 끊김"
        animationView.stop()
        print("에어팟 연결 끊김")
    }
    
    //우리가 아는 각도로 바꿔주는 함수
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    //Quaternion 값들 String으로 바꾸기
    func quaternion(_ x: Double, _ y: Double, _ z: Double, _ w: Double) -> String {
        // Absolute value just makes it look nicer
        var str = ""
        str += String(format: "X: %.2f\n", x)
        return str
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
    @objc func haptic(){
        hapticManager?.playPattern()
    }
    
}



