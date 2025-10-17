//
//  BreedEntity+CoreDataProperties.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//
//

import Foundation
import CoreData


extension BreedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreedEntity> {
        return NSFetchRequest<BreedEntity>(entityName: "BreedEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var origin: String?
    @NSManaged public var temperament: String?
    @NSManaged public var descText: String?
    @NSManaged public var lifeSpan: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastUpdated: Date?

}

extension BreedEntity : Identifiable {

}
