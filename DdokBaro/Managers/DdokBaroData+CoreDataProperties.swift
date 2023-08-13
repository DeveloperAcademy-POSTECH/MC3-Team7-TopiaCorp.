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
    @NSManaged public var grassLevel: Int16
    @NSManaged public var isFailure: Bool
    @NSManaged public var remainWater: Int16
    @NSManaged public var totalMinutes: Int16

}

extension DdokBaroData : Identifiable {

}
