//
//  ImagesCoreData+CoreDataProperties.swift
//  VK
//
//  Created by Дмитрий Супрун on 17.06.22.
//
//

import Foundation
import CoreData


extension ImagesCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagesCoreData> {
        return NSFetchRequest<ImagesCoreData>(entityName: "ImagesCoreData")
    }

    @NSManaged public var image: String?
    @NSManaged public var likeCount: Int64
    @NSManaged public var userCoreData: UserCoreData?

}

extension ImagesCoreData : Identifiable {

}
