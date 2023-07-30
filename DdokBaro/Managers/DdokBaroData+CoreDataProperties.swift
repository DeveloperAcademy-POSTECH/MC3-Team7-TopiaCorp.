//
//  DdokBaroData+CoreDataProperties.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/30.
//
//

import Foundation
import CoreData


extension DdokBaroData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DdokBaroData> {
        return NSFetchRequest<DdokBaroData>(entityName: "DdokBaroData")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var remainWater: Int16
    @NSManaged public var totalTime: Int16

}

extension DdokBaroData : Identifiable {

}
