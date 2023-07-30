//
//  GrassGraphData+CoreDataProperties.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/30.
//
//

import Foundation
import CoreData


extension GrassGraphData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GrassGraphData> {
        return NSFetchRequest<GrassGraphData>(entityName: "GrassGraphData")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var grassLevel: Int16

}

extension GrassGraphData : Identifiable {

}
