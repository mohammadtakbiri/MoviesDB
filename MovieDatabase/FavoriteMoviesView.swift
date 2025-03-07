//
//  MovieDatabaseApp.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteMoviesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var searchText = ""
    
    private var filteredMovies: [Movie] {
        let favorites = favoritesManager.getAllFavorites()
        let movies = favorites.map { favorite in
            Movie(
                id: favorite.movieId,
                posterURL: favorite.posterURL,
                title: favorite.title,
                releaseDate: favorite.releaseDate,
                rating: favorite.rating,
                description: favorite.movieDescription
            )
        }
        
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Search Bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    if filteredMovies.isEmpty {
                        // Empty State
                        VStack(spacing: 20) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No Favorite Movies")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("Movies you mark as favorite will appear here")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                    } else {
                        // Movies List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        MovieItemView(movie: movie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .preferredColorScheme(.dark)
        }
    }
} 
