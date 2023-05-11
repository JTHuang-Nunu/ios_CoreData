//
//  Car+CoreDataProperties.swift
//  ios_CoreData
//
//  Created by Mac15 on 2023/5/11.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}

extension Car : Identifiable {

}
