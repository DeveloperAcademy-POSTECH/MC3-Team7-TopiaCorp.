//
//  Temp+coredata.swift
//  DdokBaro
//
//  Created by yusang on 2023/09/02.
//

import Foundation
import CoreData

extension MainViewController {
    
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
                    currentProgress = CGFloat(datum.remainWater) * 0.01
                    accumulatedTime = Double(datum.totalMinutes)
                }
            }
        } catch {
            // error
        }
    }

    func createData() {
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
            newData.grassLevel = Int16(3.9 * currentProgress + 1)
            newData.isFailure = (0 != 0)
            newData.remainWater = Int16(currentProgress * 100)
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

    func createFailure() {
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
            newData.grassLevel = Int16(3.9 * currentProgress + 1)
            newData.isFailure = (1 != 0)
            newData.remainWater = Int16(currentProgress * 100)
            newData.totalMinutes = Int16(accumulatedTime)
            print("***** \(newData)")
            
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
