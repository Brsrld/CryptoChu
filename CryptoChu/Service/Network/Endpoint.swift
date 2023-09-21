//
//  Endpoint.swift
//  MisyonNewArchitecture
//
//  Created by Barış Şaraldı on 20.09.2023.
//

import Foundation

// MARK: - Endpoint
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String : String]? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

// MARK: - Endpoint Extension
extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "bitexen.com"
    }
    
    var body: [String: Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]?  {
        return nil
    }
    
    var header: [String : String]? {
        return nil
    }
}
