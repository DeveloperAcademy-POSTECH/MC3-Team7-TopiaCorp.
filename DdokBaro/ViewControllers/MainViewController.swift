//
//  MainViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit
import CoreHaptics
import CoreMotion
import Lottie
import UserNotifications

enum SFSymbolKey: String {
    case pause = "pause.circle"
    case stop = "xmark.circle.fill"
    case clock = "clock"
}

class MainViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    var showhour = "00"
    var showminute = "00"
    let labelHour = " 시간 "
    let labelMinute = " 분"
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    
    var currentWeight = (0.0, 0.0, 0.0, 0.0, 0.0, 0) // 현재 측정 각도
    var userWeight = (0.0, 0.0, 0.0, 0.0, 0.0, 0) // 사용자 설정 가중치
    
    let screenWidth = UIScreen.main.bounds.size.width
    let waterWaveView = WaterWaveView()
    var currentProgress: CGFloat = 1.0 // 현재 물의 양 0.0 ~ 1.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circleView: CircleViewController!
    
    var intPitch: Int = 0
    var rabbit:Bool = false
    
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    var customHaptics: CustomHaptics!
    private var motionTimer = Timer()
    
    enum angle: Int {
        case notgood = -10
        case bad = -20
        case danger = -30
        case worst = -40
    }
    
    let dropWhenBad: CGFloat = 5.0
    let dropWhenDanger: CGFloat = 10.0
    let dropWhenWorst: CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // timer view controller
        let circleView = CircleViewController()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        titleLabel.numberOfLines = 0
        timeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        self.changeTextColor()
        
        view.addSubview(circleView)
        self.view.sendSubviewToBack(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 390),
            circleView.heightAnchor.constraint(equalToConstant: 250),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
        ])
        startTimer()
        updateTimer()
        
        // water view controller
        view.addSubview(waterWaveView)
        waterWaveView.setupProgress(waterWaveView.progress)
        
        NSLayoutConstraint.activate([
            waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
        ])
        
        let totalPath = UIBezierPath()
        
        let width = screenWidth*0.5
        let height = screenWidth*0.5
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let startPoint = CGPoint(x: width / 2, y: height / 20)
        
        totalPath.move(to: startPoint)
        totalPath.addArc(withCenter: center, radius: width * 9 / (20 * sqrt(2.0)),
                         startAngle: 5 * (.pi / 4), endAngle: 7 * (.pi / 4), clockwise: false)
        totalPath.addLine(to: startPoint)
        totalPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = totalPath.cgPath
        waterWaveView.layer.mask = maskLayer
        
        // motion view controller
        NotificationManager().requestAuthorization()
        
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
                    
                    currentWeight = (x, y, z, w, pitch, degreeInt(pitch))
                    
                    //디스패치큐 사용해서 cpu효율적으로 사용, 디스패치큐는 딱히 사용할 필요는 없음
                    DispatchQueue.main.async { [self] in
                        var str = "Attitude:\n"
                        str += degreeText("Pitch 고개 위 아래", pitch)
                        str += degreeText("Roll 고개 꺽는거(근데 앞으로 빼도 수치가 좀 바뀜!!)", roll)
                        str += degreeText("Yaw 고개 옆으로 돌리는거 ", yaw)
                        
                        str += "\nQuaternion:\n"
                        str += quaternion(x, y, z, w)
                        
                        self.view.addSubview(animationView2)
                        animationView2.frame = self.view.bounds
                        animationView2.center = self.view.center
                        animationView2.contentMode = .scaleAspectFit
                        animationView2.animationSpeed = 1.0
                        
                        if pitch > 0 {
                            animationView2.currentProgress = AnimationProgressTime(0)
                        }
                        else{
                            animationView2.currentProgress = AnimationProgressTime(max(-(pitch - userWeight.4)/40, 0))
                        }
                        self.view.addSubview(animationView)
                    }
                    
                    
                    //만약 목 각도가 정해진 기준 이상이면(notgood - 1단계, bad - 2단계, danger - 3단계)
                    if intPitch - userWeight.5 < angle.notgood.rawValue {
                        self.view.addSubview(animationView3)
                        animationView3.frame = self.view.bounds
                        animationView3.center = self.view.center
                        animationView3.contentMode = .scaleAspectFit
                        animationView3.play()
                        customHaptics?.turtlehaptic()
                        currentProgress -= dropWhenBad * 0.00001
                        self.waterWaveView.setupProgress(currentProgress)
                        
                        if intPitch - userWeight.5 < angle.bad.rawValue {
                            self.view.addSubview(animationView4)
                            //animationView4.transform.rotated(by: degrees(90))
                            animationView4.frame = self.view.bounds
                            animationView4.center = self.view.center
                            animationView4.contentMode = .scaleAspectFit
                            animationView3.stop()
                            //customHaptics.turtlehaptic()
                            //animationView4.play()
                            currentProgress -= dropWhenWorst * 0.00001
                            self.waterWaveView.setupProgress(currentProgress)
                            
                            if intPitch - userWeight.5 < angle.danger.rawValue {
                                self.view.addSubview(animationView5)
                                //animationView5.frame = self.view.bounds
                                //animationView5.center = self.view.center
                                //animationView5.contentMode = .scaleAspectFit
                                animationView4.stop()
                                //animationView5.play()
                                currentProgress -= dropWhenDanger * 0.00001
                                self.waterWaveView.setupProgress(currentProgress)
                            }
                            
                        }
                        
                        
                        if motionTimer.isValid {
                            
                        }
                        else {
                            motionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(turtleAlert), userInfo: nil, repeats: false)
                            print("타이머 실행")
                            //timerCounting = true
                        }
                    }
                    
                    //만약 목 각도가 기준선 이하로 돌아오면 타이머 삭제
                    else{
                        motionTimer.invalidate()
                        stopSound()
                    }
                    
                } else {
                    print("ERROR: \(error?.localizedDescription)")
                }
                
            })
        
        //거북이 몸통을 위에 겹치기 위해 여기에 작성
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        animationView.play()
        self.view.sendSubviewToBack(animationView)
    }
    
    //MARK: timer view controller
    
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (text as NSString).range(of: "양동이의 물을 지켜주세요!"))
        self.titleLabel.attributedText = attributeString
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        if isPaused {
            startTime = Date() //현재 시간으로 업데이트
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            isPaused = false
            startPauseButton.setTitle("일시 정지", for: .normal)
            
        } else {
            timer.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isPaused = true
            startPauseButton.setTitle("다시 시작", for: .normal)
        }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        self.timer.invalidate()
        showhour = "00"
        showminute = "00"
        self.timeLabel.text = showhour + labelHour + showminute + labelMinute
        startPauseButton.setTitle("다시 시작", for: .normal)
        self.startTime = Date()
        isPaused = true
        accumulatedTime = 0.0
    }
    
    @objc private func updateTimer(){
        let currentTime = Date()
        let elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
        
        let hour = Int(elapsedTime / 60)
        let minute = Int((elapsedTime).truncatingRemainder(dividingBy: 60))
        
        if minute >= 60 {
            let extraHours = minute / 60
            showhour = String(format:"%02d", minute + extraHours)
            self.timeLabel.text = showhour + labelHour + showminute + labelMinute
        } else {
            showhour = String(format: "%02d", minute)
            self.timeLabel.text = showhour + labelHour + showminute + labelMinute
        }
        showhour = String(format:"%02d", hour)
        self.timeLabel.text = showhour + labelHour + showminute + labelMinute
        
        showminute = String(format:"%02d", minute)
        self.timeLabel.text = showhour + labelHour + showminute + labelMinute
    }
    
    //MARK: water view controller
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.waterWaveView.setupProgress(currentProgress)
        
        self.view.bringSubviewToFront(waterWaveView)
    }
    
    //MARK: motion view controller
    
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
        print("에어팟 연결 성공")
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
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
    
    func setUserWeight(currentWeight: (Double, Double, Double, Double, Double, Int)) {
        userWeight = currentWeight
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            setUserWeight(currentWeight: currentWeight)
            print("shake: \(userWeight)")
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
}

