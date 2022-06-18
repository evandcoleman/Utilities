//
//  URLQueryItem+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/8/22.
//

import Foundation

extension Sequence where Element == URLQueryItem {
    public subscript(key: String) -> String? {
        return first { $0.name == key }?.value
    }
}
