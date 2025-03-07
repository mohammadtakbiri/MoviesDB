//
//  AppError.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation

struct AppError: LocalizedError, Identifiable {
    let message: String?
    let fReason: String?
    let statusCode: Int?
    var json: [String: Any]? = nil
    
    var id: String { UUID().uuidString }

    init(message: String?, failureReason: String = "", statusCode: Int? = nil, json: [String: Any]? = nil) {
        self.message = message ?? ""
        self.fReason = failureReason
        self.statusCode = statusCode
        self.json = json
    }
}

extension AppError {
    var errorDescription: String? { return message }
    var failureReason: String? { return fReason }
}
