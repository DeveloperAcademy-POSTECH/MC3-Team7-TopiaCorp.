//
//  LaunchScreen.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/31.
//
import UIKit
import Lottie

class LaunchScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchView = LottieAnimationView(name: "DdokLogo")
        self.view.addSubview(launchView)
        launchView.frame = CGRect(x: 80, y: 391, width: 231, height: 63)
        launchView.contentMode = .scaleAspectFit
        launchView.play()
        launchView.loopMode = .loop
        print("런치")
    }
}
