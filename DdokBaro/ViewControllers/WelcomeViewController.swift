//
//  WelcomeViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp on 2023/07/14.
//

import UIKit


class WelcomeViewController: UIViewController {
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleStartLabel: UILabel!
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var startingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleStartLabel.font = UIFont.boldSystemFont(ofSize: 28)
        startingButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        
        
    }
    
    


}
