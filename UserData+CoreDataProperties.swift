//
//  UserData+CoreDataProperties.swift
//  ios_CoreData
//
//  Created by Mac15 on 2023/5/11.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var cname: String?
    @NSManaged public var cid: String?
    @NSManaged public var cimage: Data?
    @NSManaged public var own: NSSet?

}

// MARK: Generated accessors for own
extension UserData {

    @objc(addOwnObject:)
    @NSManaged public func addToOwn(_ value: Car)

    @objc(removeOwnObject:)
    @NSManaged public func removeFromOwn(_ value: Car)

    @objc(addOwn:)
    @NSManaged public func addToOwn(_ values: NSSet)

    @objc(removeOwn:)
    @NSManaged public func removeFromOwn(_ values: NSSet)

}

extension UserData : Identifiable {

}
