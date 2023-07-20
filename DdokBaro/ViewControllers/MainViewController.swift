//
//  MainViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit

class MainViewController: UIViewController {
    
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circleView: CircleViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        topTitleLabel.text = "바른 자세를 유지해\n양동이의 물을 지켜주세요!"
        topTitleLabel.numberOfLines = 0
        
        self.changeTextColor()
        
        let circleViewController = CircleViewController()
        circleView = circleViewController
        view.addSubview(circleView)
        
        startTimer()
        updateTimer()
    }
    func changeTextColor() {
        guard let text = self.topTitleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (text as NSString).range(of: "양동이의 물을 지켜주세요!"))
        self.topTitleLabel.attributedText = attributeString
        
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
            self.setButton("일시 정지")
            
        } else {
            timer.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isPaused = true
            self.setButton("시작")
        }
    }
    @IBAction func resetTapped(_ sender: UIButton) {
        self.timer.invalidate()
        self.hourLabel.text = "00"
        self.minuteLabel.text = "00"
        self.setButton("시작")
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
            self.hourLabel.text = String(format:"%02d", minute + extraHours)
        } else {
            self.hourLabel.text = String(format: "%02d", minute)
        }
        
        self.hourLabel.text = String(format:"%02d", hour)
        self.minuteLabel.text = String(format:"%02d", minute)
    }
    private func setButton(_ string: String){
        self.startPauseButton.setTitle(string, for: .normal)
        self.startPauseButton.setTitle(string, for: .highlighted)
    }
}

