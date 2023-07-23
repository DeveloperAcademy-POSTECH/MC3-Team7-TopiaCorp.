//
//  MainViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit

enum SFSymbolKey: String {
  case pause = "pause.circle"
  case stop = "xmark.circle.fill"
  case clock = "clock"
}

class MainViewController: UIViewController {
    var showhour = "00"
    var showminute = "00"
    let labelHour = " 시간 "
    let labelMinute = " 분"
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    
    let screenWidth = UIScreen.main.bounds.size.width
    let waterWaveView = WaterWaveView()
    var currentProgress: CGFloat = 1.0 // 현재 물의 양 0.0 ~ 1.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circleView: CircleViewController!
    
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
    }
}


