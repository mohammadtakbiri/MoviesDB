//
//  Movie.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    let posterURL: URL
    let title: String
    let releaseDate: String
    let rating: Double
    let description: String
}
