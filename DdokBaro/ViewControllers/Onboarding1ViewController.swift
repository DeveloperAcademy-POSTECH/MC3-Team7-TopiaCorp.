//
//  Onboarding1ViewController.swift
//  DdokBaro
//
//  Created by Daeun Jeong on 2023/07/20.
//

import UIKit

class Onboarding1ViewController: UIViewController {

    @IBOutlet weak var circleView2: UIView!
    
    
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBAction func completeButton(_ sender: UIButton) {
        let Onboarding2ViewController = Onboarding2ViewController() // Replace with the actual class of your next view controller
        navigationController?.pushViewController(Onboarding2ViewController, animated: true)
        
        // Update the page control's current page to indicate the transition
        pageControl.currentPage = 1 // Replace '1' with the appropriate page number for the next view controller
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircleView()
        // Do any additional setup after loading the view.
        
        pageControl.currentPage = 0
        
        func setupCircleView() {
            circleView2.layer.cornerRadius = 130
            
            let incircleView2 = UIImageView(image: UIImage(named: "TurtleSit"))
            incircleView2.contentMode = .scaleAspectFit
            self.view.addSubview(incircleView2)
            incircleView2.frame = (CGRect(x: 0, y: 0, width: 286, height: 286))
            incircleView2.center = self.view.center
            incircleView2.contentMode = .scaleAspectFit
            
            // Set the image view's frame and center it within the circleView
            
            circleView2.clipsToBounds = true
            circleView2.setGradient(color1: .white, color2: UIColor(hexCode: "ECF2FF"))
            
        }
        
//
////        @IBAction func completeButtonTapped(_ sender: UIButton) {
//                // Code to handle the complete button action
//                // For example, you can navigate to the next view controller
//                let Onboarding2ViewController = Onboarding2ViewController() // Replace with the actual class of your next view controller
//                navigationController?.pushViewController(Onboarding2ViewController, animated: true)
//
//                // Update the page control's current page to indicate the transition
//                pageControl.currentPage = 1 // Replace '1' with the appropriate page number for the next view controller
//            }
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
