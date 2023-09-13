//
//  Onboarding1ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/20.
//

import UIKit

//온보딩
class Onboarding1ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        titleLabel.text = "물을 쏟으면\n똑! 소리가 들려요"
        titleLabel.numberOfLines = 0
        descriptionLabel.text = "1분동안 나쁜 자세로 작업하면\n물이 쏟아지고 소리 알림이 가요"
        descriptionLabel.numberOfLines = 0
        changeTextColor()
        
        turtleImage.image = UIImage(named: "TurtleWater")
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "똑! 소리가 들려요"))
        self.titleLabel.attributedText = attributeString
    }
}


