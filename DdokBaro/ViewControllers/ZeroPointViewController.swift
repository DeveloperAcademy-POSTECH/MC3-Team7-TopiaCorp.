//
//  ZeroPointViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/26.
//

import UIKit
import CoreMotion

class AirPodCheckModel {
    static let shared = AirPodCheckModel()

    private init() {}

    @objc dynamic var airPodCheck:Bool = false {
        didSet {
            // airPodChec의 값이 변경될 때마다 호출되는 코드
            // NotificationCenter를 이용하여 값을 알린다
            NotificationCenter.default.post(name: NSNotification.Name("airpodcheck"), object: nil)
        }
    }

    func updateValue(newValue: Bool) {
        print(airPodCheck)
        airPodCheck = newValue
    }
}

class ZeroPointViewController: UIViewController, CMHeadphoneMotionManagerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var turtleGuideImage: UIImageView!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    
    let zeroManager = CMHeadphoneMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
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
        // NotificationCenter이용해서 true false 감지
        NotificationCenter.default.addObserver(self, selector: #selector(checkModal), name: NSNotification.Name("airpodcheck"), object: nil)
        showModalView()
    }

    // Notification이 발생하면 호출
    @objc func checkModal() {
        // if else로 모달뷰 띄울지
        if AirPodCheckModel.shared.airPodCheck {
            closeYourView()
        } else {
            showModalView()
        }
    }

    // 뷰를 띄우는 메서드
    func showModalView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noConnectionViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController")
        noConnectionViewController.modalPresentationStyle = .formSheet
        noConnectionViewController.isModalInPresentation = true
        self.present(noConnectionViewController, animated: true, completion: nil)
    }

    // 뷰를 닫는 메서드
    func closeYourView() {
        dismiss(animated: true)
    }

    func zeroMotion(_ motion: CMDeviceMotion)
    {
        let pitch = degrees(motion.attitude.pitch)
        intPitch = degreeInt(pitch)
        currentWeight = (pitch, degreeInt(pitch))
        changeValueAndNotify()
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
            setUserWeight(currentWeight: currentWeight)
            playSound(soundName: "ZeroSound", rate: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingToMainSegue" {
       
        }
    }
    
    //에어팟 연결 끊겼을때
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noConnectionViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController")
        noConnectionViewController.modalPresentationStyle = .formSheet
        noConnectionViewController.isModalInPresentation = true
        self.present(noConnectionViewController, animated: true, completion: nil)
        
    }
    //에어팟 연결되었을때
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        dismiss(animated: true)
    }
}


// 값을 변경하는 함수
func changeValueAndNotify() {
    // true로 변경후 notification에서 감지하도록
    AirPodCheckModel.shared.updateValue(newValue: true)
    WelcomeAirPodCheckModel.shared.updateValue(newValue: true)
}
