//
//  AnyCodable.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation

// helper type to wrap values; see anycodable from github
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    // Simple implementation for String values
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let str = value as? String {
            try container.encode(str)
        } else {
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable only supports String in this example.")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
