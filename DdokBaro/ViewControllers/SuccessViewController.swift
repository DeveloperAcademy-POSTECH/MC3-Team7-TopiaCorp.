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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var totalMinutes = 0
    var waterRemain = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var waterView: UIView!
    
    @IBOutlet weak var timeSubLabel: UILabel!
    
    @IBOutlet weak var waterSubLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var waterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllData()
        
        print(totalMinutes, "***")
        let hour = Int(totalMinutes / 3600)
        let totalTimeDouble = Double(totalMinutes)
        let minute = Int((totalTimeDouble / 60).truncatingRemainder(dividingBy: 60))
        let formattedTime = String(format: "%02d시 %02d분", hour, minute)
        waterLabel.text = "\(waterRemain)L"
        timeLabel.text = formattedTime

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
    
    func getAllData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        print(today)
        
        do {
            let data = try context.fetch(DdokBaroData.fetchRequest())
            print(data)
            for datum in data {
                if datum.createdAt == today {
                    print(datum.remainWater)
                    waterRemain = Int(datum.remainWater)
                    totalMinutes = Int(datum.totalMinutes)
                }
            }
        } catch {
            // error
        }
    }
}

