//
//  UserCoreData+CoreDataProperties.swift
//  VK
//
//  Created by Дмитрий Супрун on 17.06.22.
//
//

import Foundation
import CoreData


extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var avatarImage: String?
    @NSManaged public var likeCount: Int64
    @NSManaged public var isLike: Bool
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension UserCoreData {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImagesCoreData)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImagesCoreData)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension UserCoreData : Identifiable {

}
