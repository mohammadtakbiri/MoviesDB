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
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Oops!"),
                message: Text(error.message ?? "Bad error!"),
                dismissButton: .default(Text("Retry!")) {
                    Task {
                        await viewModel.fetchMovies(resetPages: true)
                    }
                }
            )
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
