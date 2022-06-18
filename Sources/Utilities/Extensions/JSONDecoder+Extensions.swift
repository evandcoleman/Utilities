//
//  JSONDecoder+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/10/22.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    public static func parseStrategy(_ strategy: Date.ParseStrategy) -> JSONDecoder.DateDecodingStrategy {
        .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            return try Date(dateString, strategy: strategy)
        })
    }
}
