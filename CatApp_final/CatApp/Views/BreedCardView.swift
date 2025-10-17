//
//  BreedCardView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct BreedCardView: View {
    @ObservedObject var breed: BreedEntity
    var toggleFavorite: () -> Void

    var body: some View {
        VStack {
            // Pass URL string, not the breed entity
            RemoteImageView(url: breed.imageUrl)
                .frame(height: 90)
                .cornerRadius(12)

            HStack {
                Text(breed.name ?? "")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: breed.isFavorite ? "star.fill" : "star")
                        .foregroundColor(breed.isFavorite ? .yellow : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.horizontal, .bottom], 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

