//
//  SettingView.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/30.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var soundSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        
    }

    @IBAction func goToZeroPoint(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let zeroPointViewController = storyboard.instantiateViewController(withIdentifier: "ZeroPointViewController") as? ZeroPointViewController {
            // Perform the segue programmatically
            navigationController?.pushViewController(zeroPointViewController, animated: true)
        }
    }
}
