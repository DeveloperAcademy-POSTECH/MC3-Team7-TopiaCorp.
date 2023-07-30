//
//  SuccessViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/27.
//

import UIKit
import Lottie

class FailViewController: UIViewController {
    var showhour = "00"
    var showminute = "00"
    let labelHour = " 시간 "
    let labelMinute = " 분"

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var waterView: UIView!
    

    @IBOutlet weak var toMainButton: UIButton!
    
    @IBOutlet weak var timeSubLabel: UILabel!
    @IBOutlet weak var waterSubLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var waterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "물을 전부 쏟아버렸군요!\n다시 도전해볼까요?"
        titleLabel.numberOfLines = 0
        
        timeView.layer.cornerRadius = 14
        waterView.layer.cornerRadius = 14
        
        let turtleResultB = LottieAnimationView(name: "TurtleResultB")
        self.view.addSubview(turtleResultB)
        turtleResultB.frame = CGRect(x: 45, y: 192, width: 300, height: 300)
        turtleResultB.contentMode = .scaleAspectFit
        turtleResultB.play()
        turtleResultB.loopMode = .loop
        
        self.view.sendSubviewToBack(turtleResultB)
        
        timeSubLabel.setupLabelAndButton(view: timeSubLabel, systemName: "clock.fill", text: " 작업 시간", imageColor: .black, textColor: .black, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
        
        waterSubLabel.setupLabelAndButton(view: waterSubLabel, systemName: "drop.fill", text: " 지켜낸 물", imageColor: .pointRed ?? .blue, textColor: .pointRed ?? .blue, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
       
        timeLabel.text = "0시간 0분"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        waterLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        self.changeTextColor()
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "다시 도전해볼까요?"))
        self.titleLabel.attributedText = attributeString
    }
    
    @IBAction func goToMainButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    @IBAction func goToZeroPoint(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let zeroPointViewController = storyboard.instantiateViewController(withIdentifier: "ZeroPointViewController") as? ZeroPointViewController {
            navigationController?.pushViewController(zeroPointViewController, animated: true)
        }
    }
    
}
