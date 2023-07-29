//
//  FailViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/27.
//

import UIKit
import Lottie

class SuccessViewController: UIViewController {
    var showhour = "00"
    var showminute = "00"
    let labelHour = " 시간 "
    let labelMinute = " 분"

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var waterView: UIView!
    
    @IBOutlet weak var toGrassButton: UIButton!
    
    @IBOutlet weak var toMainButton: UIButton!
    
    @IBOutlet weak var timeSubLabel: UILabel!
    @IBOutlet weak var waterSubLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var waterLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "오늘도 바른 자세 유지 성공!\n잔디가 무럭무럭 자라요"
        titleLabel.numberOfLines = 0
        
        timeView.layer.cornerRadius = 14
        waterView.layer.cornerRadius = 14
        
        let turtleResultA = LottieAnimationView(name: "TurtleResultA")
        self.view.addSubview(turtleResultA)
        turtleResultA.frame = CGRect(x: 40, y: 221, width: 300, height: 300)
        turtleResultA.contentMode = .scaleAspectFit
        turtleResultA.play()
        turtleResultA.loopMode = .loop
        
        self.view.sendSubviewToBack(turtleResultA)
    

        toGrassButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        toMainButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        timeSubLabel.setupLabelAndButton(view: timeSubLabel, systemName: "clock.fill", text: " 작업 시간", imageColor: .black, textColor: .black, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
        
        waterSubLabel.setupLabelAndButton(view: waterSubLabel, systemName: "drop.fill", text: " 지켜낸 물", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
       
        
        timeLabel.text = "0시간 0분"
        
        self.changeTextColor()
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "잔디가 무럭무럭 자라요"))
        self.titleLabel.attributedText = attributeString
    }
    
}

