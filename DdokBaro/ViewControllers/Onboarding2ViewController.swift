//
//  Onboarding2ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/20.
//

import UIKit

class Onboarding2ViewController: UIViewController {
    
    
    @IBOutlet weak var descriptionLabel3: UILabel!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircleView()
        
        // Do any additional setup after loading the view.
        func setupCircleView() {
           
            
            let incircleView3 = UIImageView(image: UIImage(named: "TurtleWater"))
            incircleView3.contentMode = .scaleAspectFit
            incircleView3.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(incircleView3)
            let imageSize: CGFloat = 260
            let imageFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
            
            // Add constraints to center the image view
            NSLayoutConstraint.activate([
                incircleView3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                incircleView3.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                incircleView3.widthAnchor.constraint(equalToConstant: imageSize),
                incircleView3.heightAnchor.constraint(equalToConstant: imageSize)
            ])
            
//            circleView3.clipsToBounds = true
//            circleView3.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
        }
    }
}
