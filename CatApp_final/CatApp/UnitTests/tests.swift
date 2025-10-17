//
//  tests.swift
//  CatAppTests
//
//  Created by Bruges on 17/10/2025.
//

import XCTest
import CoreData
@testable import CatApp

final class ViewModelTests: XCTestCase {
    
    // MARK: - In-Memory CoreData Stack
    var persistentContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        persistentContainer = NSPersistentContainer(name: "CatApp") 
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = persistentContainer.viewContext
    }
    
    override func tearDown() {
        persistentContainer = nil
        context = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    func createBreed(name: String, isFavorite: Bool = false, lifeSpan: String? = "10") -> BreedEntity {
        let breed = BreedEntity(context: context)
        breed.id = UUID().uuidString
        breed.name = name
        breed.isFavorite = isFavorite
        breed.lifeSpan = lifeSpan
        return breed
    }
    

    
 
    
    // MARK: - FavoritesViewModel Tests
    func testFetchFavoritesReturnsOnlyFavorites() throws {
        let fav1 = createBreed(name: "Abyssinian", isFavorite: true)
        let fav2 = createBreed(name: "Bengal", isFavorite: false)
        try context.save()
        
        let vm = FavoritesViewModel(context: context)
        vm.fetchFavorites()
        
        XCTAssertEqual(vm.favorites.count, 1)
        XCTAssertEqual(vm.favorites.first?.name, "Abyssinian")
    }
    
    func testAverageLifeSpanCalculation() throws {
        _ = createBreed(name: "Abyssinian", isFavorite: true, lifeSpan: "12")
        _ = createBreed(name: "Bengal", isFavorite: true, lifeSpan: "8")
        try context.save()
        
        let vm = FavoritesViewModel(context: context)
        vm.fetchFavorites()
        
        XCTAssertEqual(vm.averageLifeSpan, 10)
    }
    
}


