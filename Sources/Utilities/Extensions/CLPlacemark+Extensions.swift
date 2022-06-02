//
//  CLPlacemark+Extensions.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/28/21.
//

import CoreLocation
import Foundation

public extension CLPlacemark {
    var neighborhood: String? {
        if let internalPlacemark = value(forKey: "_internal") as? NSObject,
           let itemStorage = internalPlacemark.value(forKey: "geoMapItemStorage") as? NSObject,
           let addressObject = itemStorage.perform(Selector(("addressObject"))).takeUnretainedValue() as? NSObject,
           let structuredAddress = addressObject.perform(Selector(("spokenStructuredAddress")))!.takeUnretainedValue() as? NSObject,
           let neighborhoods = structuredAddress.value(forKey: "_dependentLocalitys") as? [String] {

            let isAtEnd = neighborhoods.last == subLocality
            let filtered = neighborhoods
                .filter { $0 != subLocality }
            let neighborhood = isAtEnd ? filtered.last : filtered.first

            return neighborhood ?? filtered.first
        } else {
            return nil
        }
    }
}
