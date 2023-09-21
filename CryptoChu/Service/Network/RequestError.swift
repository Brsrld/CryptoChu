//
//  RequestError.swift
//  MisyonNewArchitecture
//
//  Created by Barış Şaraldı on 20.09.2023.
//

import Foundation

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
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .badImage:
            return "Bad Image"
        default:
            return "Unknown error"
        }
    }
}
