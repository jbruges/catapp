//
//  MainTabView.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView { BreedsListView() }
                .tabItem { Label("Breeds", systemImage: "square.grid.2x2") }

            NavigationView { FavoritesView() }
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}



