//
//  BreedRowView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct BreedRowView: View {
    @ObservedObject var breed: BreedEntity
    var toggleFavorite: () -> Void

    var body: some View {
        HStack {
            RemoteImageView(url: breed.imageUrl)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            Text(breed.name ?? "")
                .font(.headline)
            Spacer()
            Button(action: toggleFavorite) {
                Image(systemName: breed.isFavorite ? "star.fill" : "star")
                    .foregroundColor(breed.isFavorite ? .yellow : .gray)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

