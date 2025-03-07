//
//  MovieDetailView.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var showFullDescription = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Poster Image Section
                ZStack(alignment: .top) {
                    // Background Image (Blurred)
                    WebImage(url: movie.posterURL)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .blur(radius: 20)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipped()
                    
                    // Main Poster
                    WebImage(url: movie.posterURL) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 200)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding(.top, 40)
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Favorite Button
                    HStack {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                favoritesManager.toggleFavorite(for: movie)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(favoritesManager.isFavorite(movieId: movie.id) ? .red : .gray)
                                .scaleEffect(favoritesManager.isFavorite(movieId: movie.id) ? 1.1 : 1.0)
                        }
                    }
                    
                    // Rating
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(movie.rating / 2) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", movie.rating))
                            .foregroundColor(.yellow)
                            .fontWeight(.semibold)
                    }
                    
                    // Release Date
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("Release Date:")
                            .foregroundColor(.gray)
                        Text(movie.releaseDate)
                            .foregroundColor(.white)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(movie.description)
                            .foregroundColor(.white)
                            .lineLimit(showFullDescription ? nil : 3)
                            .animation(.easeInOut, value: showFullDescription)
                        
                        if !showFullDescription {
                            Button("Read More") {
                                withAnimation {
                                    showFullDescription = true
                                }
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring()) {
                        favoritesManager.toggleFavorite(for: movie)
                    }
                }) {
                    Image(systemName: favoritesManager.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesManager.isFavorite(movieId: movie.id) ? .red : .gray)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MovieDetailView(movie: Movie(
            id: 1,
            posterURL: URL(string: "https://mohta.com/test.jpg")!,
            title: "Sample Movie",
            releaseDate: "2024-03-07",
            rating: 8.5,
            description: "Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum...Lore impsum..."
        ))
    }
}
