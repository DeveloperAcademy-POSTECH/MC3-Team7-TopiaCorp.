//
//  NoAirpodViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/19.
//

import UIKit
import Lottie

class NoAirpodViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var terminateButton: UIButton!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleView.layer.cornerRadius = 130
        let incircleView = LottieAnimationView(animation: LottieAnimation.named("TurtleAirpod"))
        self.view.addSubview(incircleView)
        incircleView.frame = (CGRect(x: 1, y: 1, width: 286, height: 286))
        incircleView.center = self.view.center
        incircleView.contentMode = .scaleAspectFit
        incircleView.play()
        incircleView.loopMode = .loop
        
        circleView.clipsToBounds = true
        circleView.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF")) //
    }
    
//    static func viewController() -> UIViewController {
//
//        guard let vc = UIStoryboard(name: "Onboarding", bundle: .main).instantiateViewController(withIdentifier: "NoAirpodViewController") as? NoAirpodViewController else {
//
//            print("Hello")
//            return UIViewController()
//        }
//
//        print("Hello")
//
//        return vc
//
//    }
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
}

extension UIColor {
            convenience init(hexCode: String, alpha: CGFloat = 1.0) {
                var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
                
                if hexFormatted.hasPrefix("#") {
                    hexFormatted = String(hexFormatted.dropFirst())
                }
                
                assert(hexFormatted.count == 6, "Invalid hex code used.")
                
                var rgbValue: UInt64 = 0
                Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
                
                self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                          green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                          blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                          alpha: alpha)
            }
}
