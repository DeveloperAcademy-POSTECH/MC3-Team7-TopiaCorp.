//
//   RightPostureViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/30.
//

import UIKit

class RightPostureViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var turtleGuideImage: UIImageView!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var textTwo: UILabel!
    
    let backGroundColor2 = UIView()
    
        override func viewDidLoad() {
        super.viewDidLoad()
            

        textOne.setupLabelAndButton(view: textOne, systemName: "1.circle.fill", text: " 허리와 어깨를 펴고", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        textTwo.setupLabelAndButton(view: textTwo, systemName: "2.circle.fill", text: " 턱을 당겨주세요!", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        turtleGuideImage.image = UIImage(named: "TurtleGuide")
           
             view.setGradient3(color1: .white, color2: UIColor(hexCode: "ECF3FF"))
            
//
//            backGroundColor2.setGradient2(color1: .black, color2: .blue)
//            backGroundColor2.frame = self.view.bounds
//            backGroundColor2.center = self.view.center
//            backGroundColor2.contentMode = .scaleAspectFit
//            backGroundColor2.layer.zPosition = -1 // Move the gradient layer to the back
//
//            self.view.addSubview(backGroundColor2)
    }
    
    @IBAction func goToWelcomeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}
extension UIView {
    func setGradient3(color1: UIColor, color2: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.25, 0.75]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5 ,y:1.0)
        gradientLayer.zPosition = -1
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
