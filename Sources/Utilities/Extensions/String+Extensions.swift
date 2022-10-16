//
//  String+URL.swift
//  Rapid
//
//  Created by Evan Coleman on 12/12/17.
//  Copyright © 2017 Evan Coleman. All rights reserved.
//

import Foundation

public extension String {
    var urlEncoded: String {
        let customAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }

    var urlQueryEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    var nilIfEmpty: Self? {
        return isEmpty ? nil : self
    }
}

extension String {
    public func pluralize(with count: Int, using character: String = "s") -> String {
        if count == 1 {
            return self
        } else {
            return self + character
        }
    }
}

extension String {
    public func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    public mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

#if canImport(UIKit)
import UIKit
extension String {
    public func asImage(pointSize: CGFloat) -> UIImage {
        let attributedString = NSAttributedString(string: self, attributes: [
            .font: UIFont.systemFont(ofSize: pointSize)
        ])
        let rect = attributedString.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: pointSize),
            options: [.usesFontLeading],
            context: nil
        )

        UIGraphicsBeginImageContext(rect.size)

        attributedString.draw(at: .zero)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
#endif

extension String {
    public func markdownifyURLs() -> AttributedString {
        guard let regex = try? NSRegularExpression(
            pattern: "(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))",
            options: [.anchorsMatchLines]
        ) else { return AttributedString(self) }

        let markdownText = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(startIndex..<endIndex, in: self),
            withTemplate: "[$1]($1)"
        )

        return (try? AttributedString(markdown: markdownText)) ?? AttributedString(self)
    }
}
