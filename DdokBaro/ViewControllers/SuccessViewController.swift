//
//  FailViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/27.
//

import UIKit

class SuccessViewController: UIViewController {

    
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
        titleLabel.text = "오늘도 바른 자세 유지 성공!\n잔디가 무럭무럭 자라요"
        titleLabel.numberOfLines = 0
        
        timeView.layer.cornerRadius = 14
        waterView.layer.cornerRadius = 14
        
        
        let turtleResultA = LottieWrapperView(animationName: "turtleResultA")
        self.view.addSubview(turtleResultA)
        turtleResultA.frame = self.view.bounds
        turtleResultA.center = self.view.center
        turtleResultA.setPlay()
        
        self.view.sendSubviewToBack(turtleResultA)
        
        
        
        toGrassButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        toMainButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        timeSubLabel.setupLabelAndButton(view: timeSubLabel, systemName: "clock.fill", text: " 작업 시간", imageColor: .black, textColor: .black, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
        
        waterSubLabel.setupLabelAndButton(view: waterSubLabel, systemName: "drop.fill", text: " 지켜낸 물", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
       
        
        timeLabel.text = "0시간 0분"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        waterLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        self.changeTextColor()
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue, range: (text as NSString).range(of: "잔디가 무럭무럭 자라요"))
        self.titleLabel.attributedText = attributeString
    }
    
}

