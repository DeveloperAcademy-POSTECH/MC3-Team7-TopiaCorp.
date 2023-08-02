//
//  WelcomeViewController.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/14.
//

import UIKit
import Lottie
import CoreMotion

var isStart: Bool = false

class WelcomeAirPodCheckModel {
    static let shared = WelcomeAirPodCheckModel()

    private init() {}

    @objc dynamic var welcomeAirPodCheck:Bool = false {
        didSet {
            // airPodChec의 값이 변경될 때마다 호출되는 코드
            // NotificationCenter를 이용하여 값을 알린다
            NotificationCenter.default.post(name: NSNotification.Name("welcomeAirpodcheck"), object: nil)
        }
    }

    func updateValue(newValue: Bool) {
        print(welcomeAirPodCheck)
        welcomeAirPodCheck = newValue
    }
}

class WelcomeViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    var timer = Timer()
    var startTime = Date()
    var isPaused: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    var welcomeCheck:Bool = false
    let welcomeManager = CMHeadphoneMotionManager()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var chartButton: UIButton!
    
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let backBarButtonItem = UIBarButtonItem(title: "자세 측정", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        view.setGradient3(color1: .white, color2: UIColor(hexCode: "ECF3FF"))
        
        chartButton.circleButton = true
        chartButton.setImage(UIImage(systemName: "chart.bar.xaxis"), for: .normal)
        chartButton.layer.shadowColor = UIColor(red: 0.102, green: 0.263, blue: 0.831, alpha: 0.15).cgColor
        chartButton.layer.shadowOpacity = 1.0
        chartButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        chartButton.layer.shadowRadius = 4
        
        
        settingButton.circleButton = true
        settingButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingButton.layer.shadowColor = UIColor(red: 0.102, green: 0.263, blue: 0.831, alpha: 0.15).cgColor
        settingButton.layer.shadowOpacity = 1.0
        settingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        settingButton.layer.shadowRadius = 4
        
        titleLabel.text = "오늘의 작업을\n시작해볼까요?"
        titleLabel.numberOfLines = 0
        
        self.changeTextColor()
        
        let welcomeTurtleView = LottieWrapperView(animationName: "welcomeTurtle")
        self.view.addSubview(welcomeTurtleView)
        welcomeTurtleView.frame = self.view.bounds
        welcomeTurtleView.center = self.view.center
        welcomeTurtleView.setPlay()
        
        self.view.sendSubviewToBack(welcomeTurtleView)
        
        welcomeManager.delegate = self
        
        welcomeManager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [weak self] deviceMotion, error in guard let motion = deviceMotion, error == nil else { return }
                self?.welcomeMotion(motion)
            }
            )
        NotificationCenter.default.addObserver(self, selector: #selector(checkModal), name: NSNotification.Name("welcomeAirpodcheck"), object: nil)
        //showModalView()
//        button.isUserInteractionEnabled = false
        
    }
    @objc func checkModal() {
        // if else로 모달뷰 띄울지
        if WelcomeAirPodCheckModel.shared.welcomeAirPodCheck {
//            button.isUserInteractionEnabled = true
        } else {
            showModalView()
        }
    }
    func showModalView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noConnectionViewController = storyboard.instantiateViewController(withIdentifier: "NoConnectViewController")
        noConnectionViewController.modalPresentationStyle = .formSheet
        noConnectionViewController.isModalInPresentation = true
        self.present(noConnectionViewController, animated: true, completion: nil)
    }
    
    func welcomeMotion(_ motion: CMDeviceMotion)
    {
        //welcomeCheck = true
        changeValueAndNotify()
    }
    @IBAction func goSettingButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
            navigationController?.pushViewController(settingViewController, animated: true)
        }
    }
    
    @IBAction func GoToMain(_ sender: UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(checkModal), name: NSNotification.Name("welcomeAirpodcheck"), object: nil)
        timer.invalidate()
//        if WelcomeAirPodCheckModel.shared.welcomeAirPodCheck {
//
//        }
//        else {
//            showModalView()
//        }
        //NotificationCenter.default.addObserver(self, selector: #selector(checkModal), name: NSNotification.Name("welcomeAirpodcheck"), object: nil)
    }
    
    @IBAction func goChartButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chartViewController = storyboard.instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController {
            navigationController?.pushViewController(chartViewController, animated: true)
        }
    }
    
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "시작해볼까요?"))
        self.titleLabel.attributedText = attributeString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startStopwatchSegue" {
            if let stopwatchVC = segue.destination as? TimerViewController {
                stopwatchVC.startTime = startTime
                stopwatchVC.accumulatedTime = accumulatedTime
            }
        }
    }
    
    @IBAction func timerStartButton(_ sender: UIButton) {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,selector: #selector(updateTimer),userInfo: nil, repeats: true)
        RunLoop.current.add(timer,forMode: .common)
    }
    
    @objc private func updateTimer(){
        let currentTime = Date()
        var elapsedTime: Double = 0.0
        elapsedTime = accumulatedTime + currentTime.timeIntervalSince(startTime)
        
        _ = Int(elapsedTime / 60)
        _ = Int((elapsedTime).truncatingRemainder(dividingBy: 60))
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if WelcomeAirPodCheckModel.shared.welcomeAirPodCheck{
            return true
        }
        print("여기는 shouldperform")
        showModalView()
        return false
    }
}
extension UIButton {
    var circleButton: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}

