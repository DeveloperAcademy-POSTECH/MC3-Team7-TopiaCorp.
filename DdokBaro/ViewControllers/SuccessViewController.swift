//
//  FailViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/27.
//

import UIKit
import Lottie
import CoreData

class SuccessViewController: UIViewController {
    var fetchedData: DdokBaroData?

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var waterView: UIView!
    
    @IBOutlet weak var timeSubLabel: UILabel!
    
    @IBOutlet weak var waterSubLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var waterLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DdokBaroData> = DdokBaroData.fetchRequest()
        do {
            let data = try context.fetch(fetchRequest)
            
            if let firstData = data.first {
                fetchedData = firstData
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        if let remainingWater = fetchedData?.remainWater, let totalTime = fetchedData?.totalMinutes {
            let hour = Int(totalTime / 60)
            let totalTimeDouble = Double(totalTime)
            let minute = Int((totalTimeDouble).truncatingRemainder(dividingBy: 60))
            let formattedTime = String(format: "%02d시 %02d분", hour, minute)
            waterLabel.text = "\(remainingWater)L"
            timeLabel.text = formattedTime
        } else {
            waterLabel.text = "없음"
            timeLabel.text = "없음"
        }

        view.setGradient3(color1: .white, color2: UIColor(hexCode: "ECF3FF"))
        titleLabel.text = "오늘도 바른 자세 유지 성공!\n잔디가 무럭무럭 자라요"
        titleLabel.numberOfLines = 0
        
        timeView.layer.cornerRadius = 14
        waterView.layer.cornerRadius = 14
        
        let turtleResultA = LottieAnimationView(name: "TurtleResultA")
        self.view.addSubview(turtleResultA)
        turtleResultA.frame = CGRect(x: 45, y: 181, width: 300, height: 300)
        turtleResultA.contentMode = .scaleAspectFit
        turtleResultA.play()
        turtleResultA.loopMode = .loop
        
        self.view.sendSubviewToBack(turtleResultA)
    
        timeSubLabel.setupLabelAndButton(view: timeSubLabel, systemName: "clock.fill", text: " 작업 시간", imageColor: .black, textColor: .black, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
        
        waterSubLabel.setupLabelAndButton(view: waterSubLabel, systemName: "drop.fill", text: " 지켜낸 물", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 15), pointSize: 15, weight: .bold)
       
        
        self.changeTextColor()
    }
    func changeTextColor() {
        guard let text = self.titleLabel.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.foregroundColor, value: UIColor.pointBlue ?? .black, range: (text as NSString).range(of: "잔디가 무럭무럭 자라요"))
        self.titleLabel.attributedText = attributeString
    }
    
    @IBAction func goToMainButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
            // Perform the segue programmatically
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
}

