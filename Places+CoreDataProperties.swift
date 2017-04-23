//
//  Places+CoreDataProperties.swift
//  GeoPlaceDescription
//
//  Created by hjshah2 on 4/22/17.
//  Copyright © 2017 hjshah2. All rights reserved.
//

import Foundation
import CoreData


extension Places {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Places> {
        return NSFetchRequest<Places>(entityName: "Places");
    }

    @NSManaged public var address: String?
    @NSManaged public var addtitle: String?
    @NSManaged public var category: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var elevation: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}
