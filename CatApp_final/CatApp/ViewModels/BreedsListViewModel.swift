//
//  BreedsListViewModel.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//
import Foundation
import CoreData
import Combine

final class BreedsListViewModel: ObservableObject {
    @Published var breeds: [BreedEntity] = []
    
    var filteredBreeds: [BreedEntity] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var error: String?

    private let repo: BreedRepository
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(repo: BreedRepository, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.repo = repo
        self.context = context
        bindSearch()
        fetchLocal()
    }

    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.fetchLocal() }
            .store(in: &cancellables)
    }

    func fetchLocal() {
        let request: NSFetchRequest<BreedEntity> = BreedEntity.fetchRequest()
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        breeds = (try? context.fetch(request)) ?? []
    }

    func refreshFromAPI() {
        isLoading = true
        repo.refreshFromAPI { [weak self] error in
            DispatchQueue.main.async {
                self?.fetchLocal()   // reload Core Data after API sync
                self?.isLoading = false
            }
        }
    }
    
    func refresh() {
        isLoading = true
        repo.refreshFromAPI { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let e = error { self?.error = e.localizedDescription }
                self?.fetchLocal()
            }
        }
    }

    func toggleFavorite(_ breed: BreedEntity) {
        repo.toggleFavorite(breed)
        fetchLocal()
    }
}

