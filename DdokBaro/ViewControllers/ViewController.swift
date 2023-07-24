//
//  ViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/11.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func onBoardAction(_ sender: Any) {
        
        let vc = Onboarding1ViewController.viewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

