//
//  ZeroPointViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/26.
//

import UIKit
import CoreMotion

class ZeroPointViewController: UIViewController, CMHeadphoneMotionManagerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var turtleGuideImage: UIImageView!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    
    let zeroManager = CMHeadphoneMotionManager()
    
    var airPodCheck:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        if airPodCheck == false {
            print("여기는 else")
            //setupButton.isEnabled = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let noConnectViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController") as? NoConnectViewController else {
                return
            }
            // Add NoConnectViewController as a child view controller
            addChild(noConnectViewController)
            noConnectViewController.view.frame = view.bounds
            view.addSubview(noConnectViewController.view)
            noConnectViewController.didMove(toParent: self)
        }
        titleLabel.text = "나에게 딱 맞는 측정을 위해\n조정이 필요해요"
        titleLabel.numberOfLines = 0
        self.changeTextColor()
        
        middleTitleLabel.text = "화면을 정면으로 바라보고"
        
        textOne.setupLabelAndButton(view: textOne, systemName: "1.circle.fill", text: " 허리와 어깨를 펴고", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        textTwo.setupLabelAndButton(view: textTwo, systemName: "2.circle.fill", text: " 턱을 당겨주세요!", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
        
        descriptionLabel.text = "나중에 설정창에서 재설정 할 수 있어요"
        
        
        turtleGuideImage.image = UIImage(named: "TurtleGuide")
        
        zeroManager.delegate = self
        
        zeroManager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [weak self] deviceMotion, error in guard let motion = deviceMotion, error == nil else { return }
                self?.zeroMotion(motion)
            }
        )
        
    }
    
    func zeroMotion(_ motion: CMDeviceMotion)
    {
        let pitch = degrees(motion.attitude.pitch)
        intPitch = degreeInt(pitch)
        currentWeight = (pitch, degreeInt(pitch))
        airPodCheck = true
        //print(intPitch)
    }
    
    func setUserWeight(currentWeight: (Double, Int)) {
        userWeight = currentWeight
    }
    
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "조정이 필요해요"))
        self.titleLabel.attributedText = attributeString
    }
    //degree int로 바꿈
    func degreeInt(_ num: Double) -> Int {
        return Int(num)
    }
    
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }
    
    
    
    @IBAction func SetupPointButton(_ sender: Any) {
        //setUserWeight(currentWeight: currentWeight)
        //playSound(soundName: "ZeroSound", rate: 1.0)
        //print(userWeight)
        
        if airPodCheck == true {
            setUserWeight(currentWeight: currentWeight)
            playSound(soundName: "ZeroSound", rate: 1.0)
        }else {
            setupButton.isEnabled = false
            print("여기는 else")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let noConnectViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController") as? NoConnectViewController else {
                return
            }
            // Add NoConnectViewController as a child view controller
            addChild(noConnectViewController)
            noConnectViewController.view.frame = view.bounds
            view.addSubview(noConnectViewController.view)
            noConnectViewController.didMove(toParent: self)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingToMainSegue" {
       
        }
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let noConnectViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController") as? NoConnectViewController else {
            return
        }
        
        // Add NoConnectViewController as a child view controller
        addChild(noConnectViewController)
        noConnectViewController.view.frame = view.bounds
        view.addSubview(noConnectViewController.view)
        noConnectViewController.didMove(toParent: self)

    }
    //에어팟 연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        for childViewController in children {
            if let noConnectViewController = childViewController as? NoConnectViewController {
                noConnectViewController.willMove(toParent: nil)
                noConnectViewController.view.removeFromSuperview()
                noConnectViewController.removeFromParent()
                break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            if identifier == "ToWelcomeSegue" && !airPodCheck {
                return false // Segue를 막습니다.
            }
            return true // Segue를 허용합니다.
        }
        //return true
    }



