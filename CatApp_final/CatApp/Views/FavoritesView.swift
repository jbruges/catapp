//
//  FavoritesView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var vm = FavoritesViewModel()
    
 
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let avg = vm.averageLifeSpan {
                    Text("Average lifespan: \(String(format: "%.1f", avg)) years")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                
                if vm.favorites.isEmpty {
                    Spacer()
                    Text("No favorite breeds yet.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.favorites, id: \.objectID) { breed in
                                NavigationLink(destination: BreedDetailView(breed: breed)) {
                                    BreedCardView(breed: breed) {
                                        breed.isFavorite = false
                                        try? breed.managedObjectContext?.save()
                                        vm.fetchFavorites()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                vm.fetchFavorites()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
}
