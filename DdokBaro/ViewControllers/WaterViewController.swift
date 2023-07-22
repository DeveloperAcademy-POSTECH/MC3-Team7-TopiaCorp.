//
//  WaterViewController.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit

class WaterViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.size.width
    let waterWaveView = WaterWaveView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(waterWaveView)
        waterWaveView.setupProgress(waterWaveView.progress)
        
        NSLayoutConstraint.activate([
            waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }


}

