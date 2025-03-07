//
//  MovieDatabaseApp.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private var modelContext: ModelContext?
    @Published private var favoriteIds: Set<Int> = []
    @Published private(set) var favoriteMovies: [FavoriteMovie] = []
    
    private init() {}
    
    func initialize(with context: ModelContext) {
        self.modelContext = context
        self.loadFavoriteIds()
        self.loadFavoriteMovies()
    }
    
    private func loadFavoriteIds() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<FavoriteMovie>()
        if let favorites = try? modelContext.fetch(descriptor) {
            self.favoriteIds = Set(favorites.map { $0.movieId })
        }
    }
    
    private func loadFavoriteMovies() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<FavoriteMovie>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        self.favoriteMovies = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func toggleFavorite(for movie: Movie) {
        guard let modelContext else { return }
        
        if let existing = getFavorite(movieId: movie.id) {
            modelContext.delete(existing)
            favoriteIds.remove(movie.id)
        } else {
            let favorite = FavoriteMovie(movie: movie)
            modelContext.insert(favorite)
            favoriteIds.insert(movie.id)
        }
        
        try? modelContext.save()
        loadFavoriteMovies()
        objectWillChange.send()
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favoriteIds.contains(movieId)
    }
    
    private func getFavorite(movieId: Int) -> FavoriteMovie? {
        guard let modelContext else { return nil }
        
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate<FavoriteMovie> { favorite in
                favorite.movieId == movieId
            }
        )
        
        return try? modelContext.fetch(descriptor).first
    }
    
    func getAllFavorites() -> [FavoriteMovie] {
        favoriteMovies
    }
} 
