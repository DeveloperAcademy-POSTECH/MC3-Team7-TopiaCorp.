//
//  LottieLaunchViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/08/02.
//

import UIKit
import Lottie

class LottieLaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchView = LottieAnimationView(name: "DdokLogo")
        self.view.addSubview(launchView)
        launchView.frame = CGRect(x: 0, y: 0, width: 231, height: 63)
        launchView.contentMode = .scaleAspectFit
        launchView.loopMode = .loop
        launchView.center = view.center
        launchView.play()
        print("런치")
    }
}
