//
//  Onboarding3ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/23.
//

import UIKit
import Lottie

//온보딩
class Onboarding3ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        titleLabel.text = "매일매일\n잔디에 물을 주어요"
        titleLabel.numberOfLines = 0
        descriptionLabel.text = "바른 자세로 지킨 양동이의 물은\n잔디가 무럭무럭 자라게 해요"
        descriptionLabel.numberOfLines = 0
        changeTextColor()
        
        turtleImage.image = UIImage(named: "Grass")
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "매일매일"))
        self.titleLabel.attributedText = attributeString
    }
    
    @IBAction func goToZeroButton(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let zeroPointViewController = storyboard.instantiateViewController(withIdentifier: "ZeroPointViewController") as? ZeroPointViewController {
                // Perform the segue programmatically
                navigationController?.pushViewController(zeroPointViewController, animated: true)
            }
        }
    }

