//
//  ViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/11.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    private let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "DdokLogo")
        return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        view.addSubview(animationView)

        // 2
        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.alpha = 1

        // 3
        animationView.play { _ in
          UIView.animate(withDuration: 0.3, animations: {
            self.animationView.alpha = 0
          }, completion: { _ in
            self.animationView.isHidden = true
            self.animationView.removeFromSuperview()
          })
        }
    }
}
    
    

 

