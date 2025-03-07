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

#Preview {
    MovieListsView()
}
