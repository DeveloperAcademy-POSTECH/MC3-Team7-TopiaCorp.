//
//  temp+layout.swift
//  DdokBaro
//
//  Created by yusang on 2023/09/01.
//

import Foundation
import UIKit


extension MainViewController {
    
    func addView() {
        self.view.addSubview(animationView1)
        self.view.addSubview(animationView2)
        self.view.addSubview(animationView3)
        self.view.addSubview(animationView4)
    }
    
    func viewBack() {
        self.view.sendSubviewToBack(animationView1)
        self.view.sendSubviewToBack(animationView2)
        self.view.sendSubviewToBack(animationView3)
        self.view.sendSubviewToBack(animationView4)
    }
    
    func removeView() {
        animationView1.removeFromSuperview()
        animationView2.removeFromSuperview()
        animationView3.removeFromSuperview()
        animationView4.removeFromSuperview()
    }
    
    func layoutContiguee() {
        
        animationView2.frame = self.view.bounds
        animationView2.center = self.view.center
        animationView2.contentMode = .scaleAspectFit
        animationView2.setSpeed()
        
        animationView1.frame = self.view.bounds
        animationView1.center = self.view.center
        animationView1.contentMode = .scaleAspectFit
        animationView1.setSpeed()
        animationView1.animationView.loopMode = .loop

        animationView3.frame = self.view.bounds
        animationView3.center = self.view.center
        animationView3.contentMode = .scaleAspectFit
        
        animationView4.frame = self.view.bounds
        animationView4.center = self.view.center
        animationView4.contentMode = .scaleAspectFit
        
    }
}
