//
//  RequestError.swift
//  MisyonNewArchitecture
//
//  Created by Barış Şaraldı on 20.09.2023.
//

import Foundation

// MARK: - RequestError
enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case badImage
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decoding Error"
        case .unauthorized:
            return "Session expired"
        case .noResponse:
            return "Request does not have a response"
        default:
            return "Unknown error"
        }
    }
}
