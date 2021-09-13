//
//  LocationListItem+CoreDataProperties.swift
//  Location_Time_Interval
//
//  Created by Yudhishta Dhayalan on 12/09/21.
//
//

import Foundation
import CoreData


extension LocationListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationListItem> {
        return NSFetchRequest<LocationListItem>(entityName: "LocationListItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var lattitude: String?
    @NSManaged public var longitude: String?

}
