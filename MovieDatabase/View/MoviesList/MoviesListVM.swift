//
//  MoviesListVM.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation
import SwiftyJSON

@MainActor
class MoviesListVM: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoadingNextPage = false
    @Published var error: AppError?
    private var currentPage = 1
    private var hasMorePages = true
    
    func fetchMovies(resetPages: Bool = false) async {
        if resetPages {
            currentPage = 1
            movies = []
            hasMorePages = true
        }
        
        guard hasMorePages, !isLoadingNextPage else { return }
        isLoadingNextPage = true
        error = nil
        
        do {
            let moviesJSON = try await APIs.shared.getLatestMovies(page: currentPage)
            guard let moviesArray = moviesJSON["results"].array,
                  let totalPages = moviesJSON["total_pages"].int else {
                error = AppError(
                    message: "Something went wrong while fetching movies.",
                    failureReason: "Invalid data format",
                    statusCode: 125
                )
                return
            }
            
            let validMovies = moviesArray.compactMap { movieJSON -> Movie? in
                guard let id = movieJSON["id"].int,
                      let title = movieJSON["title"].string,
                      !title.isEmpty,
                      let releaseDate = movieJSON["release_date"].string,
                      !releaseDate.isEmpty,
                      let posterPath = movieJSON["poster_path"].string,
                      !posterPath.isEmpty,
                      let rating = movieJSON["vote_average"].double,
                      !rating.isNaN,
                      let description = movieJSON["overview"].string,
                      !description.isEmpty,
                      let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                else { return nil }
                
                return Movie(
                    id: id,
                    posterURL: posterURL,
                    title: title,
                    releaseDate: releaseDate,
                    rating: rating,
                    description: description
                )
            }
            
            if resetPages {
                self.movies = validMovies
            } else {
                self.movies.append(contentsOf: validMovies)
            }
            
            currentPage += 1
            hasMorePages = currentPage <= totalPages
            
        } catch let error as AppError {
            self.error = error
            if resetPages {
                self.movies = []
            }
        } catch {
            self.error = AppError(
                message: "Something bad happened.",
                failureReason: error.localizedDescription,
                statusCode: 126
            )
            if resetPages {
                self.movies = []
            }
        }
        
        isLoadingNextPage = false
    }
    
    func loadNextPageIfNeeded(currentItem item: Movie) {
        guard let lastMovie = movies.last,
              lastMovie.id == item.id else { return }
        
        Task {
            await fetchMovies()
        }
    }
}
