//
//  ZeroPointViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/26.
//

import UIKit

class ZeroPointViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var turtleGuideImage: UIImageView!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        titleLabel.text = "나에게 딱 맞는 측정을 위해\n조정이 필요해요"
        titleLabel.numberOfLines = 0
        self.changeTextColor()
        
        middleTitleLabel.text = "화면을 정면으로 바라보고"
        
        textOne.setupLabelAndButton(view: textOne, systemName: "1.circle.fill", text: " 허리와 어깨를 펴고", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        textTwo.setupLabelAndButton(view: textTwo, systemName: "2.circle.fill", text: " 턱을 당겨주세요!", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        
        descriptionLabel.text = "나중에 설정창에서 재설정 할 수 있어요"
        
        
        turtleGuideImage.image = UIImage(named: "TurtleGuide")
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "조정이 필요해요"))
        self.titleLabel.attributedText = attributeString
    }
    
    @IBAction func SetupPointButton(_ sender: Any) {
        userWeight = currentWeight
        print(userWeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingToMainSegue" {
       
        }
    }
}


