//
//  BmiEntity+CoreDataProperties.swift
//  Ios-Test2
//
//  Created by Krisuv Bohara on 2022-12-15.
//
//

import Foundation
import CoreData


extension BmiEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BmiEntity> {
        return NSFetchRequest<BmiEntity>(entityName: "BmiEntity")
    }

    @NSManaged public var weight: String?
    @NSManaged public var bmi: String?
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var gender: String?
    @NSManaged public var height: String?
    @NSManaged public var unit: String?

}

extension BmiEntity : Identifiable {

}
