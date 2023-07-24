//
//  LottieWrapperView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/25.
//

import UIKit
import Lottie

class LottieWrapperView: UIView {
    let animationView: LottieAnimationView
    
    init(animationName: String) {
        self.animationView = LottieAnimationView(name: animationName)
        super.init(frame: .zero)
        commonInit()
    }
    
    init() {
        self.animationView = LottieAnimationView()
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        addSubview(animationView)
        
        // If using auto layout
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // If not using auto layout
        animationView.frame = self.bounds
    }
}
