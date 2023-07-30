//
//  NoAirpodViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/19.
//

import UIKit
import Lottie

class NoAirpodViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var terminateButton: UIButton!
    
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
extension UIView {
    func setGradient(color1:UIColor,color2:UIColor){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x:0.5,y:1)
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
        
    }
    
    func setGradient2(color1:UIColor,color2:UIColor){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x:1 ,y:1)
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
        
    }
}
