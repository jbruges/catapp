//
//  BreedRepository.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation
import CoreData
import Combine

final class BreedRepository {
    private let api: CatAPIClient
    private let persistence: CoreDataManager
    private var cancellables = Set<AnyCancellable>()

    init(api: CatAPIClient, persistence: CoreDataManager = .shared) {
        self.api = api
        self.persistence = persistence
    }

    func refreshFromAPI(completion: ((Error?) -> Void)? = nil) {
        api.fetchBreeds()
            .sink(receiveCompletion: { result in
                if case .failure(let err) = result { completion?(err) }
            }, receiveValue: { [weak self] breeds in
                guard let self = self else { return }
                self.sync(breeds)
                completion?(nil)
            })
            .store(in: &cancellables)
    }

    private func sync(_ breeds: [Breed]) {
        let ctx = persistence.context
        let fetch: NSFetchRequest<BreedEntity> = BreedEntity.fetchRequest()
        let existing = (try? ctx.fetch(fetch)) ?? []
        let map = Dictionary(uniqueKeysWithValues: existing.map { ($0.id ?? "", $0) })

        for breed in breeds {
            let entity = map[breed.id] ?? BreedEntity(context: ctx)
            _ = breed.toEntity(in: ctx, existing: entity)
        }
        try? ctx.save()
    }

    func toggleFavorite(_ breed: BreedEntity) {
        breed.isFavorite.toggle()
        try? persistence.context.save()
    }
}

