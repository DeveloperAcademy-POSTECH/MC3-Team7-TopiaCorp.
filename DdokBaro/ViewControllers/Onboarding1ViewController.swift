//
//  Onboarding1ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/20.
//

import UIKit

class Onboarding1ViewController: UIViewController {

    @IBOutlet weak var descriptionLabel2: UILabel!
    
    @IBOutlet weak var circleView2: UIView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var nextButton2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircleView()
        // Do any additional setup after loading the view.
    }

    func setupCircleView() {
        circleView2.layer.cornerRadius = 130

        let incircleView2 = UIImageView(image: UIImage(named: "TurtleSit"))
        incircleView2.contentMode = .scaleAspectFit
        self.view.addSubview(incircleView2)
        incircleView2.frame = CGRect(x: 0, y: 0, width: 286, height: 286)
        incircleView2.center = self.view.center
        incircleView2.contentMode = .scaleAspectFit

        circleView2.clipsToBounds = true
        circleView2.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
    }

    static func viewController() -> UIViewController {
        guard let vc = UIStoryboard(name: "Onboarding", bundle: .main).instantiateViewController(withIdentifier: "Onboarding1ViewController") as? Onboarding1ViewController else {
            print("Hello")
            return UIViewController()
        }
        print("Hello")
        return vc
    }
}
