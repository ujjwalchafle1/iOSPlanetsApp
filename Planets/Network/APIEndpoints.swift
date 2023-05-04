//
//  APIEndpoints.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import Foundation

/// Protocol to implement for url creation
protocol EndpointType
{
    var baseURL: URL { get }
    var path: String { get }
}

/// Use this enum to create base url and endpoint path
/// Add additional cases for future API services
enum APIEndpoint {
    case planets
}

/// Create base url and path components based on the enum case.
extension APIEndpoint: EndpointType
{
    var baseURL: URL {
        switch self {
        case .planets :
            return URL(string: "https://swapi.dev/api/")!
        }
    }
    
    var path: String {
        switch self {
        case .planets :
            return "planets"
        }
    }
    
}
