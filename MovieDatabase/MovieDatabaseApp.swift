//
//  MovieDatabaseApp.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import SwiftUI
import SwiftData

@main
struct MovieDatabaseApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: FavoriteMovie.self)
            FavoritesManager.shared.initialize(with: container.mainContext)
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MovieListsView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                
                FavoriteMoviesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
        }
        .modelContainer(container)
    }
}
