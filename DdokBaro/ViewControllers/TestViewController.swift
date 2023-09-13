//
//  TestViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/13.
//

import UIKit


//뭔지 모르겠음
class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapTimerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timerViewController = storyboard.instantiateViewController(withIdentifier: "TimerViewController")
        self.present(timerViewController, animated: true)
    }
    
    @IBAction func didTapMotionButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let motionViewController = storyboard.instantiateViewController(withIdentifier: "MotionViewController")
        self.present(motionViewController, animated: true)
    }
}

