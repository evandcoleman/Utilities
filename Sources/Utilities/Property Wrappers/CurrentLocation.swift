//
//  CurrentLocation.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 1/10/22.
//

#if canImport(SwiftUI)
import CoreLocation
import Foundation
import SwiftUI

@propertyWrapper
public struct CurrentLocation {

    public var projectedValue: Coordinator = .init()

    public var wrappedValue: CLLocation? {
        return projectedValue.location
    }

    public init(projectedValue: Coordinator) {
        self.projectedValue = projectedValue
    }

    public init(wrappedValue: CLLocation?) {
        projectedValue.location = wrappedValue
    }
}

public extension CurrentLocation {
    class Coordinator: NSObject, CLLocationManagerDelegate {

        public var location: CLLocation?

        public var binding: Binding<CLLocation?> {
            return .init(get: { self.location }, set: { self.location = $0 })
        }

        private let locationManager: CLLocationManager

        public override init() {
            let locationMananger = CLLocationManager()

            self.locationManager = locationMananger

            super.init()

            self.locationManager.delegate = self
        }

        public func requestLocation() {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                locationManager.requestLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }

        public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.first
        }

        public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            location = nil
            log.error(error)
        }

        public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse {
                requestLocation()
            }
        }
    }
}
#endif
