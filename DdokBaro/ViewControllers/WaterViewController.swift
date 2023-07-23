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
    
    var currentProgress: CGFloat = 0.5
    @IBAction func waterWaveSlider(_ sender: UISlider) {
        currentProgress = CGFloat(sender.value)
        self.waterWaveView.setupProgress(currentProgress)
    }

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
        
        let totalPath = UIBezierPath()

        let width = screenWidth*0.5
        let height = screenWidth*0.5

        let center = CGPoint(x: width / 2, y: height / 2)
        let startPoint = CGPoint(x: width / 2, y: height / 20)

        totalPath.move(to: startPoint)
        totalPath.addArc(withCenter: center, radius: width * 9 / (20 * sqrt(2.0)),
                       startAngle: 5 * (.pi / 4), endAngle: 7 * (.pi / 4), clockwise: false)
        totalPath.addLine(to: startPoint)
        totalPath.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = totalPath.cgPath
        waterWaveView.layer.mask = maskLayer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.waterWaveView.setupProgress(currentProgress)
    }


}

