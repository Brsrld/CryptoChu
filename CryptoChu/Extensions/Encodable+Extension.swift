//
//  Encodable+Extension.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 22.09.2023.
//

import Foundation
import UIKit

// MARK: - JSON
struct JSON {
    static let encoder = JSONEncoder()
}

// MARK: - Encodable Extension
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

extension Encodable {
    func encode() -> Data? {
        guard let encoded = try? JSONEncoder().encode(self) else { return nil }
        return encoded
    }
}
