//
//  WaterViewController.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit

class WaterViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getAllData()
        
        let width = Int(screenWidth) / 2 + 128
        for i in 0..<17 {
            for j in 0..<7 {
//                let grassGraphView = GrassGraphView(frame: CGRect(x: 306 - (18 * i), y: 108 - (18 * j), width: 15, height: 15))
                let grassGraphView = GrassGraphView(frame: CGRect(x: width - (18 * i), y: 300 + 108 - (18 * j), width: 15, height: 15), level: 0)
                view.addSubview(grassGraphView)
            }
        }
        for i in 0...getDayOfWeek() {
            let grassGraphView = GrassGraphView(frame: CGRect(x: width + 18, y: 300 + 18 * (getDayOfWeek() - i), width: 15, height: 15), level: 3)
            view.addSubview(grassGraphView)
        }
    }
    
    func getDayOfWeek() -> Int {
        let day = ["일", "월", "화", "수", "목", "금", "토"]
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        
        return day.firstIndex(of: today)!
    }
    
    func getAllData() {
        do {
            let data = try context.fetch(GrassGraphData.fetchRequest())
            print(data)
            
            for datum in data {
                print(datum.createdAt, datum.grassLevel)
            }
        } catch {
            // error
        }
    }
}

