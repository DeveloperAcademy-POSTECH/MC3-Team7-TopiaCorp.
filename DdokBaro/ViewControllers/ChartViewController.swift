//
//  ChartViewController.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/31.
//

import UIKit

class ChartViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var grassLevels: [Int: Int] = [:]
    var graphLevels: [Int: Int] = [:]
    var frontCounter = 0
    var backCounter = 0
    
    var dataPoints = [Double]()
    var barColor = UIColor.systemBlue
    
    var maxY : Double {
        return dataPoints.sorted(by: >).first ?? 0
    }
    
    var barGapPctOfTotal : CGFloat {
        return CGFloat(0.2) / CGFloat(dataPoints.count - 1)
    }
    
    var barWidthPctOfTotal : CGFloat {
        return CGFloat(0.8) / CGFloat(dataPoints.count)
    }
    
    var barCornerRadius : CGFloat {
        return CGFloat(30 / dataPoints.count)
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getAllData()
        backCounter = getDayOfWeek() + 1
        let width = Int(screenWidth) / 2 + 128
        
        let chartSquareView = ChartSquareView(frame: CGRect(x: 20, y: 245, width: screenWidth - 40, height: screenWidth / 2 - 20))
        view.addSubview(chartSquareView)
        
        let chartSquareView2 = ChartSquareView(frame: CGRect(x: 20, y: 520, width: screenWidth - 40, height: screenWidth / 2))
        view.addSubview(chartSquareView2)
        
        for i in 0..<17 {
            for j in 0..<7 {
                if grassLevels[self.backCounter] == nil {
                    let grassGraphView = GrassGraphView(frame: CGRect(x: width - (18 * i), y: 280 + 108 - (18 * j), width: 15, height: 15), level: 0)
                    view.addSubview(grassGraphView)
                } else {
                    let grassGraphView = GrassGraphView(frame: CGRect(x: width - (18 * i), y: 280 + 108 - (18 * j), width: 15, height: 15), level: grassLevels[self.backCounter]!)
                    view.addSubview(grassGraphView)
                }
                backCounter = backCounter + 1
            }
        }
        for i in 0...getDayOfWeek() {
            if grassLevels[self.frontCounter] == nil {
                let grassGraphView = GrassGraphView(frame: CGRect(x: width + 18, y: 280 + 18 * (getDayOfWeek() - i), width: 15, height: 15), level: 0)
                view.addSubview(grassGraphView)
            } else {
                let grassGraphView = GrassGraphView(frame: CGRect(x: width + 18, y: 280 + 18 * (getDayOfWeek() - i), width: 15, height: 15), level: grassLevels[self.frontCounter]!)
                view.addSubview(grassGraphView)
            }
            frontCounter = frontCounter + 1
        }
        
        var max = 0
        for index in 0..<7 {
            if graphLevels[6 - index] != nil {
                if max < graphLevels[6 - index]! { max = graphLevels[6 - index]! }
            }
        }
        for index in 0..<7 {
            if graphLevels[6 - index] == nil {
                dataPoints.append(3.0)
            } else {
                dataPoints.append(100 * Double(graphLevels[6 - index]!) / Double(max))
            }
        }
        
        barChartView.setData(dataPoints)
        self.view.sendSubviewToBack(chartSquareView)
        self.view.sendSubviewToBack(chartSquareView2)
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
                let calendar = Calendar.current
                let days = calendar.numberOfDays((datum.createdAt?.toDate())!, and: Date())
                grassLevels[days] = Int(datum.grassLevel)
                graphLevels[days] = Int(datum.totalMinutes)
            }
        } catch {
            // error
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
}

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.date(from: self)!
    }
}

extension Calendar {
    func numberOfDays(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: from, to: toDate)
        return numberOfDays.day!
    }
}
