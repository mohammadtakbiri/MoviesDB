//
//  APIs.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation
import SwiftyJSON

class APIs {
    static let shared = APIs()
    
    private init() {}
    
    func getLatestMovies(page: Int = 1) async throws -> JSON {
        return try await Network.shared.sendRequest(
            path: Paths.moviesList,
            parameterList: ["page": page as AnyObject]
        )
    }
}
