//
//  CatAppApp.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import SwiftUI

@main
struct CatAppApp: App {
    let persistence = CoreDataManager.shared

    var body: some Scene {
            WindowGroup {
                MainTabView()
                    .environment(\.managedObjectContext,persistence.context)
            }
        }
    }
