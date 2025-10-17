//
//  BreedDetailView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct BreedDetailView: View {
    @ObservedObject var breed: BreedEntity
    @StateObject private var vm: BreedDetailViewModel

    init(breed: BreedEntity) {
        self.breed = breed
        _vm = StateObject(wrappedValue: BreedDetailViewModel(
            breed: breed,
            repo: BreedRepository(api: CatAPIClient(apiKey: Secrets.catApiKey),
                                  persistence: CoreDataManager.shared)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Image with title overlay
                ZStack(alignment: .topLeading) {
                    RemoteImageView(url: breed.imageUrl)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                    
                    // Title overlay
                    Text(breed.name ?? "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.7), radius: 3, x: 1, y: 1)
                        .padding(12)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                        .padding([.top, .leading], 16)
                }

                Text("Origin: \(breed.origin ?? "Unknown")")
                Text("Temperament: \(breed.temperament ?? "—")")
                Text("Description: \(breed.descText ?? "—")")
                    .padding(.top, 4)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: vm.toggleFavorite) {
                    Image(systemName: breed.isFavorite ? "star.fill" : "star")
                        .foregroundColor(breed.isFavorite ? .yellow : .gray)
                }
            }
        }
    }
}
