//
//  String+PhoneNumber.swift
//  FourteenPoints
//
//  Created by Evan Coleman on 12/29/20.
//

import Foundation

public extension String {
    func formattedAsPhoneNumber() -> String {
        var text = self
        if count == 10 {
            text = "1" + text
        }
        let pattern = "# (###) ###-####"
        var pureNumber = text.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)

        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != "#" else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }

        return pureNumber
    }
}
