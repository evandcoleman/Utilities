//
//  Result+Extensions.swift
//  
//
//  Created by Evan Coleman on 6/13/22.
//

import Foundation

extension Result {
    public func error() -> Error? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }
}
