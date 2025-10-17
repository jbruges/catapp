//
//  BreedDetailViewModel.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation
import CoreData

final class BreedDetailViewModel: ObservableObject {
    @Published var breed: BreedEntity
    private let repo: BreedRepository

    init(breed: BreedEntity, repo: BreedRepository) {
        self.breed = breed
        self.repo = repo
    }

    func toggleFavorite() {
        repo.toggleFavorite(breed)
    }
}

