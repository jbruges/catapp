//
//  FavoritesViewModel.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation
import CoreData

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [BreedEntity] = []
    @Published var averageLifeSpan: Double? = nil
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        fetchFavorites()
    }

    func fetchFavorites() {
        let req: NSFetchRequest<BreedEntity> = BreedEntity.fetchRequest()
        req.predicate = NSPredicate(format: "isFavorite == YES")
        favorites = (try? context.fetch(req)) ?? []
        computeAverage()
    }

    private func computeAverage() {
        let spans: [Double] = favorites.compactMap { LifeSpanParser.higher(from: $0.lifeSpan).map { Double($0) } }
        
        guard !spans.isEmpty else {
            averageLifeSpan = nil
            return
        }
        
        averageLifeSpan = spans.reduce(0.0) { $0 + $1 } / Double(spans.count)
    }
}

