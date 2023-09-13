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
var intPitch: Int = 0 // 목 기울기(정수)
var isZero = false
var nextView = false

class MainViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    //AppDelegate 패턴을 이용해서 뷰컨트롤러가 메모리에서 지워져도 데이터는 남아있게 만든다. 앱이 종료되면 데이터 사라짐 but coreData에 저장할거
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let showHour = "00"
    let labelHour = "시간 "
    let labelMinute = "분"
    
    let emptyString = " "
    var showhour = "00"
    var showminute = "00"

    var timer = Timer()
    var startTime = Date()
    var accumulatedTime = 0.0
    
    var isPaused: Bool = false
    var notFirstConnect:Bool = false
    var isPause:Bool = false
    
    //    var currentWeight = (0.0, 0) // 현재 측정 각도
    //    var userWeight = (0.0, 0) // 사용자 설정 가중치
    //    var intPitch: Int = 0  //목 각도 int값
    
    let screenWidth = UIScreen.main.bounds.size.width
    let waterWaveView = WaterWaveView()
    var currentProgress: CGFloat = 1.0 // 현재 물의 양 0.0 ~ 1.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    //AirPods Pro => manager :) 헤드폰 모니터 매니저 담는 상수
    let manager = CMHeadphoneMotionManager()
    
    var badSoundTimer = Timer()
    
    var motionTimer = Timer()
    
    private var hapticManager: HapticManager?
    
    enum angle: Int {
        case notgood = -10
        case bad = -25
        case danger = -32
        case worst = -42
    }
    
//    enum step {
//        case notgood
//        case bad
//        case danger
//
//        var checkDegree(angle: Int) -> self {
//            if angle > ?{
//                return self.notgood
//            } else if  > ?{
//                return self.bad
//            } else {
//                return self.danger
//            }
//        }
//    }
    
    
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
        
        titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        titleLabel.numberOfLines = 0
        guard let text = titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (text as NSString).range(of: "양동이의 물을 지켜주세요!"))
        titleLabel.attributedText = attributeString
        
        timeLabel.setupLabelAndButton(view: timeLabel, systemName: "clock", text: emptyString + showhour + labelHour + showminute + labelMinute, imageColor: .pointBlue ?? .black, textColor: .pointBlue ?? .black, font: .boldSystemFont(ofSize: 28), pointSize: 28, weight: .bold)
        
        startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 일시 정지", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
        
        resetButton.setupLabelAndButton(view: resetButton, systemName: "xmark.circle.fill", text: " 측정 종료", imageColor: .pointRed ?? .black, textColor: .pointRed ?? .black, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
        
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
        
        viewBack()
        addView()
        layoutContiguee()
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkZero), name: NSNotification.Name("zerocheck"), object: nil)
        
    }
    
    //MARK: timer view controller
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        if isPaused {
            isPause = false
            
            animationView1.setPlay()
            backGroundColor.setGradient2(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
            backGroundColor.layer.zPosition = -1
            
            addView()
            viewBack()
            restView.removeFromSuperview()
            
            titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
            titleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
            titleLabel.numberOfLines = 0
            
            guard let text = self.titleLabel.text else {return}
            let attributeString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: "바른 자세를 유지해"))
            attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (text as NSString).range(of: "양동이의 물을 지켜주세요!"))
            self.titleLabel.attributedText = attributeString
            
            
            startTime = Date() //현재 시간으로 업데이트
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            isPaused = false
            startPauseButton.setupLabelAndButton(view: startPauseButton, systemName: "pause.circle.fill", text: " 일시 정지", imageColor: .white, textColor: .white, font: UIFont.boldSystemFont(ofSize: 17) , pointSize: 17, weight: .bold)
            audioPlayer.play()
            createData()
        } else {
            isPause = true
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
            
            removeView()
            
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noConnectionViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController")
        dismiss(animated: true)
        createData()
    }
    
    //MARK: water view controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.waterWaveView.setupProgress(currentProgress)
        self.view.bringSubviewToFront(waterWaveView)
        
    }
    
    //view willappear
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    //뷰가 사라질때 하고 싶은 작업들
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopDeviceMotionUpdates()
        stopSound()
        motionTimer.invalidate()
        nextView = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
}

