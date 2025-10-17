//
//  Breed.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation
import CoreData

struct Breed: Codable, Identifiable {
    let id: String
    let name: String
    let origin: String?
    let temperament: String?
    let description: String?
    let life_span: String?
    let image: ImageInfo?

    struct ImageInfo: Codable {
        let url: String?
    }

    func toEntity(in context: NSManagedObjectContext, existing: BreedEntity? = nil) -> BreedEntity {
        let entity = existing ?? BreedEntity(context: context)
        entity.id = id
        entity.name = name
        entity.origin = origin
        entity.temperament = temperament
        entity.descText = description
        entity.lifeSpan = life_span
        entity.imageUrl = image?.url
        entity.lastUpdated = Date()
        if let existing = existing { entity.isFavorite = existing.isFavorite }
        return entity
    }
}


