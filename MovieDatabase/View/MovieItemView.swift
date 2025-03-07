//
//  MovieDetailView.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieItemView: View {
    let movie: Movie
    @State private var isAppeared = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Movie Poster
            WebImage(url: movie.posterURL) { image in
                image.resizable()
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            // Movie Info
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Favorite Button
            Button(action: {
                withAnimation(.spring()) {
                    favoritesManager.toggleFavorite(for: movie)
                }
            }) {
                Image(systemName: favoritesManager.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                    .foregroundColor(favoritesManager.isFavorite(movieId: movie.id) ? .red : .gray)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .opacity(isAppeared ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                isAppeared = true
            }
        }
    }
} 
