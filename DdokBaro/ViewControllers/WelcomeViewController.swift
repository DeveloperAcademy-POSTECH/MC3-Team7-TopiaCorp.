//
//  WelcomeViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit


class WelcomeViewController: UIViewController {
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "오늘의 작업을\n시작해볼까요?"
        titleLabel.numberOfLines = 0
        startingButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.changeTextColor()   
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (text as NSString).range(of: "시작해볼까요?"))
        self.titleLabel.attributedText = attributeString
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startStopwatchSegue" {
            if let stopwatchVC = segue.destination as? TimerViewController {
                stopwatchVC.startTime = startTime
                stopwatchVC.accumulatedTime = accumulatedTime
            }
        }
    }
    
    @IBAction func timerStarButton(_ sender: UIButton) {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(updateTimer),userInfo: nil, repeats: true)
        RunLoop.current.add(timer,forMode: .common)
    }
    
    @objc private func updateTimer(){
        let currentTime = Date()
        let elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
        
        let hour = Int(elapsedTime / 60)
        let minute = Int((elapsedTime).truncatingRemainder(dividingBy: 60))
    
    }
    
    
    
}