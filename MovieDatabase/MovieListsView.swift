//
//  MovieListsView.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MovieListsView: View {
    @StateObject private var viewModel = MoviesListVM()
    @State private var searchText = ""
    
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
                    
                    // Movies List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.movies.filter {
                                searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText)
                            }) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieItemView(movie: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    viewModel.loadNextPageIfNeeded(currentItem: movie)
                                }
                            }
                            
                            if viewModel.isLoadingNextPage {
                                ProgressView()
                                    .frame(height: 50)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.fetchMovies(resetPages: true)
                    }
                }
            }
            .navigationTitle("Movies")
            .preferredColorScheme(.dark)
        }
        .task {
            await viewModel.fetchMovies(resetPages: true)
        }
    }
}

struct MovieItemView: View {
    let movie: Movie
    @State private var isFavorite = false
    @State private var isAppeared = false
    
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
                isFavorite.toggle()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search movies...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    MovieListsView()
}
