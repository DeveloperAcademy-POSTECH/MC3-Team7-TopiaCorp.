//
//  Onboarding3ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/23.
//

import UIKit

class Onboarding3ViewController: UIViewController {

    
    @IBOutlet weak var descriptionLabel4: UILabel!
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var nextButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircleView()
        
        // Do any additional setup after loading the view.
        func setupCircleView() {
            let incircleView4 = UIImageView(image: UIImage(named: "Grass"))
            incircleView4.contentMode = .scaleAspectFit
            incircleView4.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(incircleView4)
            //circleView3.layer.cornerRadius = 130
            let imageSize: CGFloat = 260
            let imageFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
            
            // Add constraints to center the image view
            NSLayoutConstraint.activate([
                incircleView4.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                incircleView4.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                incircleView4.widthAnchor.constraint(equalToConstant: imageSize),
                incircleView4.heightAnchor.constraint(equalToConstant: imageSize)
            ])
            
//            circleView3.clipsToBounds = true
//            circleView3.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
        }
    }
}
            
