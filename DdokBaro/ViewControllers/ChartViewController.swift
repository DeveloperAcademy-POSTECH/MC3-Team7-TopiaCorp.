//
//  ChartViewController.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/31.
//

import UIKit

class ChartViewController: UIViewController {
    let month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let day = ["일", "월", "화", "수", "목", "금", "토"]
    
    @IBOutlet weak var monthLabel01: UILabel!
    @IBOutlet weak var monthLabel02: UILabel!
    @IBOutlet weak var monthLabel03: UILabel!
    @IBOutlet weak var monthLabel04: UILabel!
    @IBOutlet weak var monthLabel05: UILabel!
    
    @IBOutlet weak var dayLabel01: UILabel!
    @IBOutlet weak var dayLabel02: UILabel!
    @IBOutlet weak var dayLabel03: UILabel!
    @IBOutlet weak var dayLabel04: UILabel!
    @IBOutlet weak var dayLabel05: UILabel!
    @IBOutlet weak var dayLabel06: UILabel!
    @IBOutlet weak var dayLabel07: UILabel!
    
    @IBOutlet weak var timeLabel01: UILabel!
    @IBOutlet weak var timeLabel02: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var grassLevels: [Int: Int] = [:]
    var graphLevels: [Int: Int] = [:]
    var frontCounter = 0
    var backCounter = 0
    var currentMonth = 12
    
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
        
        let chartSquareView2 = ChartSquareView(frame: CGRect(x: 20, y: 520, width: screenWidth - 40, height: screenWidth / 2 + 10))
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
        
        print(currentMonth, month[currentMonth % 12 - 1])
        self.monthLabel01.text = month[(currentMonth - 5) % 12]
        self.monthLabel02.text = month[(currentMonth - 4) % 12]
        self.monthLabel03.text = month[(currentMonth - 3) % 12]
        self.monthLabel04.text = month[(currentMonth - 2) % 12]
        self.monthLabel05.text = month[(currentMonth - 1) % 12]
        
        let dayOfWeek = getDayOfWeek() + 7
        self.dayLabel01.text = day[(dayOfWeek - 6) % 7]
        self.dayLabel02.text = day[(dayOfWeek - 5) % 7]
        self.dayLabel03.text = day[(dayOfWeek - 4) % 7]
        self.dayLabel04.text = day[(dayOfWeek - 3) % 7]
        self.dayLabel05.text = day[(dayOfWeek - 2) % 7]
        self.dayLabel06.text = day[(dayOfWeek - 1) % 7]
        self.dayLabel07.text = day[dayOfWeek % 7]
        
        self.timeLabel01.text = "8시간"
        self.timeLabel02.text = "4시간"
        
        self.dayLabel01.textColor = .gray
        self.dayLabel02.textColor = .gray
        self.dayLabel03.textColor = .gray
        self.dayLabel04.textColor = .gray
        self.dayLabel05.textColor = .gray
        self.dayLabel06.textColor = .gray
        self.dayLabel07.textColor = .gray
        
        self.timeLabel01.textColor = .gray
        self.timeLabel02.textColor = .gray
    }
    
    func getAllData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let today = formatter.string(from: Date())
        currentMonth += Int(String(Array(today)[5]) + String(Array(today)[6]))!
        
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
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: from, to: toDate)
        return numberOfDays.day!
    }
}
