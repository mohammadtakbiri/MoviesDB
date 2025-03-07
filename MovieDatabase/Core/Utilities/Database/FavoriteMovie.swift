//
//  MovieDatabaseApp.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    var movieId: Int
    var title: String
    var posterURL: URL
    var releaseDate: String
    var rating: Double
    var movieDescription: String
    var dateAdded: Date
    
    init(movie: Movie) {
        self.movieId = movie.id
        self.title = movie.title
        self.posterURL = movie.posterURL
        self.releaseDate = movie.releaseDate
        self.rating = movie.rating
        self.movieDescription = movie.description
        self.dateAdded = Date()
    }
} 
