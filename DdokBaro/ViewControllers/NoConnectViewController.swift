//
//  ConnectViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/30.
//

import UIKit
import Lottie

class NoConnectViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        titleLabel.text = "에어팟을 연결해주세요"
        self.changeTextColor()
        
        circleView.layer.cornerRadius = circleView.bounds.width / 2
        circleView.clipsToBounds = true
        circleView.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
        
        let turtleAirpodView = LottieAnimationView(name: "TurtleAirpod")
        
        turtleAirpodView.contentMode = .scaleAspectFit
        turtleAirpodView.frame = circleView.bounds
        
        circleView.addSubview(turtleAirpodView)
        
        turtleAirpodView.play()
        turtleAirpodView.loopMode = .loop
        
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "에어팟"))
        self.titleLabel.attributedText = attributeString
    }
}
