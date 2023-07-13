//
//  TimerViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/13.
//

import UIKit

class TimerViewController: UIViewController {
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pauseTapped(_ sender: UIButton) {
        if isPaused {
            timer.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isPaused = false
            self.setButton("시작")
              
          } else {
              startTime = Date()
              timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
              RunLoop.current.add(timer, forMode: .common)
              isPaused = true
              self.setButton("정지")
          }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        accumulatedTime = 0.0
        self.timer.invalidate()
        self.hourLabel.text = "00"
        self.minuteLabel.text = "00"
        self.setButton("시작")
        self.startTime = Date()
        isPaused = false
    }
    
@objc private func updateTimer(){
     let currentTime = Date()
     let elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
     let hour = Int(elapsedTime / 3600)
    let minute = Int((elapsedTime).truncatingRemainder(dividingBy: 60))
     
     self.hourLabel.text = String(format:"%02d", hour)
     self.minuteLabel.text = String(format:"%02d", minute)
 }

 private func setButton(_ string: String){
     self.pauseButton.setTitle(string, for: .normal)
     self.pauseButton.setTitle(string, for: .highlighted)
  }
}

