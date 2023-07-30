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
    
        override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.isNavigationBarHidden = true
        
        textOne.setupLabelAndButton(view: textOne, systemName: "1.circle.fill", text: " 허리와 어깨를 펴고", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        textTwo.setupLabelAndButton(view: textTwo, systemName: "2.circle.fill", text: " 턱을 당겨주세요!", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        turtleGuideImage.image = UIImage(named: "TurtleGuide")
    }
    
    @IBAction func goToWelcomeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}
