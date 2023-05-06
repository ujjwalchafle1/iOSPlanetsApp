//
//  NetworkManager.swift
//  Planets
//
//  Created by Ujjwal on 28/04/2023.
//

import Foundation

// MARK: Http Method Type
enum HTTPMethod {
    case GET
}

struct NetworkManager {
    
    static func getData<T: Codable>(
        method: HTTPMethod,
        endpoint: APIEndpoint,
        dictionary:[String:String]?,
        type: T.Type
    ) async throws -> T {
        
        /// Get the urlString from constants
        guard let urlString = endpoint.path.isEmpty ? "\(endpoint.baseURL)" : endpoint.baseURL.appendingPathComponent(endpoint.path).absoluteString.removingPercentEncoding else {
            throw NetworkError.invalidUrl
        }
        
        /// Create the url from urlString
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        
        /// Call the DataTask closer from URLSession shared instance
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = ResponseDecoder()
            
            do {
                let decoded = try response.decode(type.self, data: data)
                return decoded!
            } catch let error {
                throw NetworkError.parsingError(error.localizedDescription)
            }
        } catch let error {
            throw NetworkError.apiError(error.localizedDescription)
        }
    }
}

// MARK: Success and Error scenarios Type
enum NetworkError: Error {
    case invalidUrl
    case invalidPostData
    case emptyData
    case apiError(String)
    case parsingError(String)
}
