//
//   RightPostureViewController.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/30.
//

import UIKit

//올바른 자세 학습을 위한 뷰
class RightPostureViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var accumulatedTime: Int16 = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var turtleGuideImage: UIImageView!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var textOne: UILabel!
    
    @IBOutlet weak var textTwo: UILabel!
    
    let backGroundColor2 = UIView()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            textOne.setupLabelAndButton(view: textOne, systemName: "1.circle.fill", text: " 허리와 어깨를 펴고", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
            
            textTwo.setupLabelAndButton(view: textTwo, systemName: "2.circle.fill", text: " 턱을 당겨주세요!", imageColor: .pointBlue ?? .blue, textColor: .pointBlue ?? .blue, font: .boldSystemFont(ofSize: 22), pointSize: 28, weight: .bold)
            
            turtleGuideImage.image = UIImage(named: "TurtleGuide2")
           
             view.setGradient3(color1: .white, color2: UIColor(hexCode: "ECF3FF"))
            
    }
    
    @IBAction func goToWelcomeButton(_ sender: UIButton) {
        getAllData()
        createRefill()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
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
            for datum in data {
                if datum.createdAt == today {
                    accumulatedTime = datum.totalMinutes
                }
            }
        } catch {
            // error
        }
    }
    
    func createRefill() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        
        do {
            let data = try context.fetch(DdokBaroData.fetchRequest())
            for datum in data {
                if datum.createdAt == today {
                    context.delete(datum)
                }
            }

            let newData = DdokBaroData(context: context)
            newData.createdAt = today
            newData.grassLevel = 1
            newData.isFailure = (1 != 0)
            newData.remainWater = 100
            newData.totalMinutes = Int16(accumulatedTime)

            do {
                try context.save()
            } catch {
                // error
            }
        } catch {
            // error
        }
    }
}
extension UIView {
    func setGradient3(color1: UIColor, color2: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.25, 0.75]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5 ,y:1.0)
        gradientLayer.zPosition = -1
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
