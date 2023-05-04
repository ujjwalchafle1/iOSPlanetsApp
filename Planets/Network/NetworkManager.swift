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
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        
        /// Get the urlString from constants
        guard let urlString = endpoint.path.isEmpty ? "\(endpoint.baseURL)" : endpoint.baseURL.appendingPathComponent(endpoint.path).absoluteString.removingPercentEncoding else {
            return completion(.failure(.invalidUrl))
        }
        
        /// Create the url from urlString
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidUrl))
        }
                
        /// Call the DataTask closer from URLSession shared instance
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            /// guard for the error situation
            guard error == nil else {
                return completion(.failure(.apiError(error!.localizedDescription)))
            }
            
            guard let data = data else {
                return completion(.failure(.emptyData))
            }
            
            let response = ResponseDecoder()
            
            do {
                let decoded = try response.decode(type.self, data: data)
                completion(.success(decoded!))
            } catch let error {
                completion(.failure(.parsingError(error.localizedDescription)))
            }
        }.resume()
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
