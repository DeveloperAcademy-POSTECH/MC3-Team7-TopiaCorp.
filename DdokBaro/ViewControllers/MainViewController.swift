//
//  MainViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit
import AVFoundation
import CoreHaptics
import CoreMotion
import Lottie
import UserNotifications
import CoreData

var currentWeight = (0.0, 0) // 현재 측정 각도
var userWeight = (0.0, 0) // 사용자 설정 가중치
var intPitch: Int = 0

class MainViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var showhour = "00"
    var showminute = "00"
    let labelHour = "시간 "
    let labelMinute = "분"
    let emptyString = " "
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime = 0.0
    var notFirstConnect:Bool = false
    
//    var currentWeight = (0.0, 0) // 현재 측정 각도
//    var userWeight = (0.0, 0) // 사용자 설정 가중치
//    var intPitch: Int = 0
    
    
    //var currentWeight = (0.0, 0) // 현재 측정 각도
    //var userWeight = (0.0, 0) // 사용자 설정 가중치
    
    let screenWidth = UIScreen.main.bounds.size.width
    let waterWaveView = WaterWaveView()
    var currentProgress: CGFloat = 1.0 // 현재 물의 양 0.0 ~ 1.0
    
    @IBOutlet weak var titleSubLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    //목 각도 int값
