//
//  WaterViewController.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit

class WaterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in 1...7 {
            let grassGraphView = GrassGraphView(frame: CGRect(x: i * 10, y: i * 10, width: 15, height: 15))
            view.addSubview(grassGraphView)
        }
    }
}

