//
//  Network.swift
//  MovieDatabase
//
//  Created by Mohammad Takbiri on 3/7/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network {
    
    static let shared = Network()
    private var session: Session = AF
    
    func sendRequest(
        path: String,
        parameterList: [String: AnyObject]? = nil
    ) async throws -> JSON {
        let defaultHeaders: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.apiKey)"
        ]
        
        let parameters: Parameters? = parameterList
        let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
        let baseUrl = "https://api.themoviedb.org/3"
        
        guard let url = URL(string: "\(baseUrl)\(path)") else {
            throw AppError(
                message: "Invalid URL",
                failureReason: "Could not construct URL",
                statusCode: 119
            )
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: encoding,
                headers: defaultHeaders
            ).validate().response { response in
                
                switch response.result {
                    
                case .success(let data):
                    guard let data = data else {
                        continuation.resume(throwing: AppError(
                            message: "There is a problem with the request. Please try again later.",
                            failureReason: "Bad data returned from the server",
                            statusCode: 120
                        ))
                        return
                    }
                    
                    do {
                        let json = try JSON(data: data)
                        
                        guard !json.isEmpty else {
                            continuation.resume(throwing: AppError(
                                message: "We can't find any data. Please try again later.",
                                failureReason: "The json is empty",
                                statusCode: 121
                            ))
                            return
                        }
                        
                        continuation.resume(returning: json)
                    } catch {
                        continuation.resume(throwing: AppError(
                            message: "We can't process your request at this time. Please try again later.",
                            failureReason: "Bad json data returned from the server",
                            statusCode: 122
                        ))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: AppError(
                        message: "\(error.localizedDescription)",
                        failureReason: "Server error",
                        statusCode: 123
                    ))
                }
            }
        }
    }
}