//    var intPitch: Int = 0
    
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    
    private var badSoundTimer = Timer()
    
    private var motionTimer = Timer()
    
    private var hapticManager: HapticManager?
    
    enum angle: Int {
        case notgood = -10
        case bad = -25
        case danger = -32
        case worst = -42
    }
    
    let dropWhenBad: CGFloat = 5.0
    let dropWhenDanger: CGFloat = 10.0
    let dropWhenWorst: CGFloat = 15.0
    
    let animationView1 = LottieWrapperView(animationName: "TurtleBody")
    let animationView2 = LottieWrapperView(animationName: "TurtleHead")
    let animationView3 = LottieWrapperView(animationName: "WaterDrops1")
    let animationView4 = LottieWrapperView(animationName: "WaterDrops2")
    var audioPlayer = AVAudioPlayer()
    
    let restView: UIImageView = {
        let restView = UIImageView()
        restView.image = UIImage(named: "TurtleRest")
        restView.contentMode = .scaleAspectFit
        return restView
    }()
    
    let backGroundColor = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        //self.navigationController?.popViewController(animated: true)
        //self.view.setGradient(color1: .blue, color2: .black)
        
        backGroundColor.setGradient2(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
        backGroundColor.frame = self.view.bounds
        backGroundColor.center = self.view.center
        backGroundColor.contentMode = .scaleAspectFit
        backGroundColor.layer.zPosition = -1
        
        self.view.addSubview(backGroundColor)
        self.view.sendSubviewToBack(backGroundColor)
        
        getAllData()
        
        let circleView = CircleViewController()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        titleLabel.numberOfLines = 0
        timeLabel.setupLabelAndButton(view: timeLabel, systemName: "clock", text: emptyString + showhour + labelHour + showminute + labelMinute, imageColor: .pointBlue ?? .black, textColor: .pointBlue ?? .black, font: .boldSystemFont(ofSize: 28), pointSize: 28, weight: .bold)
        
        startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 일시 정지", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
        
        resetButton.setupLabelAndButton(view: resetButton, systemName: "xmark.circle.fill", text: " 측정 종료", imageColor: .pointRed ?? .black, textColor: .pointRed ?? .black, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
        
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
        if isStart == false {
            startTimer()
            updateTimer()
            isStart = true
        }
        
        // water view controller
        view.addSubview(waterWaveView)
        waterWaveView.setupProgress(waterWaveView.progress)
        
        NSLayoutConstraint.activate([
            waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 215),
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
        
        NotificationManager().requestAuthorization()
        
        //animationView2.layoutSubviews()
        animationView2.frame = self.view.bounds
        animationView2.center = self.view.center
        animationView2.contentMode = .scaleAspectFit
        animationView2.setSpeed()
        view.addSubview(animationView2)
        
        animationView1.frame = self.view.bounds
        animationView1.center = self.view.center
        animationView1.contentMode = .scaleAspectFit
        animationView1.setSpeed()
        animationView1.animationView.loopMode = .loop
        self.view.addSubview(animationView1)
        
        //animationView3.layoutSubviews()
        animationView3.frame = self.view.bounds
        animationView3.center = self.view.center
        animationView3.contentMode = .scaleAspectFit
        self.view.addSubview(animationView3)
        
        //animationView4.layoutSubviews()
        animationView4.frame = self.view.bounds
        animationView4.center = self.view.center
        animationView4.contentMode = .scaleAspectFit
        self.view.addSubview(animationView4)
        
        self.view.sendSubviewToBack(animationView1)
        self.view.sendSubviewToBack(animationView2)
        self.view.sendSubviewToBack(animationView3)
        self.view.sendSubviewToBack(animationView4)
        
        //        DispatchQueue.main.async { [weak self] in
        //            //거북이 몸통을 위에 겹치기 위해 여기에 작성
        //            self?.animationView1.setPlay()
        //        }
        let noSound = Bundle.main.path(forResource: "noSound", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: noSound!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
        } catch { print(error) }
        audioPlayer.play()
        
        //헤드폰 모니터링 할려면 delegate 대리자 필요
        manager.delegate = self
        
        manager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [weak self] deviceMotion, error in guard let motion = deviceMotion, error == nil else { return }
                self?.turtleMotion(motion)
            }
        )
        
    }
    
    func turtleMotion(_ motion: CMDeviceMotion)
    {
        //print(currentWeight)
        //print(userWeight)
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
                
                self!.currentProgress -= self!.dropWhenBad * 0.00001
                self!.waterWaveView.setupProgress(self!.currentProgress)
                
                if intPitch - userWeight.1 < angle.bad.rawValue {
                    self?.animationView3.setStop()
                    self?.animationView4.setPlay()
                    
                    self!.currentProgress -= self!.dropWhenWorst * 0.00001
                    self!.waterWaveView.setupProgress(self!.currentProgress)
                    
                    //                    if self!.intPitch - self!.userWeight.1 < angle.danger.rawValue {
                    //
                    //                    }
                    
                    if self!.motionTimer.isValid {
                        
                    }
                    else {
                        self!.motionTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(self?.badSound), userInfo: nil, repeats: false)
                        //timerCounting = true
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
            backGroundColor.setGradient2(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
            backGroundColor.layer.zPosition = -1
            
            self.view.addSubview(animationView1)
            self.view.addSubview(animationView2)
            self.view.addSubview(animationView3)
            self.view.addSubview(animationView4)
            
            self.view.sendSubviewToBack(animationView1)
            self.view.sendSubviewToBack(animationView2)
            self.view.sendSubviewToBack(animationView3)
            self.view.sendSubviewToBack(animationView4)
            
            restView.removeFromSuperview()
            
            titleLabel.textColor = .black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
            titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
            titleLabel.numberOfLines = 0
            
            startTime = Date() //현재 시간으로 업데이트
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            isPaused = false
            startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 일시 정지", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
            audioPlayer.play()
            createData()
        } else {
            animationView1.setStop()
            
            backGroundColor.setGradient2(color1: UIColor(hexCode: "#02070B"), color2: UIColor(hexCode: "#02070B"))
            backGroundColor.layer.opacity = 0.5
            backGroundColor.layer.zPosition = 0
            
            //WaterWaveView().layer.zPosition = 1
            
            titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
            titleLabel.text = "휴식 시간!"
            titleLabel.textColor = .white
            titleLabel.numberOfLines = 0
            titleLabel.layer.zPosition = 1
            
            restView.frame = self.view.bounds
            restView.center = self.view.center
            
            self.view.addSubview(restView)
            self.view.sendSubviewToBack(restView)
            
            animationView1.removeFromSuperview()
            animationView2.removeFromSuperview()
            animationView3.removeFromSuperview()
            animationView4.removeFromSuperview()
            
            timer.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isPaused = true
            startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 다시 시작", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
            audioPlayer.pause()
            createData()
        }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        self.timer.invalidate()
        isStart = false
        accumulatedTime += Date().timeIntervalSince(startTime)
        timeLabel.setupLabelAndButton(view: timeLabel, systemName: "clock", text: emptyString + showhour + labelHour + showminute + labelMinute, imageColor: .pointBlue ?? .black, textColor: .pointBlue ?? .black, font: .boldSystemFont(ofSize: 28), pointSize: 28, weight: .bold)
        startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 다시 시작", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17), pointSize: 17, weight: .bold)
        self.startTime = Date()
        isPaused = true
        createData()
    }
    
    @objc private func updateTimer(){
        let currentTime = Date()
        let elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
        
        let hour = Int(elapsedTime / 60)
        let minute = Int((elapsedTime).truncatingRemainder(dividingBy: 60))
        
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
        for childViewController in children {
            if let noConnectViewController = childViewController as? NoConnectViewController {
                noConnectViewController.willMove(toParent: nil)
                noConnectViewController.view.removeFromSuperview()
                noConnectViewController.removeFromParent()
                break
            }
        }
        
//        if let presentedVC = presentedViewController, presentedVC is NoConnectViewController {
//            presentedVC.dismiss(animated: true, completion: nil)
//        }
    
        backGroundColor.setGradient2(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
        //backGroundColor.frame = self.view.bounds
        //backGroundColor.center = self.view.center
        //backGroundColor.contentMode = .scaleAspectFit
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
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = false
        
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
        print("에어팟 연결 성공")
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let noConnectViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController") as? NoConnectViewController else {
            return
        }
        
        // Add NoConnectViewController as a child view controller
        addChild(noConnectViewController)
        noConnectViewController.view.frame = view.bounds
        view.addSubview(noConnectViewController.view)
        noConnectViewController.didMove(toParent: self)

//        guard let noConnectViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController") as? NoConnectViewController else {
//            return
//        }
//        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
//            topViewController.present(noConnectViewController, animated: true, completion: nil)
//        }
        animationView1.setStop()
        
        backGroundColor.setGradient2(color1: .black, color2: UIColor(hexCode: "ECF2FF"))
        
        restView.frame = self.view.bounds
        restView.center = self.view.center
        
//        backGroundColor.setGradient(color1: .blue, color2: .black)
//        backGroundColor.frame = self.view.bounds
//        backGroundColor.center = self.view.center
        
        self.view.addSubview(restView)
        self.view.sendSubviewToBack(restView)
        
//        self.view.addSubview(backGroundColor)
//        self.view.sendSubviewToBack(backGroundColor)
        
        animationView1.removeFromSuperview()
        animationView2.removeFromSuperview()
        animationView3.removeFromSuperview()
        animationView4.removeFromSuperview()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //titleLabel.text = "측정을 시작할려면 에어팟을 연결해 주세요"
        //titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = true
        
        timer.invalidate()
        accumulatedTime += Date().timeIntervalSince(startTime)
        isPaused = true
        notFirstConnect = true
        startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 다시 시작", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
        audioPlayer.pause()
        print("에어팟 연결 끊김")
    }
    
    //우리가 아는 각도로 바꿔주는 함수
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
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
    
    @objc func haptic(){
        hapticManager?.playPattern()
    }
    
//    func setUserWeight(currentWeight: (Double, Int)) {
//        userWeight = currentWeight
//    }
    
    func getAllData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        print(today)
        
        do {
            let data = try context.fetch(DdokBaroData.fetchRequest())
            print(data)
            for datum in data {
                if datum.createdAt == today {
                    print(datum.remainWater)
                    currentProgress = CGFloat(datum.remainWater) * 0.01
                    accumulatedTime = Double(datum.totalMinutes)
                }
            }
        } catch {
            // error
        }
    }

    func createData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        
        do {
            let data = try context.fetch(DdokBaroData.fetchRequest())
            for datum in data {
                if datum.createdAt == today {
                    context.delete(datum)
                }
            }

            let newData = DdokBaroData(context: context)
            newData.createdAt = today
            newData.grassLevel = Int16(3.9 * currentProgress + 1)
            newData.remainWater = Int16(currentProgress * 100)
            newData.totalMinutes = Int16(accumulatedTime)

            do {
                try context.save()
            } catch {
                // error
            }
        } catch {
            // error
        }
    }

//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if event?.subtype == .motionShake {
//            setUserWeight(currentWeight: currentWeight)
//            //print("shake: \(userWeight)")
//        }
//    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //print("motionCancelled")
    }
}

