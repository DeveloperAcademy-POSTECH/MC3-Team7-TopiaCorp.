//
//  SuccessViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/27.
//

import UIKit
import Lottie

class FailViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var turtleResultImage: UIImageView!
    
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.text = "물을 전부 쏟아버렸군요!\n다시 도전해볼까요?"
        titleLabel.numberOfLines = 0
        
        timeView.layer.cornerRadius = 14
        waterView.layer.cornerRadius = 14
        
        
        let turtleResultB = LottieWrapperView(animationName: "TurtleResultB")
        self.view.addSubview(turtleResultB)
        turtleResultB.frame = self.view.bounds
        turtleResultB.center = self.view.center
        turtleResultB.setPlay()
        
        self.view.sendSubviewToBack(turtleResultB)
        

        toGrassButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        toMainButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
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
    
}
